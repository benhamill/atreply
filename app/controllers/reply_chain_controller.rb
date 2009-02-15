class ReplyChainController < ApplicationController
  def index
    @reply_chain = ReplyChain.new(params[:status_id])
  end
end
