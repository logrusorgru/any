package frame_test

import (
	"github.com/logrusorgru/heka-hallmark-encoder/frame"

	"testing"
)

var (
	hallmark = []byte("token-poken")
	msg      = []byte("hello bad motherfucker")
)

func TestSimple(t *testing.T) {
	h := &frame.Header{hallmark, int32(len(msg))}
	b, _ := frame.Encode(h)
	frame.Decode(h, b)
	if !cmpbt(h.Hallmark, hallmark) {
		t.Error("wrong hallmark")
	}
	if int(h.MessageLength) != len(msg) {
		t.Error("wrong, the fuck, length")
	}
}

func TestEncodeDecode(t *testing.T) {
	h := new(frame.Header)
	h.Hallmark = hallmark
	h.MessageLength = int32(len(msg))
	bt, err := frame.Encode(h)
	if err != nil {
		t.Fatalf("Encode error: '%v'", err)
	}
	h.Reset()
	err = frame.Decode(h, bt)
	if err != nil {
		t.Fatalf("Decode error: '%v'", err)
	}
	if !cmpbt(h.Hallmark, hallmark) {
		t.Error("wrong hallmark")
	}
	if int(h.MessageLength) != len(msg) {
		t.Error("wrong mesage length")
	}
}

func cmpbt(a, b []byte) bool {
	if len(a) != len(b) {
		return false
	}
	for i, v := range a {
		if b[i] != v {
			return false
		}
	}
	return true
}

func TestPack(t *testing.T) {
	pk, err := frame.Pack(hallmark, msg)
	if err != nil {
		t.Fatalf("Pack error: '%v'", err)
	}
	if pk[0] != frame.RECORD_SEPARATOR {
		t.Error("missed the RECORD_SEPARATOR")
	}
	hl := int(pk[1])
	h := new(frame.Header)
	h.Hallmark = hallmark
	h.MessageLength = int32(len(msg))
	bt, err := frame.Encode(h)
	if len(bt) != hl {
		t.Fatal("wrong header length")
	}
	if !cmpbt(pk[2:2+hl], bt) {
		t.Fatal("wrong header")
	}
	if pk[2+hl] != frame.UNIT_SEPARATOR {
		t.Error("wrong unit separator")
	}
	if !cmpbt(pk[3+hl:], msg) {
		t.Error("wrong message")
	}
}
