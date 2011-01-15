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
