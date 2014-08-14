# coding: utf-8

# fizzbuzz.rb

(1..100).each do |i|
	if i % 15 == 0
		i = 'fizzbuzz'
	elsif	i % 3 == 0
		i = 'fizz'
	elsif i % 5 == 0
		i = 'buzz'
	end
	puts i
end
