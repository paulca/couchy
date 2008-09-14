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
  @pages = db.view('couchy/default')['rows'].map { |r| OpenStruct.new(r['value']) }
  erb :pages
end

get '/edit/:id' do
  @page = OpenStruct.new(db.get(params[:id]))
  erb :edit
end

post '/page/:id' do
  page = OpenStruct.new(db.get(params[:id]))
  @page = db.save({"_id" => params[:id], "_rev" => page._rev, 'title' => params[:title], 'body' => params[:body]})
  redirect '/pages'
end

get '/delete/:id' do
  @page = db.get(params[:id])
  db.delete(@page)
  redirect '/pages'
end