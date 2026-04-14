class ChatsController < ApplicationController
  def create
    @meal_plan = MealPlan.find(params[:meal_plan_id])

    @chat = Chat.new
    @chat.meal_plan = @meal_plan
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat) # create show page of chat
    else
      @chats = @meal_plan_chat.where(user: current_user)
      render "meal_plans/show"
    end
  end

  def show
    @chat = Chat.find(params[:id])
  end
end
