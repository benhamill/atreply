class ReplyChainController < ApplicationController
  def display
    @reply_chain = [1, 2, 3]
    #@reply_chain = ReplyChain.new(params[:id])
  end
end
