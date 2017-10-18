class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook]
  validates :name, presence: true
  has_many :messages
  has_many :conversations, foreign_key: :sender_id 

  def get_conversation(user_id1, user_id2)
    conversation = Conversation.between(user_id1, user_id2).first
  end
  def get_conversation_last_message(user_id1, user_id2)
    conversation = Conversation.includes(:messages).between(user_id1, user_id2).first
    if conversation.present?
      if conversation.messages.count >= 1
        if conversation.messages.last.user_id == user_id2
          return "You: " + conversation.messages.last.content
        else
          return conversation.messages.last.content 
        end
      else return 'Has no message yet'
      end
    else
      if conversation.messages.count >= 1
        if conversation.messages.last.user_id == user_id2
          return "You: " + conversation.messages.last.content
        else
          return conversation.messages.last.content 
        end 
      else return 'Has no message yet'
      end
    end  
  end
end

def self.new_with_session params, session
  super.tap do |user|
    if data = session["devise.facebook_data"] &&
      session["devise.facebook_data"]["extra"]["raw_info"]
      user.email = data["email"] if user.email.blank?
    end
  end
end

def self.from_omniauth auth
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.name = auth.info.name
  end
end