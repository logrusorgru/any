package main

import (
	"github.com/BurntSushi/toml"

	"github.com/logrusorgru/heka-hallmark-encoder/frame"

	"bufio"
	"flag"
	"io"
	"log"
	"net"
	"os"
	"os/signal"
	"runtime"
	"sync"
	"syscall"
)

var (
	fConfig = flag.String("config", "", "path to config.toml")
	fHelp   = flag.Bool("help", false, "show this help")
)

type User struct {
	Net      string `toml:"net"`
	Address  string `toml:"address"`
	Hallmark string `toml:"hallmark"`
}

type ProxyConfig struct {
	Net   string  `toml:"net"`
	Bind  string  `toml:"bind"`
	Users []*User `toml:"users"`
}

func init() {
	flag.Parse()
}

var cfg *ProxyConfig

func readConfig() (err error) {
	cfg = new(ProxyConfig)
	_, err = toml.DecodeFile(*fConfig, cfg)
	return
}

func unix() bool {
	return runtime.GOOS == "darwin" ||
		runtime.GOOS == "freebsg" ||
		runtime.GOOS == "linux" ||
		runtime.GOOS == "openbsd" ||
		runtime.GOOS == "netbsd" ||
		runtime.GOOS == "dragonfly" ||
		runtime.GOOS == "solaris" ||
		runtime.GOOS == "android"
}

func main() {
	if len(*fConfig) == 0 {
		log.Println("config file required")
		os.Exit(1)
	}
	err := readConfig()
	if err != nil {
		log.Fatalln(err)
	}
	initOuts()
	l, err := net.Listen(cfg.Net, cfg.Bind)
	if err != nil {
		log.Fatalln(err)
	}
	lwg := new(sync.WaitGroup)
	go listen(l, lwg)
	c := make(chan os.Signal, 1)

	if unix() {
		signal.Notify(c, syscall.SIGINT, syscall.SIGTERM,
			syscall.SIGQUIT, syscall.SIGHUP)
	} else {
		signal.Notify(c, os.Interrupt)
	}

	<-c

	l.Close()

	log.Println("shutdown")
	lwg.Wait()
}
func listen(l net.Listener, lwg *sync.WaitGroup) {
	defer lwg.Done()
	defer l.Close()
	cwg := new(sync.WaitGroup)
	for {
		c, err := l.Accept()
		if err != nil {
			return
		}
		log.Println("accept")
		cwg.Add(1)
		go handle(c, cwg)
	}
	cwg.Wait()
}

func findBegining(r *bufio.Reader, s byte) (err error) {
	var c byte
	for {
		c, err = r.ReadByte()
		if err != nil {
			return
		}
		if c == s {
			err = r.UnreadByte()
			return
		}
	}
	return
}

//proxy
func handle(c net.Conn, cwg *sync.WaitGroup) {
	defer cwg.Done()
	defer c.Close()
	br := bufio.NewReader(c)
	h := new(frame.Header)
	for {
		err := findBegining(br, frame.RECORD_SEPARATOR)
		if err != nil {
			return
		}
		ps, err := br.Peek(2) // separator & header length
		if err != nil {
			return
		}
		headerLength := int(ps[1])
		ps, err = br.Peek(headerLength + 3) // + unit separator
		if err != nil {
			return
		}
		err = frame.Decode(h, ps[2:len(ps)-1])
		if err != nil {
			log.Println("[DEC] error:", err)
			continue
		}
		if ps[len(ps)-1] != frame.UNIT_SEPARATOR { // it is not a frame
			continue
		}
		o := getDestination(string(h.Hallmark))
		if o == nil {
			log.Println("destination not found")
			// no destination found, skip the message
			_, err = br.Discard(2 + headerLength + 1 + int(h.MessageLength))
			if err != nil {
				log.Println("discard error:", err)
			}
		} else {
			log.Println("copy to destination")
			o.mx.Lock()
			_, err = io.CopyN(o.cn, br,
				int64(2+headerLength+1)+int64(h.MessageLength))
			if err != nil {
				o.cn.Close()
				o.cn = nil
				log.Println("copy error:", err)
			}
			o.mx.Unlock()
		}
	}
}

type out struct {
	net  string
	addr string
	cn   net.Conn
	mx   sync.Mutex
}

func initOuts() {
	outs = new(Outs)
	d := make(map[string]*out)
	for _, u := range cfg.Users {
		d[u.Hallmark] = &out{
			net:  u.Net,
			addr: u.Address,
			cn:   nil,
			mx:   sync.Mutex{},
		}
	}
	outs.data = d
}

type Outs struct {
	sync.Mutex
	data map[string]*out
}

var outs *Outs

func getDestination(hm string) *out {
	outs.Lock()
	defer outs.Unlock()
	d, ok := outs.data[hm]
	if !ok {
		return nil
	}
	if d.cn == nil {
		var err error
		d.cn, err = net.Dial(d.net, d.addr)
		if err != nil {
			log.Println("dial error:", err)
			return nil
		}
	}
	return d
}
