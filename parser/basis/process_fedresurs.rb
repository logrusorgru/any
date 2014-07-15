# coding: utf-8

#process_fedresurs.rb

# замест использования веб-драйвера
# чтобы не дёргать лиссицу
require 'open-uri'
require 'net/http'

require 'nokogiri'
require '../config/config'
require './log'
require './shared'

### dbg info
Log.dbg "PAGE #{PAGE}"
Log.dbg "VID_TORGOV #{VID_TORGOV}"
Log.dbg "RQ_TIMEOUT #{RQ_TIMEOUT}"
Log.dbg "RQ_FAIL_COUNT #{RQ_FAIL_COUNT}"
Log.dbg "LINKS_FOLLOW_TIMEOUT #{LINKS_FOLLOW_TIMEOUT}"
Log.dbg "REGIONS #{REGIONS}"
Log.dbg "DB_FILE #{DB_FILE}"
Log.dbg "HOME_ADDRESS #{HOME_ADDRESS}"
Log.dbg "LOGFILE #{LOGFILE}"
Log.dbg "LOG_OUTPUT #{LOG_OUTPUT}"
Log.dbg "LOG_DBG #{LOG_DBG}"

##########  ### экцепшонс
## drft ##  # превышен лимит провальных запросов
##########  #class RqFailCountLimit < Exception; end

Log.info "Погнали"

# при обработке данных с fedresurs в логах будет присутствовать префикс:
#   [fedresurs]

def follow_next_page( nxt, page )
	Log.dbg "fedresurs > follow_next_page"
	# параметры запроса
	# рекурсия чтоле?
	send_main_rq generate_params page, nil, nxt
end

# нахождение следующей страницы ( обработка пагинации )
def find_next_page( page )
	Log.dbg "fedresurs > find_next_page"
	# переход по ссылкам пагинации - это отправка формы (id: 'aspnetForm')
	# Если элемент присутствует - значит пагинация возможна
	sel = 'table#ctl00_cphBody_gvTradeList tr.pager'
	if ( pg = page.css( sel ) ).empty?
		Log.info "[fedresurs] Обработка пагинации: всего одна страница, пагинации нету."
		return
	end
	# в итоге примерно будет так
	# pg.css('table td span').first.parent.next.css('a').first[:href]
	# текущая страница?
	Log.info "[fedresurs] Обработка пагинации: текущая страница" +
	         " No. #{pg.css('table td span').first.text}"
	nxt = pg.css('table td span').first.parent.next.css('a')
	if nxt.empty?
		Log.info "[fedresurs] Обработка пагинации: это последняя страница"
		return
	end
	# Переход на следующую
	Log.info "[fedresurs] Обработка пагинации: перход на страницу No. #{nxt.first.text}"
	# где-то тут, чтоле, должен быть учёт частоты посылаемых запросов при пагинации
	wait_timeout( LINKS_FOLLOW_TIMEOUT ) do
		follow_next_page( nxt.first.text.strip, page )
	end
end

# переход по ссылке к информации о должнике
def follow_info_link( link )
	Log.dbg "fedresurs > follow_info_link"
	#
	Log.info "[fedresurs] Переход к информации о должнике.\n\tCсылка: #{link}"
end

# нахождение всех сыылок в таблице должников и передача их follow_info_link()
def get_fedresurs_links_from_table( page )
	Log.dbg "fedresurs > get_fedresurs_links_from_table"
	sel = 'table#ctl00_cphBody_gvTradeList > tr > td' + ' + td'*5 + ' > a'
	page.css( sel ).each do |a|
		wait_timeout( LINKS_FOLLOW_TIMEOUT ) do
			follow_info_link( "http://bankrot.fedresurs.ru#{a[:href]}" )
		end
		# таймаут перехода по ссылкам - LINKS_FOLLOW_TIMEOUT
	end
end

# проверка страницы на адекватность (а не бутор)
def check_page page
	Log.dbg "fedresurs > check_page"
	# 'ctl00_cphBody_gvTradeList'
	antibot_sel = 'div#ctl00_cphBody_upTradeList > span#ctl00_cphBody_antiBot_MessageLabel'
	#empty_sel   = 'table#ctl00_cphBody_gvTradeList > tr > td'
	success_sel = 'table#ctl00_cphBody_gvTradeList > tr > th'
	# проверка на сообщение о частых запросах
	unless ( msg = page.css( antibot_sel ) ).empty?
		Log.error "[fedresurs] Запросы к 'fedresurs' посылаются слишком часто, сработала анти-бот защита\n" +
		          "\tСообщение: #{msg.text}"
		fail # экцепшн
	end
	# проверка на отсутствие результатов запроса
	#("По заданным критериям не найдено ни одной записи. Уточните критерии поиска")
	if ( msg = page.css( success_sel ) ).empty?
		Log.info "[fedresurs] На сегодня записей не найдено\n"
	           "\tСообщение: #{msg.text}"
		return false
	end
	# проверка присутствия таблицы с торгами
	unless page.css( success_sel ).empty?
		Log.success "[fedresurs] Обнаружен список торгов"
		return true 
	end
	# вариант не учитывающий вышепредложенные предпологает фиксы/патчи
	# вероятен по X причинам, и при смене движка fedresurs'а
	Log.error "[fedresurs] Дальнейшие действия не определены, при обработке страницы\n" +
	          "\tне обнаружен список торгов, но он не пуст и отсутствует сообщение об ошибке\n" +
	          "\tвероятно требуется переработка кода (или заглушка этого сообщения - ах-ха-ха)"
	fail # поджтг экцепшна - чтобы разработчик не прошёл мимо
