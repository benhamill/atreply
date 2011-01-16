require 'sinatra'
require 'haml'
require './reply_chain'

set :haml, :format => :html5

get '/' do
  @page_title = 'Home'
  haml :index
end

get '/reply_chain/?' do
  id = params[:id].split('/').last
  @page_title = "Reply chain for id #{id}"

  begin
    @reply_chain = ReplyChain.new(id)
    haml :reply_chain
  rescue Grackle::TwitterError => e
    if e.message.split(' => ').last.match(/^400/)
      haml :rate_limit
    else
      raise e
    end
  end
end

not_found do
  @page_title = '404 - Page Not Found'
  haml :four_oh_four
end

error do
  @page_title = 'Error'
  haml :error
end

helpers do
  def link_to url, text, options={}
    valid_options = [:class, :id]
    attributes = %Q{href="#{url}"}

    valid_options.each do |option|
      attributes = %Q{#{attributes} #{option.to_s}="#{options[option]}"} if options[option]
    end

    "<a #{attributes}>#{text}</a>"
  end

  def tweet_linkify text
    urls = text.gsub(/(https?:\/\/[a-zA-Z0-9_\-\/\.\?&=]+)/) do
      match = $1

      if match.end_with?('.')
        match.chop!
        period = '.'
      else
        period = nil
      end

      "#{link_to(match, match)}#{period}"
    end

    usernames = urls.gsub(/\@([a-zA-Z0-9_\-]+)/) do
      url = "http://twitter.com/#{$1}"
      "@#{link_to(url, $1)}"
    end
  end
end
