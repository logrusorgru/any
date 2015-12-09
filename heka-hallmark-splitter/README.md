heka-hallmark-splitter
======================

split hallmark frames (see heka-halmark-encoder)

# Usage

```toml

[HallmarkSplitter]
use_message_bytes = true # required

[ProtobufDecoder]

[SomeHallmarkedInput]
splitter = 'HallmarkSplitter'
decoder  = 'ProtobufDecoder'
```

#### Licensing

Copyright © 2015 Konstantin Ivanov <kostyarin.ivanov@gmail.com>  
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the LICENSE.md file for more details.

