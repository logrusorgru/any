# coding: utf-8

#sample.rb

require 'open-uri'
require 'net/http'
require 'nokogiri'

###
###   порядок запросов
###
#
# 1 просто get
# 2 получение параметров из тела страницы, необходимых для повторного запроса
# 3 пост с параметрами
# 4 обновление параметров с тела страницы
# 5 добавление параметров перехода на новую страницу
# 6 пост с параметрами
# 7 с пункта 4 по 6 пока не кончаться страницы )
#

url = URI.parse('http://bankrot.fedresurs.ru/TradeList.aspx')

g_resp = Net::HTTP.get_response url

puts "fuck! bad rq" or exit 0 unless g_resp.is_a? Net::HTTPSuccess

g_page = Nokogiri::HTML g_resp.body.force_encoding 'utf-8'

vs_sel = '#__VIEWSTATE'
pp_sel = '#__PREVIOUSPAGE'
ev_sel = '#__EVENTVALIDATION'

vs = g_page.css( vs_sel ).first[:value]
pp = g_page.css( pp_sel ).first[:value]
ev = g_page.css( ev_sel ).first[:value]

params = {
	  '__VIEWSTATE'                                     => vs,
	  '__PREVIOUSPAGE'                                  => pp,
	  '__EVENTVALIDATION'                               => ev,
	  'ctl00$DebtorSearch1$inputDebtor'                 => 'поиск',
	  'ctl00$News1$hfMaxSize'                           => '3',
	  'ctl00$cphBody$ucRegion$ddlBoundList'             => '45',
	  'ctl00$cphBody$ucTradeType$ddlBoundList'          => '3',
	  #'ctl00$cphBody$cldrBeginDate$tbSelectedDate'      => '22.05.2014',
	  #'ctl00$cphBody$cldrBeginDate$tbSelectedDateValue' => '22.05.2014',
	  #'ctl00$cphBody$cldrEndDate$tbSelectedDate'        => '22.05.2014',
	  #'ctl00$cphBody$cldrEndDate$tbSelectedDateValue'   => '22.05.2014'
}

sleep 3

p_resp = Net::HTTP.post_form url, params

p_page = Nokogiri::HTML p_resp.body.force_encoding 'utf-8'

File.open('sample1.html','w'){ |f| f.puts(p_resp.body.force_encoding('utf-8')) }

vs = p_page.css( vs_sel ).first[:value]
pp = p_page.css( pp_sel ).first[:value]
ev = p_page.css( ev_sel ).first[:value]

next_page = {
	  '__VIEWSTATE'       => vs,
	  '__PREVIOUSPAGE'    => pp,
	  '__EVENTVALIDATION' => ev,
	  '__EVENTTARGET'     => 'ctl00$cphBody$gvTradeList',
	  '__EVENTARGUMENT'   => 'Page$2'
}

sleep 3

np_resp = Net::HTTP.post_form url, params.update( next_page )

File.open('sample2.html','w'){ |f| f.puts(np_resp.body.force_encoding('utf-8')) }

