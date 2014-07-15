# coding: utf-8

# fizzbuzz.rb

(1..100).each do |i|
	i = 'fizzbuzz' if i % 15 == 0
	i = 'fizz' if i % 3 == 0
	i = 'buzz' if i % 5 == 0
	puts i
end
