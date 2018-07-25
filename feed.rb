require 'bundler'
Bundler.require

require './cocoapods_repo'

redis_uri = ENV['REDIS_SERVER'] || 'localhost:6379'
client = Feedtosis::Client.new('http://github.com/CocoaPods/Specs/commits/master.atom',
                               backend: Moneta.new(:Redis,
                                                   host: URI.parse(redis_uri).host,
                                                   port: URI.parse(redis_uri).port))
while(true) do
  new_entries = client.fetch.new_entries
  CocoapodsRepo.new(redis_uri).update_pods if new_entries
  sleep 30
end
