require 'json'

spec_path = "#{`pwd`.chomp}/Specs"

spec_regex = /\/Specs\/[0-9a-f]\/[0-9a-f]\/[0-9a-f]\/(.+?)\/(.+?)\/(.+)$/i

# update or clone spec repo
# `if cd #{spec_path}; then git pull; else git clone https://github.com/CocoaPods/Specs #{spec_path}; fi`

# recursively list contents of all subfolders
files = Dir.glob("#{spec_path}/**/*.json")

pods = {}

files.each do |file|
  match = file.match(spec_regex)
  pods[match[1]] ||= {}
  # pods[match[1]][match[2]] = file
  pods[match[1]][match[2]] = JSON.parse(File.read(file))
end

puts "#{pods.keys.length} pods 😑"
puts "#{files.length} files 😂"

str = Marshal.dump(pods)
File.open('pod_dump', 'w') { |file| file.write(str) }

require 'os'
puts "#{(OS.rss_bytes/(1024.0)).round}KB"
