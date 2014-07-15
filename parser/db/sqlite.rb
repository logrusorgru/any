# coding: utf-8

#sqlite.rb

require 'sqlite3'
require 'active_record'

DB_FILE = 'torgi.sqlite3'
 
ActiveRecord::Base.logger = Logger.new(STDERR)
 
ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database  => DB_FILE
)
 
ActiveRecord::Schema.define do
    create_table :dolguny do |t|
        t.string :title
        t.string :performer
    end
end
