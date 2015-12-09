package hallmark

import (
	"github.com/logrusorgru/heka-hallmark-encoder/frame"

	"github.com/mozilla-services/heka/pipeline"

	"bytes"
)

type HallmarkSplitter struct {
	header *frame.Header
	sr     pipeline.SplitterRunner
}

func (h *HallmarkSplitter) SetSplitterRunner(sr pipeline.SplitterRunner) {
	h.sr = sr
}

func (h *HallmarkSplitter) Init(_ interface{}) error { return nil }

// proof of concept http://play.golang.org/p/9Ldtq3RV9b
func (h *HallmarkSplitter) FindRecord(buf []byte) (bytesRead int,
	record []byte) {
	bytesRead = bytes.IndexByte(buf, frame.RECORD_SEPARATOR)
	if bytesRead == -1 {
		bytesRead = len(buf)
		return // read more data to find the start of the next message
	}
	if len(buf) <= bytesRead+1 {
		return // read more data to get the header length byte
	}
	headerLength := int(buf[bytesRead+1])
	// [S][L][H][H][H][U][M][M][M][ ]
	//  ^  ^        ^
	headerEnd := bytesRead + headerLength + 2 // head len + head
	if len(buf) < headerEnd {
		return // read more data to get the remainder of the header
	}
	err := frame.Decode(h.header, buf[bytesRead+2:headerEnd])
	if err != nil {
		h.sr.LogError(err)
	}
	if h.header.MessageLength != 0 || err == nil {
		// + 1 -> unit separator
		messageEnd := headerEnd + int(h.header.MessageLength) + 1
		if len(buf) < messageEnd {
			return // read more data to get the remainder of the message
		}
		record = buf[headerEnd+1 : messageEnd]
		bytesRead = messageEnd
	} else {
		var n int
		bytesRead++ // advance over the current record separator
		// header was invalid, look again
		n, record = h.FindRecord(buf[bytesRead:])
		bytesRead += n
	}
	return bytesRead, record
}

func init() {
	pipeline.RegisterPlugin("HallmarkSplitter", func() interface{} {
		return &HallmarkSplitter{
			header: new(frame.Header),
		}
	})
}
