require 'yaml'
require 'grackle'
require 'duration'

class ReplyChain
  attr_accessor :chain

  CONFIG_FILE = "secrets.yaml"

  def initialize status_id
    @chain = [Reply.new(client, status_id.to_s)]

    while @chain[-1].in_reply_to do
      @chain << Reply.new(client, @chain[-1].in_reply_to)
    end

    @chain.reverse!
  end

  def [] index
    @chain[index]
  end

  def each_reply &block
    @chain.each do |reply|
      yield reply
    end
    nil
  end

  protected

  def client
    @client ||= Grackle::Client.new(YAML::load_file(CONFIG_FILE))
  end
end

class Reply
  attr_accessor :text, :author, :in_reply_to, :time, :id, :screen_name

  def initialize client, status_id
    status = client.statuses.show.json? :id => status_id

    self.id = status_id
    self.text = status.text
    self.author = status.user.name or status.user.screen_name
    self.screen_name = status.user.screen_name
    self.time = status.created_at
    self.in_reply_to = status.in_reply_to_status_id
  end

  def friendly_time
    @friendly_time ||= Duration.new(utc_time - Time.now.utc).distance
  end

  def utc_time
    return @utc_time if @utc_time
    time_array = time.gsub(':', ' ').split
    time_hash = {
      :day => time_array[0],
      :month => time_array[1],
      :date => time_array[2],
      :hour => time_array[3],
      :minute => time_array[4],
      :second => time_array[5],
      :utc_offset => time_array[6],
      :year => time_array[7],
    }
    @utc_time = Time.utc(time_hash[:year], time_hash[:month], time_hash[:date], time_hash[:hour], time_hash[:minute], time_hash[:second])
  end

  def original_tweet
    "http://twitter.com/#{screen_name}/status/#{id}"
  end
end
