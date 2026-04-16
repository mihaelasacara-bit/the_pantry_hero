class CreateRecipeTool < RubyLLM::Tool
  description "Creates a recipe with ingredients and instructions for the current user and saves it in the database."
  param :ingredients, desc: "The ingredients needed for the recipe", type: :string
  param :instructions, desc: "The instructions of the recipe", type: :integer
  param :recipe_day, desc: "The day of the meal plan on which of the recipe should be cooked, open per day from Day 1 to Day 7",
                     type: :string
  param :type, desc: "The type of meal for the recipe, by default dinner only.", type: :integer

  def initialize(user:, meal_plan_id:)
    @user = user
    @meal_plan_id = meal_plan_id
  end

  def execute(ingredients:, instructions:, recipe_day:, type:)
    meal_plan = MealPlan.find(@meal_plan_id)
    recipe = Recipe.create!(
      ingredients: ingredients,
      instructions: instructions,
      recipe_day: recipe_day,
      type: "dinner",
      meal_plan: meal_plan
    )
    { ingredients: recipe.ingredients, instructions: recipe.instructions, recipe_day: recipe.recipe_day,
      type: recipe.type, meal_plan: meal_plan }
  rescue ActiveRecord::RecordNotFound
    { error: "Meal plan not found" }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end
end
