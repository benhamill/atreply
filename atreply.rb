require 'sinatra'
require 'haml'

set :haml, :format => :html5

get '/' do
  haml :index
end

get '/:id' do
  # do the reply chain dance for param[:id] and display it.
end

not_found do
  # render the 404 page.
end

helpers do
  def link_to url, text
    %Q{<a href="#{url}">#{text}</a>}
  end
end
