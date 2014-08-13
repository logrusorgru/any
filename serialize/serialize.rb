# coding: utf-8

require 'benchmark'
require 'sqlite3'
require 'active_record'

REPEAT = 20
MOD    = 10

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Schema.define do
    create_table :serymls do |t|
        t.text :body
    end
 
    create_table :serjsns do |t|
        t.text :body
    end
end

class Seryml < ActiveRecord::Base
    serialize :body
end
 
class Serjsn < ActiveRecord::Base
    serialize :body, JSON
end

puts "generation"

magic_hash, magic_json, $keys = nil

Benchmark.bm do |x|
	x.report do
		magic_hash = {}
		$keys = []
		REPEAT.times { $keys.push ('a'..'z').to_a.shuffle.take(20).join }
		r = Random.new
		$keys.each do |e|
			magic_hash[e] = case r.rand(0..3)
			when 0
				('A'..'z').to_a.shuffle.take(100).join # string
			when 1
				r.rand # Float
			when 2
				Hash[*[*'A'..'Z',*'a'..'z'].push(*[*'A'..'Z',*'a'..'z']).shuffle] # Hash
			else
				('0'..'z').to_a.shuffle # Array
			end
		end
		magic_json = magic_hash.to_json
	end
end

def modder mh
	ary = $keys.shuffle.take(MOD)
	prev = mh[ary.last]
	ary.each do |e|
		tmp = mh[e]
		mh[e] = prev
		prev = tmp
	end
	return mh
end

puts "store yml"

Benchmark.bm do |x|
	x.report do
		REPEAT.times { Seryml.create body: magic_hash }
	end
end

puts "store json"

Benchmark.bm do |x|
	x.report do
		REPEAT.times { Serjsn.create body: magic_hash }
	end
end

puts "yml: read json"

Benchmark.bm do |x|
	x.report do
		REPEAT.times { Seryml.all.each { |e| e.body.to_json } }
	end
end

puts "yml: ruby modder"

Benchmark.bm do |x|
	x.report do
		REPEAT.times { Seryml.all.each { |e| modder e.body; e.save } }
	end
end

puts "yml: store from json"

Benchmark.bm do |x|
	x.report do
		REPEAT.times { Seryml.all.each { |e| e.body = JSON.parse( magic_json ); e.save } }
	end
end

puts "json: read json"

Benchmark.bm do |x|
	x.report do
		REPEAT.times { Serjsn.all.each { |e| e.body } }
	end
end

puts "json: ruby modder"

Benchmark.bm do |x|
	x.report do
		REPEAT.times { Serjsn.all.each { |e| e.body = modder e.body; e.save } }
	end
end

puts "json: store from json"

Benchmark.bm do |x|
	x.report do
		REPEAT.times { Serjsn.all.each { |e| e.body = magic_json; e.save } }
	end
end
