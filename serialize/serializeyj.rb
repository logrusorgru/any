# coding: utf-8

require 'benchmark'
require 'sqlite3'
require 'active_record'

REPEAT = 10

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

#$int_ary = (0..1001).to_a.map{ ('0'..'z').to_a.shuffle.join }
#$int_ary = ('0'..'z').to_a.shuffle.join
#$int_ary = Hash[*(0..1001).to_a]
$int_ary = (0..1001).to_a

puts "store to yml"

Benchmark.bm do |x|
	x.report { REPEAT.times { Seryml.create body: $int_ary } }
end

puts "store to json"

Benchmark.bm do |x|
	x.report { REPEAT.times { Serjsn.create body: $int_ary } }
end

puts "read from yml"

Benchmark.bm do |x|
	x.report { REPEAT.times { Seryml.all.each { |e| e.body } } }
end

puts "read from json"

Benchmark.bm do |x|
	x.report { REPEAT.times { Serjsn.all.each { |e| e.body } } }
end

puts "read json from yml"

Benchmark.bm do |x|
	x.report { REPEAT.times { Seryml.all.each { |e| e.body.to_json } } }
end

puts "read json from json"

Benchmark.bm do |x|
	x.report { REPEAT.times { Serjsn.all.each { |e| e.body.to_json } } }
end
