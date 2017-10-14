class UsersController < ApplicationController
  def home
    @user = current_user
  end
end
