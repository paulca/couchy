require 'rubygems'
require 'sinatra'
require 'couchrest'
require 'ostruct'

def db
  connection = CouchRest.new('http://localhost:5984')
  connection.database('couchy')
end

get '/' do
   erb :index
end

get '/pages' do
  @pages = db.view('couchy/default')['rows'].map { |r| r['value'] }
  erb :pages
end

get '/editor/:id' do
  @page = OpenStruct.new(db.get(params[:id]))
  erb :editor
end