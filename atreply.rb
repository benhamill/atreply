#!/usr/bin/env ruby

require 'rubygems'
require 'twitter'

class Reply
  attr_accessor :text, :author, :in_reply_to, :time
  
  def initialize status
    self.text = status.text
    self.author = if status.user.name then status.user.name else status.user.screen_name end
    self.time = status.created_at
    self.in_reply_to = status.in_reply_to_status_id
  end
end
