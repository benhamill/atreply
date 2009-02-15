# for testing use id 1181051952

class ReplyChain
  attr_accessor :chain
  
  def initialize status_id
    self.chain = [Reply.new(status_id.to_s)]
    
    while @chain[-1].in_reply_to
      @chain << Reply.new(@chain[-1].in_reply_to)
    end
    
    @chain.reverse!
  end
  
  def each_reply &block
    @chain.each do |reply|
      yield reply
    end
  end
end
