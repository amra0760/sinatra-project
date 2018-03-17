require "json"
require "http"
require "optparse"
require "pp"
require 'net/http' 


#Authentication Keys for Yelp and Nutrition API
YELP_API_KEY = ENV["YELP_API_KEY"]
NUTRITION_ID= ENV["NUTRITION_CLIENT_ID"]
NUTRITION_KEY= ENV["NUTRITION_API_KEY"]


#YELP API
#Yelp URL Endpoint which returns a hash based on what we want to attain from the Yelp API
API_HOST = "https://api.yelp.com"
SEARCH_PATH = "/v3/businesses/search"#In this app we want to seach for bussiness therefore we are required to use this URL Endpoint


def search(term, location)#This search method takes two arguments(a food and a Zip Code or City)
  begin
    url = "#{API_HOST}#{SEARCH_PATH}"
    params = {
      term: term,
      location: location,
    }
    response = HTTP.auth("Bearer #{YELP_API_KEY}").get(url, params: params)#This authorizes the key holder to get information fromthe Yelp API 
    names=[]#creates an empty array called names
    final= JSON.parse(response)#Turns information transmitted from Yelp APi into JSON(a dta format composed of hashes and/or arrays)
    final["businesses"].each do |business|#This iteration goes through each bussiness in the the JSON data and takes the name,location, product picture, rating, and "priceiness" of the resturant
      names << [business["name"], business["location"]["display_address"], business["image_url"],  business["rating"], business["price"], business["display_phone"], business["coordinates"]["longitude"] ,business["coordinates"]["latitude"] ]
    end 
    names# All the info about the bussiness is composed in here, a double dimension array 
  rescue
    names<< ["I'm sorry I didn't get that. Can you please refresh the page and try again? Thank you",["Error"]," ","Error","Error","Error"," "]#If there are no results from the Yelp API, the user will get this error message
  end
  
end



#NUTRITION API
def find_calories(food)
    begin 
        url = "https://api.nutritionix.com/v1_1/search/#{food}?results=0:20&fields=item_name,brand_name,item_id,nf_calories&appId=42c566e4&appKey=84e21bd208e3060d6ede92b25eab1cb7"#Nutrition URL Endpoint is customized so the type of food the user is requesting from the Yelp APi will also be requested from Nutrition API
        uri = URI(url)
        response = Net::HTTP.get(uri)
        results= JSON.parse(response)#Convert data in JSON Format
        calories=[]#creates an empty array called calories
        results["hits"].each do |item|#For each product of the same food, store the amount of calories into the calories array
            calories<< item["fields"]["nf_calories"]
        end 
        total=0 #creates a variable called total, sets it equal to zero
        calories.each do |calorie|
            total+=calorie#add all the calories together
        end 
        avg_cal = total/calories.length#take the average number of calories per serving  
        avg_cal.floor#round the decimals to whole number
    rescue
        avg_cal= "Unknown"#Returns this if caloires in Nutrition API can not be found
    end 
end 
