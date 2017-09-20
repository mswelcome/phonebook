#PhoneBook App

require 'aws-sdk'
require 'sinatra'
require 'pg'
load './local_env.rb' if File.exist?('./local_env.rb')
enable 'sessions'

 wbinfo = {

    host: ENV['RDS_HOST'],
    port: ENV['RDS_PORT'],
    dbname: ENV['RDS_DB_NAME'],
    user: ENV['RDS_USERNAME'],
    password: ENV['RDS_PASSWORD']

  }


  wb = PG::Connection.new(wbinfo)

get '/' do

erb :root


end

post '/records' do

    r = params[:r]
    
   
begin

  wbinfo = {

    host: ENV['RDS_HOST'],
    port: ENV['RDS_PORT'],
    dbname: ENV['RDS_DB_NAME'],
    user: ENV['RDS_USERNAME'],
    password: ENV['RDS_PASSWORD']

  }


  wb = PG::Connection.new(wbinfo)

  


  # wb.exec "create table pb (
  #            id int primary key,
  #            first varchar(50),
  #            last varchar(50),
  #            street varchar(50),
  #            city varchar(25),
  #            state varchar(2),
  #            zip varchar(5),
  #            phone varchar(10))"

  wb.exec("INSERT INTO pb(first, last, street, city, state, zip, phone)VALUES('#{r[0]}','#{r[1]}','#{r][2]}','#{r][3]}','#{r][4]}','#{r[5]}','#{r[6]}')")


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
  rs = wb.exec 'SELECT * FROM public.pb'
  p "#{rs}"

  list = []

  rs.each do |row|
     list << [row['First'], row['Last'], row['Street'], row['City'], row['State'], row['Zip'], row['Phone']]
  end

  #{}"%s %s %s %s %s %s %s" %

  rescue PG::Error => e

    puts e.message

  ensure

    rs.clear if rs
    wb.close if wb

end


  erb :showget, locals:{list: list}

end
