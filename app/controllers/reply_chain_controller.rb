class ReplyChainController < ApplicationController
  def index
    @reply-chain = ReplyChain.new(@status_id)
  end
end
