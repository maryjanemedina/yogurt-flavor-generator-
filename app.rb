require_relative 'config/environment'
require_relative 'models/textanalyzer.rb'

class App < Sinatra::Base

get '/' do
   '<h1> Yogurt Combos </h1>'
    #erb :index
end

post '/' do
  text_from_user = params[:user_text]
  erb :results
end


end