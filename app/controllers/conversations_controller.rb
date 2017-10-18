class ConversationsController < ApplicationController
  def create
    @conversation = Conversation.get(current_user.id, params[:user_id])
    
    add_to_conversations unless conversated?
 
    respond_to do |format|
      format.js
    end
  end
  def close
    @conversation = Conversation.find(params[:id])
 
    session[:conversations].delete(@conversation.id)
 
  respond_to do |format|
      format.js
    end
  end
  def index
    @user = current_user
    session[:conversations] ||= []
    @users = User.all.where.not(id: current_user)
    @conversations = Conversation.includes(:messages).where("recipient_id = ? or sender_id = ?", current_user.id, current_user.id)
    respond_to do |format|
      format.html
      format.js
    end
  end
  def show
    @conversation = Conversation.find(params[:id])    
    respond_to do |format|
      format.js
    end
  end
  def get_conversation(user_id)
    return Conversation.between(current_user.id, user_id).first
  end
 
  private
 
  def add_to_conversations
    session[:conversations] ||= []
    session[:conversations] << @conversation.id
  end
 
  def conversated?
    session[:conversations].include?(@conversation.id)
  end
end
