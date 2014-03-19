require 'redis'
require 'benchmark'
# add
require 'hiredis'

$rsingle = Redis.new db: 0, driver: :hiredis
#$rone    = Redis.new db: 1
#$rtwo    = Redis.new db: 2
#$rthree  = Redis.new db: 3
$r1      = Redis.new db: 1, driver: :hiredis
$r2      = Redis.new db: 2, driver: :hiredis
$r3      = Redis.new db: 3, driver: :hiredis
$r4      = Redis.new db: 4, driver: :hiredis
$r5      = Redis.new db: 5, driver: :hiredis
$r6      = Redis.new db: 6, driver: :hiredis
$r7      = Redis.new db: 7, driver: :hiredis
$r8      = Redis.new db: 8, driver: :hiredis
$r9      = Redis.new db: 9, driver: :hiredis

kv = []

#300_000.times{ |i| kv << [ i, i.to_s.reverse ] }
# 299_997.times{ |i| kv << [ i, i.to_s.reverse ] }
#90_000.times{ |i| kv << [ i, i.to_s.reverse ] }
18_000.times{ |i| kv << [ i, i.to_s.reverse ] }


### ! Flush DBs
$rsingle.flushdb
#$rone.flushdb
#$rtwo.flushdb
#$rthree.flushdb
$r1.flushdb
$r2.flushdb
$r3.flushdb
$r4.flushdb
$r5.flushdb
$r6.flushdb
$r7.flushdb
$r8.flushdb
$r9.flushdb



Benchmark.bm do |x|

  #x.report do
  #  kv.each{ |i| $rsingle.set( "user:#{i[0]}", i[1] ); $rsingle.get( "user:#{i[0]}")  }
  #end

  x.report do
    kv.each_slice 9 do |i,j,k,m,n,o,x,y,z|
      #$rsingle.pipelined do
      #$rsingle.multi do
        #$rsingle.set( "user:#{i[0]}", i[1] )
        $rsingle.sadd( "user:", i[1] )
        #$rsingle.set( "post:#{j[0]}", j[1] )
        $rsingle.sadd( "post:", j[1] )
      #end
      #$rsingle.pipelined do
      #$rsingle.multi do
        #$rsingle.set( "comment:#{k[0]}", k[1] )
        $rsingle.sadd( "comment:", k[1] )
        #$rsingle.set( "like:#{m[0]}", m[1] )
        $rsingle.sadd( "like:", m[1] )
      #end
      #$rsingle.pipelined do
      #$rsingle.multi do
        #$rsingle.set( "share:#{n[0]}", n[1] )
        $rsingle.sadd( "share:", n[1] )
        #$rsingle.set( "follow:#{o[0]}", o[1] )
        $rsingle.sadd( "follow:", o[1] )
      #end
      #$rsingle.pipelined do
      #$rsingle.multi do
        #$rsingle.set( "invite:#{x[0]}", x[1] )
        $rsingle.sadd( "invite:", x[1] )
        #$rsingle.set( "except:#{y[0]}", y[1] )
        $rsingle.sadd( "except:", y[1] )
      #end
      #$rsingle.set( "favorie:#{z[0]}", z[1] )
      $rsingle.sadd( "favorie:", z[1] )

      #$rsingle.pipelined do
      #$rsingle.multi do
        #$rsingle.get( "user:#{i[0]}" )
        $rsingle.smembers( "user:" )
        #$rsingle.get( "post:#{j[0]}" )
        $rsingle.smembers( "post:" )
      #end
      #$rsingle.pipelined do
      #$rsingle.multi do
        #$rsingle.get( "comment:#{k[0]}" )
        $rsingle.smembers( "comment:" )
        #$rsingle.get( "like:#{m[0]}" )
        $rsingle.smembers( "like:" )
      #end
      #$rsingle.pipelined do
      #$rsingle.multi do
        #$rsingle.get( "share:#{n[0]}" )
        $rsingle.smembers( "share:" )
        #$rsingle.get( "follow:#{o[0]}" )
        $rsingle.smembers( "follow:" )
      #end
      #$rsingle.pipelined do
      #$rsingle.multi do
        #$rsingle.get( "invite:#{x[0]}" )
        $rsingle.smembers( "invite:" )
        #$rsingle.get( "except:#{y[0]}" )
        $rsingle.smembers( "except:" )
      #end
      #$rsingle.get( "favorie:#{z[0]}" )
      $rsingle.smembers( "favorie:" )
    end
  end


  #x.report do
  #  kv.each_slice 3 do |i,j,k|
  #    $rone.set( i[0], i[1] )
  #    $rtwo.set( j[0], j[1] )
  #    $rthree.set( k[0], k[1] )
  #    $rone.get( i[0] )
  #    $rtwo.get( j[0] )
  #    $rthree.get( k[0] )
  #  end
  #end

  x.report do
    kv.each_slice 9 do |i,j,k,m,n,o,x,y,z|
      #$r1.set( i[0], i[1] )
      #$r1.sadd( i[0], i[1] )
      $r1.sadd( "user:", i[1] )
      #$r2.set( j[0], j[1] )
      #$r2.sadd( j[0], j[1] )
      $r2.sadd( "post:", j[1] )
      #$r3.set( k[0], k[1] )
      #$r3.sadd( k[0], k[1] )
      $r3.sadd( "comment:", k[1] )
      #$r4.set( m[0], m[1] )
      #$r4.sadd( m[0], m[1] )
      $r4.sadd( "like:", m[1] )
      #$r5.set( n[0], n[1] )
      #$r5.sadd( n[0], n[1] )
      $r5.sadd( "share:", n[1] )
      #$r6.set( o[0], o[1] )
      #$r6.sadd( o[0], o[1] )
      $r6.sadd( "follow:", o[1] )
      #$r7.set( x[0], x[1] )
      #$r7.sadd( x[0], x[1] )
      $r7.sadd( "invite:", x[1] )
      #$r8.set( y[0], y[1] )
      #$r8.sadd( y[0], y[1] )
      $r8.sadd( "except:", y[1] )
      #$r9.set( z[0], z[1] )
      #$r9.sadd( z[0], z[1] )
      $r9.sadd( "favorie:", z[1] )
      #$r1.get( i[0] )
      $r1.smembers( i[0] )
      #$r2.get( j[0] )
      $r2.smembers( j[0] )
      #$r3.get( k[0] )
      $r3.smembers( k[0] )
      #$r4.get( m[0] )
      $r4.smembers( m[0] )
      #$r5.get( n[0] )
      $r5.smembers( n[0] )
      #$r6.get( o[0] )
      $r6.smembers( o[0] )
      #$r7.get( x[0] )
      $r7.smembers( x[0] )
      #$r8.get( y[0] )
      $r8.smembers( y[0] )
      #$r9.get( z[0] )
      $r9.smembers( z[0] )
    end
  end

