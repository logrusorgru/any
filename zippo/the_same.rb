# coding: utf-8

require 'zlib'

# ARGV[0] compile or load
# ARGV[1] file

case ARGV[0]
when 'gz'
	File.open("#{File.basename(ARGV[1])}.gz",'w') do |f|
		f << Zlib::Deflate.deflate( File.open( ARGV[1],'r' ){ |r| r.read } )
	end
when 'unz'
	File.open( ARGV[1], 'r') do |f|
		 File.open("#{File.basename(ARGV[1],'gz')}",'w'){ |w| w << Zlib::Inflate.inflate( f.read ) }
	end
else
	puts 'need options'
end
