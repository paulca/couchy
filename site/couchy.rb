require 'rubygems'
require 'sinatra'
require 'couchrest'
require 'ostruct'
require 'rio'
require 'template_map'

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

get '/pages/:id' do
  @page = OpenStruct.new(db.get(params[:id]))
  rio("templates/#{@page.template}") >> (template ||= "")
  template_map = TemplateMap.new(:template => template)
  hash = {}
  template_map.fields.each do |field|
    hash[field.to_sym] = @page.send(field)
  end
  template_map.record = hash
  template_map.parsed
end

get '/templates' do
  @templates = rio('templates')
  erb :templates
end

get '/edit/:id' do
  @page = OpenStruct.new(db.get(params[:id]))
  rio("templates/#{@page.template}") >> (template ||= "")
  @fields = TemplateMap.new(:template => template).fields
  erb :edit
end

put '/pages/:id' do
  page = OpenStruct.new(db.get(params[:id]))
  hash = {"_id" => params[:id], "_rev" => page._rev, 'template' => params[:template]}
  rio("templates/#{params[:template]}") >> (template ||= "")
  fields = TemplateMap.new(:template => template).fields
  fields.each do |field|
    hash[field] = params[field]
  end
  @page = db.save(hash)
  redirect '/pages'
end

get '/delete/:id' do
  @page = db.get(params[:id])
  db.delete(@page)
  redirect '/pages'
end