end

# собственно переход по должникам и обработка пагинации на федресурсе
def process_fedresurs_paggination page
	Log.dbg "fedresurs > process_fedresurs_paggination"
	page = Nokogiri::HTML( page )
	if check_page( page )
		# получение ссылок с таблички
		get_fedresurs_links_from_table( page )
		# найти следующую страничку выхлопа и рекурсивно вызвать эту ф-ю
		find_next_page( page )
	#else
		# return
	end
end

# submit btn name 'ctl00$cphBody$btnTradeSearch'
def send_main_rq params
	Log.dbg "fedresurs > send_main_rq"
	url = URI.parse( PAGE )
	# проверка успешности запроса
	response = rq_fail_count_loop RQ_FAIL_COUNT, RQ_TIMEOUT do
		#Net::HTTP.post_form url, params
		post_response_with_redirect url, params
	end
	# в кодировку utf-8 и погнали дальше
	process_fedresurs_paggination( response.body.force_encoding('utf-8') )
end

def generate_params page, region = nil, page_no = nil
	Log.dbg "fedresurs > generate_params"
	# селекторы
	vs_sel = '#__VIEWSTATE'
	pp_sel = '#__PREVIOUSPAGE'
	ev_sel = '#__EVENTVALIDATION'
	# значения
	vs = page.css( vs_sel ).first[:value]
	pp = page.css( pp_sel ).first[:value]
	ev = page.css( ev_sel ).first[:value]
	# текущее время, т.е дата
	current_date = Time.now.strftime('%d.%m.%Y')
	Log.dbg "[fedresurs] current_date: #{current_date}"

	params = {
	  '__VIEWSTATE'                                     => vs,
	  '__PREVIOUSPAGE'                                  => pp,
	  '__EVENTVALIDATION'                               => ev,
	  'ctl00$DebtorSearch1$inputDebtor'                 => 'поиск',
	  'ctl00$News1$hfMaxSize'                           => '3', # хз
	  'ctl00$cphBody$ucTradeType$ddlBoundList'          => VID_TORGOV, # '3'
	  'ctl00$cphBody$cldrBeginDate$tbSelectedDate'      => current_date,
	  'ctl00$cphBody$cldrBeginDate$tbSelectedDateValue' => current_date,
	  'ctl00$cphBody$cldrEndDate$tbSelectedDate'        => current_date,
	  'ctl00$cphBody$cldrEndDate$tbSelectedDateValue'   => current_date
	}
	# вставка региона
	# TODO
	# проверить каит ли запрос к новой странице без региона в поле
	unless region.nil?
		params.update(
			'ctl00$cphBody$ucRegion$ddlBoundList' => region ) # регион
	end
	# пагинация
	unless page_no.nil?
		params.update(
			'__EVENTTARGET'   => 'ctl00$cphBody$gvTradeList',
			'__EVENTARGUMENT' => "Page$#{page_no}" )
	end
	params
end

# генерация POST запроса к текущей странице
# Отправка запроса проходит в два этапа:
# I.
#   1) get запрос
#   2) получение необходимой информации:
#        - __VIEWSTATE
#        - __PREVIOUSPAGE
#        - __EVENTVALIDATION
#      это поля формы
# II.
#   1) на основе полученных данных формирование
#      списка параметров для второго запроса
#   2) посылка post запроса
# Note:
#   в последствии, для прелистывания ( обработка паггинации )
#   эти параметры така же необходимы, но их нужно обновлять с
#   каждым запросом
def get_and_post
	Log.dbg "fedresurs > get_and_post"

	# отправка get
	g_resp = rq_fail_count_loop RQ_FAIL_COUNT, RQ_TIMEOUT do
		get_response_with_redirect URI.parse PAGE
	end

	# пост запросы к основной странице
	# цикл по регионам
	REGIONS.each do |r|
		Log.dbg "fedresurs > gen_main_post_rq > REGIONS.each:\n" +
		        "\tНазвание региона: #{r[1]}\n" +
		        "\tНомер региона (значение поля): #{r[0]}"
		# log
		Log.info "[fedresurs] Выбор региона: #{r[1]}"
		# посылка пост
		send_main_rq generate_params(
			Nokogiri::HTML( g_resp.body.force_encoding('utf-8') ), # page
			r[1] ) # region, page_no = nil
	end
end


get_and_post
