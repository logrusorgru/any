package frame_test

import (
	"github.com/golang/protobuf/proto"

	"github.com/logrusorgru/heka-hallmark-encoder/frame"

	"testing"
)

var hdr = &frame.Header{
	Hallmark:      []byte("token-poken"),
	MessageLength: 25,
}

func TestProto(t *testing.T) {
	bt, err := proto.Marshal(hdr)
	if err != nil {
		t.Error(err)
	}
	th := new(frame.Header)
	err = proto.Unmarshal(bt, th)
	if err != nil {
		t.Error(err)
	}
	if !cmpbt(hdr.Hallmark, th.Hallmark) {
		t.Log("hdr", string(hdr.Hallmark))
		t.Log("th", string(th.Hallmark))
		t.Error("wrong hallmark, motherfucker")
	}
	if hdr.MessageLength != th.MessageLength {
		t.Error("wrong message length")
	}
}
