class RelationshipsController < ApplicationController
  before_action :is_present, only: [:update, :destroy]
  def create
    friend = User.find(params[:user_id])
    status = 0
    if Relationship.between(current_user, friend).first.present?
      status = 2
    end
    user_relationship = Relationship.new(user_1_id: current_user.id, user_2_id: friend.id, action_user_id: current_user.id, status: status)
    user_relationship.save
    redirect_to users_path
    
  end
  def update
    relationship = Relationship.find(params[:id])
    if relationship.status == 0
      relationship.status = 1
    else
      if relationship.status == 1
        relationship.status = 2
      else    
        if relationship.status == 2
          relationship.status = 1
        end
      end
    end    
    relationship.action_user_id = current_user.id
    relationship.save 
    redirect_to users_path    
  end
  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy
    redirect_to users_path
  end
  private
    def is_present
      relationship = Relationship.where(id: params[:id])
      if !relationship.present?
        redirect_to users_path
      end
    end
end
