class CreateTitleTool < RubyLLM::Tool
  description "Saves a short title for the current meal plan. Title must be 5 words or fewer. This only activates after all seven recipes have been created and displays to the user."
  param :title, desc: "A short descriptive meal plan title, maximum 5 words", type: :string

  def initialize(meal_plan_id:)
    @meal_plan_id = meal_plan_id
  end

  def execute(title:)
    meal_plan = MealPlan.find(@meal_plan_id)
    meal_plan.update!(title: title)
    { title: meal_plan.title }
  rescue ActiveRecord::RecordNotFound
    { error: "Meal plan not found" }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end
end
