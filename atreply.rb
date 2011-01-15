require 'sinatra'
require 'haml'

set :haml, :format => :html5

get '/' do
  @page_title = 'Home'
  haml :index
end

get '/:id' do
  # do the reply chain dance for param[:id] and display it.
end

not_found do
  @page_title = '404 - Page Not Found'
  haml :four_oh_four
end

helpers do
  def link_to url, text
    %Q{<a href="#{url}">#{text}</a>}
  end
end