end


### ! Flush DBs
$rsingle.flushdb
#$rone.flushdb
#$rtwo.flushdb
#$rthree.flushdb
$r1.flushdb
$r2.flushdb
$r3.flushdb
$r4.flushdb
$r5.flushdb
$r6.flushdb
$r7.flushdb
$r8.flushdb
$r9.flushdb


# no key's prefix

#Benchmark.bm do |x|
#
#  x.report do
#    kv.each{ |i| $rsingle.set( i[0], i[1] ); $rsingle.get( i[0] )  }
#  end
#
#  #x.report do
#  #  kv.each_slice 3 do |i,j,k|
#  #    $rone.set( i[0], i[1] )
#  #    $rtwo.set( j[0], j[1] )
#  #    $rthree.set( k[0], k[1] )
#  #    $rone.get( i[0] )
#  #    $rtwo.get( j[0] )
#  #    $rthree.get( k[0] )
#  #  end
#  #end
#
#  x.report do
#    kv.each_slice 9 do |i,j,k,m,n,o,x,y,z|
#      $r1.set( i[0], i[1] )
#      $r2.set( j[0], j[1] )
#      $r3.set( k[0], k[1] )
#      $r4.set( m[0], m[1] )
#      $r5.set( n[0], n[1] )
#      $r6.set( o[0], o[1] )
#      $r7.set( x[0], x[1] )
#      $r8.set( y[0], y[1] )
#      $r9.set( z[0], z[1] )
#      $r1.get( i[0] )
#      $r2.get( j[0] )
#      $r3.get( k[0] )
#      $r4.get( m[0] )
#      $r5.get( n[0] )
#      $r6.get( o[0] )
#      $r7.get( x[0] )
#      $r8.get( y[0] )
#      $r9.get( z[0] )
#    end
#  end
#
#end

### ! Flush DBs
$rsingle.flushdb
#$rone.flushdb
#$rtwo.flushdb
#$rthree.flushdb
$r1.flushdb
$r2.flushdb
$r3.flushdb
$r4.flushdb
$r5.flushdb
$r6.flushdb
$r7.flushdb
$r8.flushdb
$r9.flushdb
