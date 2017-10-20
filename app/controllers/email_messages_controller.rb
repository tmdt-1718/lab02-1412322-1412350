class EmailMessagesController < ApplicationController
  def show
    @message = EmailMessage.find(params[:id])
    @recipient = User.find(@message.user_id)
    @sender = Conversation.find(@message.conversation_id).opposed_user(@recipient)
    if @message.user_id == current_user.id
      if !@message.seen_at.present?
        @message.seen_at = Time.now
        @message.save
      end
    end
  end
  def new
    @email_message = EmailMessage.new
  end
  def create
    status = 1
    params[:email_message][:user_id].each do |user_id|
      if user_id.present?
        p Conversation.between(user_id, current_user.id).first
        @conversation = Conversation.between(user_id, current_user.id).first
        @email_message = EmailMessage.new(user_id: user_id, conversation_id: @conversation.id, content: params[:email_message][:content])
        if !@email_message.save
          status = 0        
        end
      end
    end
    if status == 0
      render :new, alert: @email_message.errors.full_messages[0]
    else
      if params[:email_message][:user_id].count <= 1
        redirect_to root_path, notice: "You have to choose at least 1 friend to send message!"
      else
        redirect_to root_path, notice: "Sent messages success!"
      end        
    end    
  end
  def inbox
    @inbox_messages = EmailMessage.where(user_id: current_user.id)
    p EmailMessage.all.count
  end
  def sentmail
    @conversations = Conversation.where("recipient_id = ? or sender_id = ?", current_user.id, current_user.id)
    @sentmail_messages = EmailMessage.where("user_id != ? and conversation_id in (?)",current_user.id, @conversations.select{|c| c.id})
  end
end
