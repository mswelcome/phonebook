#PhoneBook App

require 'aws-sdk'
require 'sinatra'
require 'pg'
require_relative 'functions.rb'
load './local_env.rb' if File.exist?('./local_env.rb')
enable 'sessions'


get '/' do

erb :root


end

post '/records' do

    data = params[:data]

    #createpb
    #addtopb(data)

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
  rs = wb.exec('SELECT * FROM public.pb')
  p "#{rs[0]}"

  #qwerty = rs.values
  #list = ""

  # rs.each do |row|
  #    list << [row['first'], row['last'], row['Street'], row['City'], row['State'], row['Zip'], row['Phone']]
  #    #list << row[1]
  #    #list << row[2]
  #    #list << "<br>"
  # end

  #puts "#{list}"

  #{}"%s %s %s %s %s %s %s" %

  rescue PG::Error => e

    puts e.message

  ensure

    wb.close if wb
  end



  erb :showget, locals:{rs: rs}

end

post '/update' do
  qwerty = params[:qwerty]


  redirect '/options?qwerty=' + qwerty
end

get '/options' do
  qwerty = params[:qwerty]

  wbinfo = {

    host: ENV['RDS_HOST'],
    port:ENV['RDS_PORT'],
    dbname:ENV['RDS_DB_NAME'],
    user:ENV['RDS_USERNAME'],
    password:ENV['RDS_PASSWORD']

  }

  wb = PG::Connection.new(wbinfo)

  up = wb.exec("SELECT * FROM pb WHERE id = '#{qwerty}'")

  erb :change, locals:{up: up, qwerty: qwerty}
end

post '/p_change' do
  qwerty = params[:qwerty]
  first = params[:first]
  last = params[:last]
  street = params[:street]
  city = params[:city]
  state = params[:state]
  zip = params[:zip]
  phone = params[:phone]
  radio = params[:radio]

  wbinfo = {

    host: ENV['RDS_HOST'],
    port:ENV['RDS_PORT'],
    dbname:ENV['RDS_DB_NAME'],
    user:ENV['RDS_USERNAME'],
    password:ENV['RDS_PASSWORD']

  }

  wb = PG::Connection.new(wbinfo)

  if radio == 'update'
    wb.exec("UPDATE public.pb SET first='#{first}', last='#{last}', street='#{street}', city='#{city}', state='#{state}', zip='#{zip}', phone='#{phone}' WHERE id = '1'")
  elsif radio == 'delete'
    wb.exec("DELETE FROM  public.pb WHERE id = '#{qwerty}'")
  else radio == 'cancel'
    redirect '/'
  end
end
