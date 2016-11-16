require 'sinatra/base'
require './cocoapods_repo'

COCOAPODS_REPO = CocoapodsRepo.new

class CocoapodsAPI < Sinatra::Base
  get '/' do
    "Hello World! #{COCOAPODS_REPO.pod_names.length} \n"
  end

  get '/pods.json' do
    content_type :json
    COCOAPODS_REPO.pod_names.to_json
  end

  get '/pods/:name.json' do
    content_type :json
    COCOAPODS_REPO.pods[params[:name]].to_json
  end

  end
end
