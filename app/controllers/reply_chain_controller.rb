class ReplyChainController < ApplicationController
  def display
    @reply_chain = ReplyChain.new(params[:id])
  end
end
