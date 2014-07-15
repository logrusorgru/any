# coding: utf-8

#log.rb

require '../config/config'

### Цвета

class String
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def no_colors; self.gsub( /\033\[\d+m/, '' ) end
end

### Логер

module Log

	def self.info( msg );		  chose_out "INFO: #{msg}"	        end
	def self.error( msg );		chose_out "ERROR: #{msg}".red	    end
	def self.success( msg );	chose_out "SUCCESS: #{msg}".green	end
	def self.dbg( msg )
		chose_out "DBG: #{msg}".cyan if LOG_DBG
	end
	def self.init;	          File.new( LOGFILE, 'w' )	        end

	class << self
		private
			def chose_out( msg )
				# добавление отметки времени
				msg = "[#{Time.now.strftime('%k:%M:%S %-d/%-m/%y')}] #{msg}"
				# выбор вывода: файл и stdout или то или то поодиночке
				case LOG_OUTPUT
				when :both
				# оба
					File.open( LOGFILE, 'a' ){ |f| f.puts msg.no_colors }
					puts msg
				when :file
				# только файл
					File.open( LOGFILE, 'a' ){ |f| f.puts msg.no_colors }
				else # stdout
				# только stdout
					puts msg
				end # case
			end # def

	# end class << self
	end

# end of module
end

Log.init
