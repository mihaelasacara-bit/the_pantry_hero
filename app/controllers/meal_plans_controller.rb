class MealPlansController < ApplicationController
  def index
    @meal_plans = MealPlan.where(user: current_user)
  end

  def show
    @meal_plan = MealPlan.find(params[:id])
  end

  def new
    @meal_plan = MealPlan.new
  end

  def create
    @meal_plan = MealPlan.new(meal_plan_params)
    @meal_plan.user = current_user

    if @meal_plan.save
      @chat = Chat.new
      @chat.meal_plan = @meal_plan
      @chat.user = current_user
      if @chat.save
        redirect_to chat_path(@chat)
      else
        @chats = @meal_plan_chat.where(user: current_user)
        render "meal_plans/show"
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def meal_plan_params
    params.require(:meal_plan).permit(:start_date)
  end
end
