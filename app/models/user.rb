class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  validates :name, presence: true
  has_many :messages
  has_many :conversations, foreign_key: :sender_id 
  def get_conversation(user_id1, user_id2)
    conversation = Conversation.between(user_id1, user_id2).first
  end
  def get_conversation_last_message(user_id1, user_id2)
    conversation = Conversation.between(user_id1, user_id2).first
    if conversation.present?
      if conversation.messages.count >= 1
        return conversation.messages.last.content  
      else return 'Has no message yet'
      end
    else
      if conversation.messages.count >= 1
        return conversation.messages.last.content  
      else return 'Has no message yet'
      end
    end  
  end
end
