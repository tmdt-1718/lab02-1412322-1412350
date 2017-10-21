class EmailMessage < ApplicationRecord
  attr_accessor :user_ids
  belongs_to :user
  belongs_to :conversation
  validates :content, presence: true
  mount_uploader :url
  default_scope {order("created_at DESC")}
  def email
    user.try(:email)
  end
  
  def email=(email)
    self.user = User.find_by(email: email).first if email.present?
  end
  def get_time(time)
    date = time.in_time_zone('Bangkok').strftime('%T')
    today_tmp = Time.now().in_time_zone('Bangkok').strftime('%F')
    if today_tmp == time.in_time_zone('Bangkok').strftime('%F')
      return date
    else
      return time.in_time_zone('Bangkok').strftime('%F %T')
    end
  end
  def get_user(id)
    return User.find(id)
  end
  def get_conversation(id)
    return Conversation.find(id)
  end
end
