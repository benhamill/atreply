require 'sinatra'
require 'haml'

set :haml, :format => :html5

get '/' do
  # render index.
end

get '/:id' do
  # do the reply chain dance for param[:id] and display it.
end

not_found do
  # render the 404 page.
end

helpers do
end
