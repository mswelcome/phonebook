#Functions for Phonebook

require 'pg'
load './local_env.rb' if File.exist?('./local_env.rb')

def addtopb(data)

  wbinfo = {

    host: ENV['RDS_HOST'],
    port: ENV['RDS_PORT'],
    dbname: ENV['RDS_DB_NAME'],
    user: ENV['RDS_USERNAME'],
    password: ENV['RDS_PASSWORD']

  }


  wb = PG::Connection.new(wbinfo)

  wb.exec("INSERT INTO public.pb(first, last, street, city, state, zip, phone)VALUES('#{data[0]}','#{data[1]}','#{data[2]}','#{data[3]}','#{data[4]}','#{data[5]}','#{data[6]}')")

end

def createpb()

  begin

    wbinfo = {

      host: ENV['RDS_HOST'],
      port: ENV['RDS_PORT'],
      dbname: ENV['RDS_DB_NAME'],
      user: ENV['RDS_USERNAME'],
      password: ENV['RDS_PASSWORD']

    }


    wb = PG::Connection.new(wbinfo)

     wb.exec ("CREATE TABLE public.pb (
                id serial NOT NULL,
                first varchar(50),
                last varchar(50),
                street varchar(50),
                city varchar(25),
                state varchar(25),
                zip varchar(5),
                phone varchar(10))");

    rescue PG::Error => e

      puts e.message

    ensure

      wb.close if wb

    end


end

def createlogintable()

  begin

    wbinfo = {

      host: ENV['RDS_HOST'],
      port: ENV['RDS_PORT'],
      dbname: ENV['RDS_DB_NAME'],
      user: ENV['RDS_USERNAME'],
      password: ENV['RDS_PASSWORD']

    }


    wb = PG::Connection.new(wbinfo)

     wb.exec ("CREATE TABLE public.login(
                id serial NOT NULL,
                user varchar(50),
                pass varchar(50))");

    rescue PG::Error => e

      puts e.message

    ensure

      wb.close if wb

    end
end
