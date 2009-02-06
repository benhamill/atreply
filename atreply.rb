#!/usr/bin/env ruby
# for testing use id 1181051952

require 'rubygems'
require 'twitter'

class Reply
  attr_accessor :text, :author, :in_reply_to, :time, :atreply
  
  def initialize status_id
    status = Twitter::Client.new.status :get, status_id
    
    self.text = status.text
    self.author = if status.user.name then status.user.name else status.user.screen_name end
    self.time = status.created_at
    self.in_reply_to = status.in_reply_to_status_id
    self.atreply = Reply.new self.in_reply_to unless self.in_reply_to.nil?
  end
  
  def each_reply &block
    reply_chain.each do |reply|
      yield reply
    end
  end
  
  def to_s
    self.author + ' - ' + self.time.to_s + "\n" + self.text
  end
  
  protected
  
  def reply_chain
    return [self] unless self.atreply
    
    self.atreply.reply_chain << self
  end
end
