// Code generated by protoc-gen-go.
// source: frame.proto
// DO NOT EDIT!

/*
Package frame is a generated protocol buffer package.

It is generated from these files:
	frame.proto

It has these top-level messages:
	Header
*/
package frame

import proto "github.com/golang/protobuf/proto"
import fmt "fmt"
import math "math"

// Reference imports to suppress errors if they are not otherwise used.
var _ = proto.Marshal
var _ = fmt.Errorf
var _ = math.Inf

// max header length is 255 byte
// mesage_length 1-5byte
// max hallmark = 250 byte
type Header struct {
	Hallmark      []byte `protobuf:"bytes,1,opt,name=hallmark,proto3" json:"hallmark,omitempty"`
	MessageLength int32  `protobuf:"varint,2,opt,name=message_length" json:"message_length,omitempty"`
}

func (m *Header) Reset()                    { *m = Header{} }
func (m *Header) String() string            { return proto.CompactTextString(m) }
func (*Header) ProtoMessage()               {}
func (*Header) Descriptor() ([]byte, []int) { return fileDescriptor0, []int{0} }

func init() {
	proto.RegisterType((*Header)(nil), "frame.Header")
}

var fileDescriptor0 = []byte{
	// 97 bytes of a gzipped FileDescriptorProto
	0x1f, 0x8b, 0x08, 0x00, 0x00, 0x09, 0x6e, 0x88, 0x02, 0xff, 0xe2, 0xe2, 0x4e, 0x2b, 0x4a, 0xcc,
	0x4d, 0xd5, 0x2b, 0x28, 0xca, 0x2f, 0xc9, 0x17, 0x62, 0x05, 0x73, 0x94, 0x8c, 0xb8, 0xd8, 0x3c,
	0x52, 0x13, 0x53, 0x52, 0x8b, 0x84, 0x04, 0xb8, 0x38, 0x32, 0x12, 0x73, 0x72, 0x72, 0x13, 0x8b,
	0xb2, 0x25, 0x18, 0x15, 0x18, 0x35, 0x78, 0x84, 0xc4, 0xb8, 0xf8, 0x72, 0x53, 0x8b, 0x8b, 0x13,
	0xd3, 0x53, 0xe3, 0x73, 0x52, 0xf3, 0xd2, 0x4b, 0x32, 0x24, 0x98, 0x80, 0xe2, 0xac, 0x49, 0x6c,
	0x60, 0x13, 0x8c, 0x01, 0x01, 0x00, 0x00, 0xff, 0xff, 0xd5, 0xef, 0xd0, 0x0c, 0x50, 0x00, 0x00,
	0x00,
}
