# coding: utf-8

require 'watir-webdriver'
require 'nokogiri'

require './sqlite'

PAGE = 'http://bankrot.fedresurs.ru/TradeList.aspx'

VID_TORGOV = 'Публичное предложение'

RQ_TIMEOUT = 1000

REGIONS = [
	'Москва',
	'Московская область',
	'Калужская область',
	'Смоленская область',
	'Тверская область',
	'Ярославская область',
	'Владимирская область',
	'Рязанская область',
	'Тульская область'
]

def regions_counter( browser )
	REGIONS.each do |r|
		# Выбор региона
		browser.text_field(name: 'ctl00$cphBody$ucRegion$ddlBoundList').select( r )
		# погнали
		browser.button(name: 'ctl00$cphBody$btnTradeSearch').click

		process_paggination( browser )

		# вздремнём чутка - чтобы страница не стопорнула за частые запросы
		sleep RQ_TIMEOUT
	end
end

def init_prepare_and_go_browser
	browser = Watir::Browser.new :firefox
	browser.goto PAGE
	browser.select_list(name: 'ctl00$cphBody$ucTradeType$ddlBoundList').select( VID_TORGOV )
	
	current_date = Time.now.strftime('%d.%m.%Y')
	# Формат: 20.05.2014 (ну или 01.01.2014 - в начале нолик)
	browser.text_field(name: 'ctl00$cphBody$cldrBeginDate$tbSelectedDate').set(current_date)
	# поджиг onchange в обязаловку - ибо силами js значение копируется в скрытое поле, по событию
	browser.text_field(name: 'ctl00$cphBody$cldrBeginDate$tbSelectedDate').fire_event 'onchange'
	browser.text_field(name: 'ctl00$cphBody$cldrEndDate$tbSelectedDate').set(current_date)
	browser.text_field(name: 'ctl00$cphBody$cldrEndDate$tbSelectedDate').fire_event 'onchange'

	regions_counter( browser )

	#rescue SomeError
		# ololo
	# ensure
		# lalala
end



