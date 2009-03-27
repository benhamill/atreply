# for testing use id 1181051952

require 'yaml'

class ReplyChain
  attr_accessor :chain
  
  TWITTER_CONFIG_FILE = "#{RAILS_ROOT}/config/twitter_user.yaml"
  
  def initialize status_id
    client = self.login
    
    self.chain = [Reply.new(client, status_id.to_s)]
    
    while @chain[-1].in_reply_to
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
  end
  
  protected
  
  def login
    config = YAML::load_file TWITTER_CONFIG_FILE
    
    Grackle::Client.new config
  end
end
