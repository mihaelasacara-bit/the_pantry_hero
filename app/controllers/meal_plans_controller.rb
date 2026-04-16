class MealPlansController < ApplicationController
  def index
    @meal_plans = MealPlan.all
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

  def edit
    @meal_plan = MealPlan.find(params[:id])
  end

  def update
    @meal_plan = MealPlan.find(params[:id])

    if @meal_plan.update(meal_plan_params)
      redirect_to @meal_plan, notice: "Meal plan updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def meal_plan_params
    params.require(:meal_plan).permit(:start_date)
  end
end
