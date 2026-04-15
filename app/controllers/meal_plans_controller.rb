class MealPlansController < ApplicationController
  def show
    @meal_plan = MealPlan.find(params[:id])
    @chat = @meal_plan.chat
  end
end
