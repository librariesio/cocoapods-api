require 'sinatra/base'
require './cocoapods_repo'
require 'builder'

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
    COCOAPODS_REPO.pod(params[:name]).to_json
  end

  get '/feed.rss' do
    @entries = COCOAPODS_REPO.rss_entries
    builder :rss
  end
end
