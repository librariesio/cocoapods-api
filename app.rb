require 'sinatra/base'

class Cocoaplods < Sinatra::Base
  get '/' do
    "Hello World!"
  end
end
