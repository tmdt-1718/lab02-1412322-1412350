class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :email_messages, dependent: :destroy
  belongs_to :sender, foreign_key: :sender_id, class_name: User
  belongs_to :recipient, foreign_key: :recipient_id, class_name: User
  validates :sender_id, uniqueness: { scope: :recipient_id }
  default_scope {includes(:messages).order("messages.created_at DESC")}
  scope :between, -> (sender_id, recipient_id) do
    where(sender_id: sender_id, recipient_id: recipient_id).or(
      where(sender_id: recipient_id, recipient_id: sender_id)
    )
  end
  def self.get(sender_id, recipient_id)
    conversation = between(sender_id, recipient_id).first
    return conversation if conversation.present?

    create(sender_id: sender_id, recipient_id: recipient_id)
  end

  def opposed_user(user)
    user == recipient ? sender : recipient
  end
  def get_time(time)
    date = time.localtime.strftime('%T')
    today_tmp = Time.now().strftime('%F')
    if today_tmp == time.localtime.strftime('%F')
      return date
    else
      return time.localtime.strftime('%F %T')
    end
  end
end
