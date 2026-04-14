class CreateRecipes < ActiveRecord::Migration[8.1]
  def change
    create_table :recipes do |t|
      t.string :type
      t.integer :recipe_day
      t.text :instructions
      t.text :ingredients
      t.references :meal_plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
