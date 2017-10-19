class EmailMessagesController < ApplicationController
  def new
    @email_message = EmailMessage.new
  end
  def create
  end
end
