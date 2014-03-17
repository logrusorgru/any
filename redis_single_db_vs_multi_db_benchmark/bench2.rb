require 'redis'
require 'benchmark'
# add
require 'hiredis'

# init db

$rsingle = Redis.new db: 0, driver: :hiredis

$r1      = Redis.new db: 1, driver: :hiredis
$r2      = Redis.new db: 2, driver: :hiredis
$r3      = Redis.new db: 3, driver: :hiredis
$r4      = Redis.new db: 4, driver: :hiredis
$r5      = Redis.new db: 5, driver: :hiredis
$r6      = Redis.new db: 6, driver: :hiredis
$r7      = Redis.new db: 7, driver: :hiredis
$r8      = Redis.new db: 8, driver: :hiredis
$r9      = Redis.new db: 9, driver: :hiredis


# init values

$kv = []

# init keys postfix

$postfixes = [ "user",
						 	 "post",
							 "like",
					"followers",
							"share",
						 "except",
					 "favorite",
						"comment",
							 "last" ]


# init members count

$members = 9000

# init members ary

$values = []

# and set it

$members.times{ |i| $values << i }

# init keys count

$keys = 9000

# fill key-values array

def fill_values postfix=true
	$kv = []
	$keys.times do |i|
		if postfix
			$kv << { "#{i}:#{$postfixes.sample}" => $values }
		else
			$kv << { i => $values }
		end
	end
end

def flushdb
	$rsingle.flushdb
	$multi.each{ |r| r.flushdb }
end

# wrap = :pipelined | :multi, default => false
# group = 9,3,2 or :none
# postfix = true | false, default => false
#
def test options={}
	options[:wrap] ||= false
	options[:group] ||= :none
	options[:postfix] ||= false

	flushdb

	fill_values options[:postfix]

	puts "TEST ( keys: #{$keys}, members: #{$members}, " +
			"postfix: #{postfix},  wrap: #{options[:wrap]}), group: #{options[:group]}"

	case options[:wrap]
	when :pipelined then test_with_pipelined options[:group]
	when :multi then test_with_multi options[:group]
	else test_wisout_wrap
	end
end


def test_with_pipelined g
end

def test_with_multi g
end

def test_wisout_wrap
end


def bm single_set, single_get, multi_set, multi_get
	Benchmark.bm do |x|
		x.report &single_set
		x.report &single_get
		x.report &multi_set
		x.report &multi_get
	end
end

Benchmark.bm do |x|

  #x.report do
  #  kv.each{ |i| $rsingle.set( "user:#{i[0]}", i[1] ); $rsingle.get( "user:#{i[0]}")  }
  #end

  x.report do
    kv.each_slice 9 do |i,j,k,m,n,o,x,y,z|
    	# set
      $rsingle.sadd( "user:", i[1] )
      $rsingle.sadd( "post:", j[1] )
      $rsingle.sadd( "comment:", k[1] )
      $rsingle.sadd( "like:", m[1] )
      $rsingle.sadd( "share:", n[1] )
      $rsingle.sadd( "follow:", o[1] )
      $rsingle.sadd( "invite:", x[1] )
      $rsingle.sadd( "except:", y[1] )
      $rsingle.sadd( "favorie:", z[1] )
      # get
      $rsingle.smembers( "user:" )
      $rsingle.smembers( "post:" )
      $rsingle.smembers( "comment:" )
      $rsingle.smembers( "like:" )
      $rsingle.smembers( "share:" )
      $rsingle.smembers( "follow:" )
      $rsingle.smembers( "invite:" )
      $rsingle.smembers( "except:" )
      $rsingle.smembers( "favorie:" )
    end
  end

  x.report do
    kv.each_slice 9 do |i,j,k,m,n,o,x,y,z|
      $r1.sadd( "user:", i[1] )
      $r2.sadd( "post:", j[1] )
      $r3.sadd( "comment:", k[1] )
      $r4.sadd( "like:", m[1] )
      $r5.sadd( "share:", n[1] )
      $r6.sadd( "follow:", o[1] )
      $r7.sadd( "invite:", x[1] )
      $r8.sadd( "except:", y[1] )
      $r9.sadd( "favorie:", z[1] )
      $r1.smembers( i[0] )
      $r2.smembers( j[0] )
      $r3.smembers( k[0] )
      $r4.smembers( m[0] )
      $r5.smembers( n[0] )
      $r6.smembers( o[0] )
      $r7.smembers( x[0] )
      $r8.smembers( y[0] )
      $r9.smembers( z[0] )
    end
  end

end

