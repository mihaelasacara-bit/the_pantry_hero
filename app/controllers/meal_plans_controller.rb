class MealPlansController < ApplicationController
  def index
    @meal_plans = MealPlan.all
  end

  def show
    @meal_plan = MealPlan.find(params[:id])
    @chat = @meal_plan.chat
  end
end
