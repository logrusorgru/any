# coding: utf-8

require 'redis'
require 'benchmark'

# db: 0, driver: по-умолчанию, соединение: локальная петля, но(!)
# нам нужа производительность - чтобы не ждать результатов теста долго, поэтому
# кстати вот это: `driver: :hiredis, path: "/tmp/redis.sock"`
#   увеличивает производительность чуть меньше чем в два раза
require 'hiredis'

$r = Redis.new driver: :hiredis, path: "/tmp/redis.sock"

count = 65000

Benchmark.bm do |x|
  x.report{ count.times{ |i| $r.set(i,nil,ex:10*60) } }
  x.report{ count.times{ |i| $r.pipelined{ $r.set(i,nil); $r.expire(i,10*60) } } }
end

# обнуление базы данных
$r.flushdb

#
#       user     system      total        real
#   7.540000   2.870000  10.410000 ( 11.532065)
#  13.110000   4.450000  17.560000 ( 19.195621)
