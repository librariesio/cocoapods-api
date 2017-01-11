require 'msgpack'
require 'json'
require 'redis'

class CocoapodsRepo

  SPEC_PATH = File.dirname(__FILE__) + "/Specs"
  SPEC_REGEX = /\/Specs\/[0-9a-f]\/[0-9a-f]\/[0-9a-f]\/(.+?)\/(.+?)\/(.+)$/i

  def initialize(redis_url = nil)
    @redis = Redis.new(url: redis_url, driver: :hiredis)
  end

  def pod_names
    @redis.smembers("pod_names")
  end

  def pod(name)
    pack = @redis.get("pods:#{name}")
    return nil unless pack
    MessagePack.unpack(pack).force_encoding('ASCII-8BIT')
  end

  def rss_entries
    git_history.split("\ncommit ").map do |entry|
      {
        guid: entry.gsub(/^.*commit /m, '').gsub(/\n.*$/m, '').strip,
        author_name: entry.gsub(/^.*Author: /m, '').gsub(/ <.*$/m, '').strip,
        date: entry.gsub(/^.*Date: +/m, '').gsub(/\n.*$/m, '').strip,
        comments: entry.gsub(/^.*Date[^\n]*/m, '').strip
      }
    end
  end

  def git_history
    `cd #{SPEC_PATH} && git log --max-count=20 --format=medium`
  end

  def load_pods
    update_repo unless repo_cloned?

    files = Dir.glob("#{SPEC_PATH}/**/*.json")

    pods = {}

    files.each do |file|
      match = file.match(SPEC_REGEX)
      next unless match
      pods[match[1]] ||= {}
      pods[match[1]][match[2]] = file
    end
    pods
  end

  def write_pods_to_redis(pods)
    # push all names into set
    @redis.sadd('pod_names', pods.keys)

    # write all the pods into keys
    pods.each_with_index do |(name, versions), index|
      versions.each { |k, v| versions[k] = JSON.parse(File.read(v)) }
      @redis.set("pods:#{name}", MessagePack.pack(versions))
      GC.start if index % 100 == 0
    end
  end

  def repo_cloned?
    File.directory?(SPEC_PATH)
  end

  def update_repo
    `if cd #{SPEC_PATH}; then git pull; else git clone https://github.com/CocoaPods/Specs #{SPEC_PATH}; fi`
  end

  def update_pods
    update_repo
    write_pods_to_redis load_pods
    nil
  end
end
