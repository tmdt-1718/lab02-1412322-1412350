class UsersController < ApplicationController
  def home
    @user = current_user
    session[:conversations] ||= []
    @users = User.all.where.not(id: current_user)
    @conversations = Conversation.includes(:recipient, :messages).find(session[:conversations])
  end
  def get_conversation(user_id)
    return Conversation.between(current_user.id, user_id).first
  end
  def index
    @users = User.all.where.not(id: current_user)    
    @relationships = Relationship.where("user_1_id = ? or user_2_id = ?", current_user, current_user)
  end
end
