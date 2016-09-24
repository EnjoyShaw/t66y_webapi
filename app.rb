require 'rubygems'
require 'sinatra/base'
require "sinatra/json"
require './t66y.rb'

class App < Sinatra::Base
  get '/' do
    page = @params[:page]
    json get_list page
  end

  get '/list' do
    url = @params[:url]
    json parse_thread parse_html url, true
  end

  get '/pictrue' do
    url = @params[:url]
    send_file(show_picture(url),:disposition => 'inline')
  end
end