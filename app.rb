#PhoneBook App

require 'aws-sdk'
require 'sinatra'
require 'pg'
#require 'bcrypt'
require_relative 'functions.rb'
load './local_env.rb' if File.exist?('./local_env.rb')
enable 'sessions'

get '/' do

  #lmsg = params[:lmsg] || ""
  #createlogintable()
  erb :login
end

post '/p_login' do

  lmsg = "Login Unsucessful"
  un = params[:un]
  pw = params[:pw]


  wbinfo = {

    host: ENV['RDS_HOST'],
    port: ENV['RDS_PORT'],
    dbname: ENV['RDS_DB_NAME'],
    user: ENV['RDS_USERNAME'],
    password: ENV['RDS_PASSWORD']

  }


  wb = PG::Connection.new(wbinfo)

  compareuser = wb.exec("SELECT * FROM login WHERE user ='#{un}'")

  blah = compareuser.values.flatten
  puts "#{blah}"

  if blah.include?(pw)
      redirect '/info'
  else
      redirect '/'
  end

end

get '/info' do

umsg = params[:umsg] || ""
dmsg = params[:dmsg] || ""
erb :root

end

post '/records' do

    data = params[:data]

    createpb
    addtopb(data)

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
  umsg = "Succesful update"
  dmsg = "Succesful deletion"

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
    redirect '/?umsg=' + umsg
  elsif radio == 'delete'
    wb.exec("DELETE FROM  public.pb WHERE id = '#{qwerty}'")
    redirect '/?dmsg=' + dmsg
  else radio == 'cancel'
    redirect '/'
  end
end
