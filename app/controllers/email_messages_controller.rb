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
    @friends = Relationship.where("(user_1_id = ? or user_2_id = ?) and status > ?", current_user.id, current_user.id, 0)
    @friend_ids = Array.new
    @friends.each do |friend|
      if friend.user_1_id == current_user.id
        if !@friend_ids.include?(friend.user_2_id)
          @friend_ids << friend.user_2_id
        end  
      else
        if !@friend_ids.include?(friend.user_1_id)
          @friend_ids << friend.user_1_id     
        end   
      end
    end
    @users = User.where("id in (?)", @friend_ids)
  end
  def create
    status = 1
    @user_emails = Array.new
    params[:email_message][:user_id].each do |user_id|
      if user_id.present?
        @conversation = Conversation.between(user_id, current_user.id).first
        @relationships = Relationship.between(user_id, current_user)
        @email_message = EmailMessage.new(user_id: user_id, conversation_id: @conversation.id, content: params[:email_message][:content], url: params[:email_message][:url])
        if @relationships.count == 2
          @user_emails << User.find(user_id).email
        else
          if @relationships.count == 1
            if @relationships.first.status == 2
              p @relationships.first.action_user_id              
              unless @relationships.first.action_user_id == current_user.id
                @user_emails << User.find(user_id).email
                p  User.find(user_id).email              
              else
                if !@email_message.save
                  status = 0        
                end
              end
            else
              if !@email_message.save
                status = 0        
              end
            end
          end
        end                
      end
    end
    if status == 0
      render :new, alert: @email_message.errors.full_messages[0]
    else
      if params[:email_message][:user_id].count <= 1
        redirect_to new_user_email_message_path(current_user), alert: "You have to choose at least 1 friend to send message!"
      else
        if @user_emails.count == 0
          redirect_to root_path, notice: "Send messages successfully!"
        else  
          redirect_to new_user_email_message_path(current_user), alert: @user_emails.join("\n")
        end
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
