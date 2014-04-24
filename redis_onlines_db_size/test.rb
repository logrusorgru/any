require 'redis'
require 'benchmark'

# perfomance
require 'hiredis'

# `driver: :hiredis` for perfomance, `path: ""` too
$r = Redis.new driver: :hiredis, path: "/tmp/redis.sock"

count = 65000

def decr_ip c
  "255.255.#{(255255 - c).to_s.insert(3,".")}"
end

puts "Start with count: #{count}"
puts "Used memory: #{$r.info( :memory )["used_memory_human"]}"

# pipelined wrap for perfomance
$r.pipelined do
	count.times do |i|
	  #$r.set "user:#{i}", nil
	  #$r.expire "user:#{i}", 10*60
	  #$r.set "ip#{decr_ip(i)}", nil
	  #$r.expire "ip#{decr_ip(i)}", 10*60
	  # rewrite for perfomance
	  $r.set "user:#{i}", nil, ex: 10*60
	  $r.set "ip#{decr_ip(i)}", nil, ex: 10*60
	end
end

puts "stop"
puts "Used memory: #{$r.info( :memory )["used_memory_human"]}"

$r.flushdb
puts "flush"
