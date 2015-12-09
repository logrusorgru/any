package frame

import (
	"github.com/golang/protobuf/proto"

	"errors"
)

const (
	MAX_RECORD_LENGTH = 65507

	MAX_HEADER_LEGTH    = 255 // ^byte(0)
	MAX_HALLMARK_LENGTH = MAX_HEADER_LEGTH - 5

	RECORD_SEPARATOR byte = 0x1e
	UNIT_SEPARATOR   byte = 0x1f
)

const maxInt32 = int((^uint32(0)) >> 1)

// Encode h to b
func Encode(h *Header) (b []byte, err error) {
	b, err = proto.Marshal(h)
	return
}

// Decode b to h
// You must know the size of b
func Decode(h *Header, b []byte) (err error) {
	err = proto.Unmarshal(b, h)
	return
}

var (
	ErrMessageTooBig = errors.New("message too big")
	ErrHeaderTooBig  = errors.New("header too big")
)

// Pack mesage to bytes
// You must to check len(hallmark)
func Pack(hallmark, msg []byte) ([]byte, error) {
	if len(msg) > maxInt32 {
		return nil, ErrMessageTooBig
	}
	h := new(Header)
	h.Hallmark = hallmark
	h.MessageLength = int32(len(msg))
	bt, err := Encode(h)
	if err != nil {
		return nil, err
	}
	if len(bt) > 255 {
		return nil, ErrHeaderTooBig
	}
	out := make([]byte, 0, 1+1+len(bt)+1+len(msg))
	out = append(out, RECORD_SEPARATOR)
	out = append(out, byte(len(bt)))
	out = append(out, bt...)
	out = append(out, UNIT_SEPARATOR)
	out = append(out, msg...)
	return out, nil
}
