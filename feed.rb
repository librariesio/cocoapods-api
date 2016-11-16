require 'bundler'
Bundler.require

require './cocoapods_repo'

client = Feedtosis::Client.new('http://github.com/CocoaPods/Specs/commits/master.atom', backend: Moneta.new(:Redis))
while(true) do
  new_entries = client.fetch.new_entries
  CocoapodsRepo.new.update_pods if new_entries
  sleep 30
end
