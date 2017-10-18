class MessagesController < ApplicationController
  def create
    @conversation = Conversation.includes(:recipient).find(params[:conversation_id])
    @message = @conversation.messages.create(message_params)
 
    respond_to do |format|
      format.js
    end
  end
  def newmessages
    @user = current_user
    session[:conversations] ||= []
    @users = User.all.where.not(id: current_user)
    @conversations = Conversation.includes(:recipient, :messages).find(session[:conversations])
  end
  def get_conversation(user_id)
    return Conversation.between(current_user.id, user_id).first
  end
  private
 
  def message_params
    params.require(:message).permit(:user_id, :content)
  end
end
