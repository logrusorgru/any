require 'redis'
require 'benchmark'

$rsingle = Redis.new db: 0
$rone    = Redis.new db: 1
$rtwo    = Redis.new db: 2
$rthree  = Redis.new db: 3

kv = []

300_000.times{ |i| kv << [ i, i.to_s.reverse ] }

Benchmark.bm do |x|

  x.report do
    kv.each{ |i| $rsingle.set( "user:#{i[0]}", i[1] ); $rsingle.get( "user:#{i[0]}")  }
  end

  x.report do
    kv.each_slice 3 do |i,j,k|
      $rone.set( i[0], i[1] )
      $rtwo.set( j[0], j[1] )
      $rthree.set( k[0], k[1] )
      $rone.get( i[0] )
      $rtwo.get( j[0] )
      $rthree.get( k[0] )
    end
  end

end


### ! Flush DBs
$rsingle.flushdb
$rone.flushdb
$rtwo.flushdb
$rthree.flushdb

# no key's prefix

Benchmark.bm do |x|

  x.report do
    kv.each{ |i| $rsingle.set( i[0], i[1] ); $rsingle.get( i[0] )  }
  end

  x.report do
    kv.each_slice 3 do |i,j,k|
      $rone.set( i[0], i[1] )
      $rtwo.set( j[0], j[1] )
      $rthree.set( k[0], k[1] )
      $rone.get( i[0] )
      $rtwo.get( j[0] )
      $rthree.get( k[0] )
    end
  end

end

### ! Flush DBs
$rsingle.flushdb
$rone.flushdb
$rtwo.flushdb
$rthree.flushdb
