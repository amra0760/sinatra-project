require 'dotenv/load'
require 'bundler'
Bundler.require

require_relative 'models/model.rb' #Links the model (BackEnd) to the Application Controller ("middle man")
# require_relative 'models/result.rb'

class ApplicationController < Sinatra::Base

  get '/' do # Load up page 
    erb :index #starts on the form page
  end
  
  
  
  post '/result' do # result page
    
    user_food= params[:food] # Gets the user's response from the first textbox and stores it into a variable called "user_food"
    user_location= params[:location] # Gets the user's response from the second textbox and stores it into a variable called "user_location"
    @all= search(user_food,user_location) # Uses the input as arguments for the method "search"(found in the model)
    user_food_no_space= user_food.split(" ").join("") # takes the user's food input and combines it into one word and stores ut into the variable "user_food_no_space"
    @calories= find_calories(user_food_no_space) # uses the variable "user_food_no_space" as argument for the method "find_calories"
    
    erb :result #leads to the result page
  end 
  
end
