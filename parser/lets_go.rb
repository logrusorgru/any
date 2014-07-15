# coding: utf-8

#lets_go.rb

require 'watir-webdriver'
require 'watir-dom-wait'
require 'nokogiri'
require 'geocoder'

require './db/sqlite'
require ''

Geocoder.configure(:lookup => :yandex, :units => :km)
	HOME_ADDRESS = [55.834218,37.623497]