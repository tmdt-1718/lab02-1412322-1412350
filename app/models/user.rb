class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook]
  validates :name, presence: true
  has_many :messages
  has_many :conversations, foreign_key: :sender_id 
  has_many :relationships, foreign_key: :user_1_id, dependent: :destroy 
  has_many :email_messages
  def get_conversation(user_id1, user_id2)
    conversation = Conversation.between(user_id1, user_id2).first
  end
  def get_relationship(user_id1, user_id2)
    relationships = Relationship.between(user_id1, user_id2)
    if (relationships.count == 1)
      return relationships.first
    else
      relationships.each do |relationship|
        if relationship.action_user_id == user_id1
          return relationship
        end
      end
    end
  end
  def get_conversation_last_message(user_id1, user_id2)
    conversation = Conversation.includes(:messages).between(user_id1, user_id2).first
    if conversation.present?
      if conversation.messages.count >= 1
        if conversation.messages.first.user_id == user_id2
          return "You: " + conversation.messages.first.content
        else
          return conversation.messages.first.content 
        end
      else return 'Has no message yet'
      end
    else
      if conversation.messages.count >= 1
        if conversation.messages.first.user_id == user_id2
          return "You: " + conversation.messages.first.content
        else
          return conversation.messages.first.content 
        end 
      else return 'Has no message yet'
      end
    end  
  end
  def is_unfriend(user1, user2)
    relationship = Relationship.between(user1.id, user2.id).first
    if relationship.present? 
      return false
    else 
      return true
    end
  end
  def is_block(user1, user2)
    relationships = Relationship.between(user1.id, user2.id)    
    relationship = Relationship.between(user1.id, user2.id).first
    if relationship.present? 
      if relationship.status == 2
        return relationships.count
      else 
        return 0
      end
    else
      return 0
    end  
  end
  def is_pending(user1, user2)
    relationship = Relationship.between(user1.id, user2.id).first
    if relationship.present? 
      if relationship.status == 0
        return true
      else 
        return false
      end
    else
      return false
    end  
  end
  def is_active(user1, user2)
    relationship = Relationship.between(user1.id, user2.id).first
    if (relationship.action_user_id == user1.id)
      return true
    else
      return false
    end
  end
  def is_block_active(current_user, user)
    relationships = Relationship.between(current_user.id, user.id)
    relationships.each do |relationship|
      if relationship.action_user_id == current_user.id
        return true
      end
    end
    return false
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
end