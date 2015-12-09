heka-hallmark-encoder
=====================

Add the specific hallmark to each heka message.
It uses its own stream framing. Max length of hallmark
is 250 byte. The hallmark is required.

#### Configs

```toml
[HallmarkEncoder]
hallmark        = "token-poken"
hostname        = "machine #3"   # optional set the hostname

[SomeOutput]
message_matcher = "TRUE"
use_framing     = false
encoder         = "HallmarkEncoder"
```

#### Hostname

If the hostname is not set, it will remain.
Otherwise it will be overwritten.

#### Licensing

Copyright © 2015 Konstantin Ivanov <kostyarin.ivanov@gmail.com>  
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the LICENSE.md file for more details.
