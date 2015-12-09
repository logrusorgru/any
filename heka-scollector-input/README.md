heka-scollector-input
=====================

[Scollector](http://bosun.org/scollector/) plugin for [heka](https://hekad.readthedocs.org/en/v0.10.0b1/index.html). Improved version.

## How to

```toml
[ScollectorInput]
config = '/path/to/scollector/config.toml' # optional
```

## Message represetation

The Scollector data point is
```go
type DataPoint struct {
	Metric		string		`json:"metric"`
	Timestamp	int64		`json:"timestamp"`
	Value		interface{}	`json:"value"`
	Tags		TagSet		`json:"tags"`
}
```

Turn to Heka's message:
```
Metric		-> message.Type
Value		-> message.Payload (as string)
Tags		-> message.Fields
```

What about timestamp? Unfortunately _data point_ has wrong timestamp. And
`message.Timestamp` is set to current time (`time.Now().UnixNano()`).

## Passing data to InfluxDB

This repository contails file called `scollector-heka-influx.lua`.
Example config:
```toml
[ScollectorInput]

[ScollectorInfluxdbLineEncoder]
type = "SandboxEncoder"
filename = "/path/to/the/scollector-heka-influx.lua" # choose proper location of the file

	[ScollectorInfluxdbLineEncoder.config]
	timestamp_precision= "s"

[InfluxdbOutput]
type = "HttpOutput"
message_matcher = 'Logger=="scollector"' # use only for scollectors messages
encoder = "ScollectorInfluxdbLineEncoder"
address = "http://127.0.0.1:8086/write?db=scoll&precision=s&u=username&p=password"
# username and password are optional
```

#### Licensing

Copyright © 2015 Konstantin Ivanov <kostyarin.ivanov@gmail.com>  
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the LICENSE.md file for more details.
