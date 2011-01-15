require 'yaml'
require 'grackle'

class ReplyChain
  attr_accessor :chain

  CONFIG_FILE = "secrets.yaml"

  def initialize status_id
    chain = [Reply.new(client, status_id.to_s)]

    while chain[-1].in_reply_to do
      chain << Reply.new(client, chain[-1].in_reply_to)
    end

    chain.reverse!
  end

  def [] index
    chain[index]
  end

  def each_reply &block
    chain.each do |reply|
      yield reply
    end
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
end
