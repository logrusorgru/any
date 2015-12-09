---
--- No docs provided. Chees.
---

local field_util = require "field_util"

local config = {
    timestamp_precision = read_config("timestamp_precision") or "ms",
}

function process_message()
    local out = ""
    out = read_message("Type") --- metric/measurement
    out = out .. ",logger=" .. read_message("Logger") --- add tag 'scollector'
    out = out .. ",host=" .. read_message("Hostname") --- add tag 'hostname'
    out = out .. " value=" .. read_message("Payload") --- set payload as value
    out = out .. " " .. field_util.message_timestamp( --- data timestamp
    	config.timestamp_precision)
    inject_payload("txt", "influx_line", out .. "\n")
    return 0
end
