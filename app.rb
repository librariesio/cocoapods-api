require 'sinatra/base'

class CocoapodsAPI < Sinatra::Base
  get '/' do
    "Hello World!"
  end
end
