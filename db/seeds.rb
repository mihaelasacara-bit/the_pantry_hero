# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
# db/seeds.rb
# 1. Clean the database 🗑️
puts "Cleaning database..."

Recipe.destroy_all
MealPlan.destroy_all
User.destroy_all

puts "Seeding data..."

# 1. Create Users
user1 = User.create!(
  email: "alex@example.com",
  password: "password123",
)

user2 = User.create!(
  email: "sam@example.com",
  password: "password123",
)

# 2. Create Meal Plans
plan1 = MealPlan.create!(
  user: user1,
  start_date: Date.today
)

plan2 = MealPlan.create!(
  user: user2,
  start_date: Date.today
)

# 3. Create Recipes
# These link directly to the meal_plans via meal_plan_id
Recipe.create!(
  meal_plan: plan1,
  type: "Dinner",
  recipe_day: 1,
  ingredients: "Tofu, Broccoli, Soy Sauce, Sesame Oil",
  instructions: "Press tofu. Stir fry with broccoli and sauce. Serve hot."
)

Recipe.create!(
  meal_plan: plan2,
  type: "Dinner",
  recipe_day: 2,
  ingredients: "Avocado, Bacon, Eggs, Spinach",
  instructions: "Fry bacon and eggs. Serve over fresh spinach with sliced avocado."
)
