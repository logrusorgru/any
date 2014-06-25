# coding: utf-8

#shared.rb

# различные вспомогательные методы

# логи методов этого раздела имеют префикс [shared]

def wait_timeout( timeout, &blk )
	Log.dbg "shared > wait_timeout, на входе:\n" +
          "\ttimeout: #{timeout}\n" +
          "\tblock_given?: #{block_given?}"
	begin_t = Time.now
	result = yield if block_given?
	end_t = Time.now
	timeout = timeout - (end_t - begin_t ).round
	timeout = timeout > 0 ? timeout : 0
	Log.info "[shared] Ожидание #{timeout}c"
	sleep( timeout )
	result
end

# посылка запросов (через форму), с проверкой статуса
# и повторм, если провал (через timeout, count количество раз максимум)
def rq_fail_count_loop count, timeout, &blk
	Log.dbg "shared > rq_fail_count_loop, на входе:\n" +
	        "\tcount: #{count}\n" +
	        "\ttimeout: #{timeout}" +
	        "\tblock_given: #{block_given?}"
	i = 0
	response = ''
	begin
		if ( i += 1 ) > count
			Log.error "[shared] Превышен лимит провальных запросов\n" +
								"\tсделано запросов: #{i-1}\n" +
								"\tстатус ответа:    #{response.code}"
			fail # поджиг экцепшна
		end
		response = wait_timeout( timeout ){ yield if block_given? }
	end until response.is_a? Net::HTTPSuccess
	response
end

# посылка get с редиректом, если возврат имеет статус 301
# url парсить перед передачей!
def get_response_with_redirect url
	Log.dbg "shered > get_response_with_redirect\n" +
	        "\tget: #{url.to_s}"
	r = Net::HTTP.get_response( url )
	Log.info "[shared] Запрос к #{url.to_s}\n" +
	         "\tстатус: #{r.code}"
	if r.is_a? Net::HTTPMovedPermanently # 301
		new_location = URI.parse( r.header['location'] )
		new_location.host ||= url.host
		new_location.scheme ||= url.scheme
		Log.dbg "shered > get_response_with_redirect, if\n" +
		        "\tredirect to #{new_location.to_s}"
		r = get_response_with_redirect( new_location )
	end
	r
end

# посылка post с редиректом, если возврат имеет статус 301
# url парсить перед передачей!
def post_response_with_redirect url, params
	Log.dbg "shered > post_response_with_redirect\n" +
	        "\tpost: #{url.to_s}\n"
	r = Net::HTTP.post_form( url, params )
	Log.info "[shared] Запрос к #{url.to_s}\n" +
	         "\tстатус: #{r.code}"
	# 301 и 302 перенаправлене ( да redirect епта )
	if r.is_a? Net::HTTPMovedPermanently or r.is_a? Net::HTTPFound
		new_location = URI.parse( r.header['location'] )
		new_location.host ||= url.host
		new_location.scheme ||= url.scheme
		Log.dbg "shered > get_response_with_redirect, if\n" +
		        "\tredirect to #{new_location.to_s}"
		r = get_response_with_redirect( new_location )
	end
	r
end
