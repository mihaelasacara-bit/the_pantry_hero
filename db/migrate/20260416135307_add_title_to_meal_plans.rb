class AddTitleToMealPlans < ActiveRecord::Migration[8.1]
  def change
    add_column :meal_plans, :title, :string
  end
end
