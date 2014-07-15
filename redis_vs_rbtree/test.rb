# coding: utf-8

## test.rb

####
##   Сравнение быстродействия rbtree vs redis
###
#

## необходимые гемы
#
# redis
# hiredis
# rbtree

require 'benchmark'
require 'redis'
require 'hiredis'
require 'rbtree'

# количество повторений
$count = 65000

# будем использовать в качестве id пользователей массив с числами
## массивы со случаными ключами (для упрощения ключ - это чило)
# для записи
$rndary_set = (0..$count).to_a.shuffle
# для чтения
$rndary_get = $rndary_set.shuffle

# хранение в красно-чёрном дереве
$rbtree = RBTree[] # для поиска пользователей
$rbtrev = RBTree[] # для поиска по временной метке
# хранение в Redis: .set key, nil, ex: $timeout
$redis  = Redis.new db: 0, driver: :hiredis, path: '/tmp/redis.sock'
# хранение в Redis, но в сетах ( количество сетов $timeout/$timeprec )
$redset = Redis.new db: 1, driver: :hiredis, path: '/tmp/redis.sock'

## обнуление Redis
# db: 0
$redis.flushdb
# db: 1
$redset.flushdb

# время жизни ключа, c
$timeout = 10*60

# точночть времени жизни ( интервал обнуленя умерших ), с
$timeprec = 20

##
### Реализация
##

# SET
# для установки используем id пользователя
# т.е. метод вызван - пользователь вошёл в сеть

# GET
# для получение используем id пользователя
# возвращает:
#   true - пользователь проявлял активность не раньше чем $timout
#   false - пользователь не проявлял активность вот уже $timout

# SIZE
# возвращает количество пользователей онлайн

## RBTree

# установка ключа - это просто установка id пользователя и текущей временной метки
def tree_set key
  $rbtree[key] = Time.now
end

# получение ключа
# - сравнение временной метки с текущей - $timeout
#   - возврат true если <
#   - если нет удаление ключа, возврат false
def tree_get key
	if $rbtree[key] && $rbtree[key] < Time.now - $timeout
		true
	else
		$rbtree.delete(key)
		false
	end
end

# получение количества записей
def tree_size
	$rbtree.each{ |k,v| $rbtree.delete(k) if v < Time.now - $timeout }
	$rbtree.size
end

## Redis key-val

def redis_kv_set key
	$redis.set key, nil, ex: $timeout
end

def redis_get key
	$redis.exist key
end

def redis_size
	$redis.db_size
end

## Redis set per $timeprec

def redis_kv_set key
	
end


Benchmark.bm do |x|
end

# .info( :memory )["used_memory_human"]