require 'dotenv/load'
require 'bundler'
Bundler.require

require_relative 'models/model.rb'
# require_relative 'models/result.rb'

class ApplicationController < Sinatra::Base

  get '/' do
    erb :index
  end
  
  
  
  post '/result' do 
    
    user_food= params[:food] 
    user_location= params[:location]
    @all= search(user_food,user_location)
    user_food_no_space= user_food.split(" ").join("")
    @calories= find_food(user_food_no_space)
    
 
    
    erb :result
  end 
  
end
