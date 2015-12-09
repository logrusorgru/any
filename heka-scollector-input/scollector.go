package scollector

import (
	// scollectror
	"bosun.org/cmd/scollector/collectors"
	"bosun.org/cmd/scollector/conf"
	"bosun.org/opentsdb"
	// uuid
	"github.com/pborman/uuid"
	// toml
	"github.com/BurntSushi/toml"
	// heka
	"github.com/mozilla-services/heka/message"
	"github.com/mozilla-services/heka/pipeline"

	"fmt"
	"time"
)

/*

[ScollectorInput]
config = "/path/to/scollector/config.toml"

*/

type ScollectorInput struct {
	cquit    chan struct{}            // stop
	cdp      chan *opentsdb.DataPoint // data input
	hostname string
}

func (s *ScollectorInput) Init(config interface{}) error {
	var loc string
	var err error
	conf := &conf.Conf{
		Freq: 15,
	}
	pth, ok := (config.(pipeline.PluginConfig))["config"]
	if ok { // if 'config' options present
		loc, ok = pth.(string)
		if !ok {
			return fmt.Errorf(
				"Wrong config path type, expected string ,got %T", pth)
		}
		conf, err = readConf(loc) // read config file
		if err != nil {
			return err
		}
	}
	if !conf.Tags.Valid() {
		return fmt.Errorf("invalid tags: %v", conf.Tags)
	} else if conf.Tags["host"] != "" {
		return fmt.Errorf("host not supported in custom tags," +
			" use Hostname instead")
	}
	collectors.AddTags = conf.Tags
	s.hostname = conf.Hostname
	if conf.ColDir != "" {
		collectors.InitPrograms(conf.ColDir)
	}
	check := func(e error) {
		if e != nil {
			err = e
		}
	}
	collectors.Init(conf)
	for _, r := range conf.MetricFilters {
		check(collectors.AddMetricFilters(r))
	}
	for _, rmq := range conf.RabbitMQ {
		check(collectors.RabbitMQ(rmq.URL))
	}
	for _, cfg := range conf.SNMP {
		check(collectors.SNMP(cfg, conf.MIBS))
	}
	for _, i := range conf.ICMP {
		check(collectors.ICMP(i.Host))
	}
	for _, a := range conf.AWS {
		check(collectors.AWS(a.AccessKey, a.SecretKey, a.Region))
	}
	for _, v := range conf.Vsphere {
		check(collectors.Vsphere(v.User, v.Password, v.Host))
	}
	for _, p := range conf.Process {
		check(collectors.AddProcessConfig(p))
	}
	for _, p := range conf.ProcessDotNet {
		check(collectors.AddProcessDotNetConfig(p))
	}
	for _, h := range conf.HTTPUnit {
		if h.TOML != "" {
			check(collectors.HTTPUnitTOML(h.TOML))
		}
		if h.Hiera != "" {
			check(collectors.HTTPUnitHiera(h.Hiera))
		}
	}
	for _, r := range conf.ElasticIndexFilters {
		check(collectors.AddElasticIndexFilter(r))
	}
	for _, r := range conf.Riak {
		check(collectors.Riak(r.URL))
	}
	if err != nil {
		return err
	}
	collectors.KeepalivedCommunity = conf.KeepalivedCommunity
	// Add all process collectors. This is platform specific.
	collectors.WatchProcesses()
	collectors.WatchProcessesDotNet()
	c := collectors.Search(conf.Filter)
	if len(c) == 0 {
		return fmt.Errorf("Filter %v matches no collectors.", conf.Filter)
	}
	for _, col := range c {
		col.Init()
	}
	freq := time.Second * time.Duration(conf.Freq)
	if freq <= 0 {
		return fmt.Errorf("freq must be > 0")
	}
	collectors.DefaultFreq = freq
	cdp, cquit := collectors.Run(c)
	s.cdp = cdp
	s.cquit = cquit
	return nil
}

func (s *ScollectorInput) Run(ir pipeline.InputRunner,
	h pipeline.PluginHelper) (err error) {
	for {
		select {
		case <-s.cquit: // means _,_ =<-s.cquit
			return
		case dp := <-s.cdp: // read next data point from scollector
			/*
				type DataPoint struct {
					Metric		string		`json:"metric"`
					Timestamp	int64		`json:"timestamp"`
					Value		interface{}	`json:"value"`
					Tags		TagSet		`json:"tags"`
				}
			*/
			pack, ok := <-ir.InChan() // get new pack
			if !ok {
				return
			}
			pm := pack.Message           // short hand
			pm.SetUuid(uuid.NewRandom()) // uuid
			// unfortunately dp has wrong timestamp
			// set it here
			// actually it is not timestamp of metric
			// but it's close
			pm.SetTimestamp(time.Now().UnixNano()) // now
			pm.SetType(dp.Metric)                  // string, metric name
			pm.SetPayload(fmt.Sprint(dp.Value))    // interface{} value
			pm.SetLogger("scollector")             // logger name
			pm.SetHostname(s.hostname)
			for n, v := range dp.Tags { // Tags -> Fields
				fld, _ := message.NewField(n, v, v)
				pm.AddField(fld)
			}
			ir.Deliver(pack) // send it
		}
	}
	return
}

func (s *ScollectorInput) Stop() {
	close(s.cquit)
}

func readConf(loc string) (*conf.Conf, error) {
	conf := &conf.Conf{
		Freq: 15,
	}
	md, err := toml.DecodeFile(loc, conf)
	if err != nil {
		return nil, err
	}
	if u := md.Undecoded(); len(u) > 0 {
		return nil, fmt.Errorf("extra keys in %s: %v", loc, u)
	}
	return conf, nil
}

func init() {
	pipeline.RegisterPlugin("ScollectorInput", func() interface{} {
		return new(ScollectorInput)
	})
}
