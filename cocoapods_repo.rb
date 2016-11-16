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
    MessagePack.unpack(@redis.get("pods:#{name}").force_encoding('ASCII-8BIT'))
  end

  def load_pods
    update_repo unless repo_cloned?

    files = Dir.glob("#{SPEC_PATH}/**/*.json")

    pods = {}

    files.each do |file|
      match = file.match(SPEC_REGEX)
      pods[match[1]] ||= {}
      pods[match[1]][match[2]] = JSON.parse(File.read(file))
    end
    pods
  end

  def write_pods_to_redis(pods)
    # push all names into set
    @redis.sadd('pod_names', pods.keys)

    # write all the pods into keys
    pods.each do |name, versions|
      @redis.set("pods:#{name}", MessagePack.pack(versions))
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
