require 'json'

SPEC_PATH = "#{`pwd`.chomp}/Specs"
SPEC_REGEX = /\/Specs\/[0-9a-f]\/[0-9a-f]\/[0-9a-f]\/(.+?)\/(.+?)\/(.+)$/i

def update_pods
  `if cd #{SPEC_PATH}; then git pull; else git clone https://github.com/CocoaPods/Specs #{SPEC_PATH}; fi`
end

def output_stats
  puts "#{@pods.keys.length} pods 😑"
  puts "#{@files.length} files 😂"
end

def load_pods
  @files = Dir.glob("#{SPEC_PATH}/**/*.json")

  @pods = {}

  @files.each do |file|
    match = file.match(SPEC_REGEX)
    @pods[match[1]] ||= {}
    @pods[match[1]][match[2]] = JSON.parse(File.read(file))
  end
end

def dump_pods
  str = Marshal.dump(@pods)
  File.open('pod_dump', 'w') { |file| file.write(str) }
end

update_pods
load_pods
output_stats
