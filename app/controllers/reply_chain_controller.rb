class ReplyChainController < ApplicationController
  def display
    id = params[:id]
    @reply_chain = ReplyChain.new(id)
  end
end
