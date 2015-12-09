package hallmark

import (
	"github.com/logrusorgru/heka-hallmark-encoder/frame"

	"github.com/mozilla-services/heka/pipeline"

	"errors"
)

type HallmarkEncoderConfig struct {
	Hallmark string `toml:"hallmark"`
	Hostname string `toml:"hostname"`
}

type HallmarkEncoder struct {
	hallmark []byte
	hostname string
}

func (h *HallmarkEncoder) ConfigStruct() interface{} {
	return &HallmarkEncoderConfig{}
}

func (h *HallmarkEncoder) Init(config interface{}) error {
	cfg := config.(*HallmarkEncoderConfig)
	if len(cfg.Hallmark) == 0 {
		return errors.New("empty hallmark")
	} else if len(cfg.Hallmark) > frame.MAX_HALLMARK_LENGTH {
		return errors.New("hallmark too big")
	}
	h.hallmark = []byte(cfg.Hallmark)
	h.hostname = cfg.Hostname
	return nil
}

func (h *HallmarkEncoder) Encode(pack *pipeline.PipelinePack) (output []byte,
	err error) {
	if h.hostname != "" {
		pack.Message.SetHostname(h.hostname)
	}
	msg, err := pack.Message.Marshal()
	if err != nil {
		return nil, err
	}
	bt, err := frame.Pack(h.hallmark, msg)
	if err != nil {
		return nil, err
	}
	return bt, nil
}

func init() {
	pipeline.RegisterPlugin("HallmarkEncoder", func() interface{} {
		return new(HallmarkEncoder)
	})
}
