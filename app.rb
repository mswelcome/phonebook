#PhoneBook App

require 'aws-sdk'
require 'sinatra'
require 'pg'
load './local_env.rb'
enable 'sessions'

get '/' do

erb :root


end

post '/records' do

  session[:r] = session[:r]

begin

  wbinfo = {
    host: ENV['RDS_HOST'],
    port: ENV['RDS_PORT'],
    dbname: ENV['RDS_DB_NAME'],
    user: ENV['RDS_USERNAME'],
    password: ENV['RDS_PASSWORD']
  }

  wb = PG::Connection.new(wbinfo)
  wb.exec "create table pb (
             id int primary key,
             first varchar(50),
             last varchar(50),
             street varchar(50),
             city varchar(25),
             state varchar(2),
             zip varchar(5),
             phone varchar(10)"
  wb.exec INSERT INTO public.pb id, "first", "last", street, city, state, zip)VALUES('session[:r][0]', 'session[:r][1]', 'session[:r][2]', 'session[:r][3]', 'session[:r][4]', 'session[:r][5]', 'session[:r][6]');


rescue PG::Error => e

    puts e.message

ensure

    wb.close if wb

end

  redirect '/get'
end

get '/get' do

begin

  wbinfo = {
    host: ENV['RDS_HOST'],
    port:ENV['RDS_PORT'],
    dbname:ENV['RDS_DB_NAME'],
    user:ENV['RDS_USERNAME'],
    password:ENV['RDS_PASSWORD']
  }

  wb = PG::Connection.new(wbinfo)
  rs = wb.exec 'SELECT * FROM pb LIMIT 7'

  list = []
  rs.each do |row|
    list << "%s %s %s" % [row['First'], row['Last'], row['Street'], row['City'], row['State'], row['Zip'], row['Phone']]
  end

  rescue PG::Error => e

    puts e.message

  ensure

    rs.clear if rs
    wb.close if wb

end


erb :showget, locals:{list: list}

end
