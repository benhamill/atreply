# for testing use id 1181051952

class Reply
  attr_accessor :text, :author, :in_reply_to, :time, :id, :screen_name
  
  def initialize client, status_id
    status = client.statuses.show.json? :id => status_id
    
    self.id = status_id
    self.text = status.text
    self.author = if status.user.name then status.user.name else status.user.screen_name end
    self.screen_name = status.user.screen_name
    self.time = status.created_at
    self.in_reply_to = status.in_reply_to_status_id
  end
end
