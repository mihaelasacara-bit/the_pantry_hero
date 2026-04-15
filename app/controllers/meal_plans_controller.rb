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
      redirect_to @meal_plan
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def meal_plan_params
    params.require(:meal_plan).permit(:start_date)
  end
end
