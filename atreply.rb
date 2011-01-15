require 'sinatra'
require 'haml'
require './reply_chain'

set :haml, :format => :html5

get '/' do
  @page_title = 'Home'
  haml :index
end

get '/reply_chain/?' do
  @page_title = "Reply chain for id #{params[:id]}"
  @reply_chain = ReplyChain.new(params[:id])
  haml :reply_chain
end

not_found do
  @page_title = '404 - Page Not Found'
  haml :four_oh_four
end

helpers do
  def link_to url, text, options={}
    valid_options = [:class, :id]
    attributes = %Q{href="#{url}"}

    valid_options.each do |option|
      attributes = %Q{#{attributes} #{option.to_s}="#{options[option]}"}
    end

    "<a #{attributes}>#{text}</a>"
  end
end
