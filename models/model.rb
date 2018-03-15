require "json"
require "http"
require "optparse"
require "pp"
require 'net/http' 

YELP_API_KEY = ENV["YELP_API_KEY"]
NUTRITION_ID= ENV["NUTRITION_CLIENT_ID"]
NUTRITION_KEY= ENV["NUTRITION_API_KEY"]

# Constants, do not change these
API_HOST = "https://api.yelp.com"
SEARCH_PATH = "/v3/businesses/search"
BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path


DEFAULT_BUSINESS_ID = "yelp-new-york"
DEFAULT_TERM = "dinner"
DEFAULT_LOCATION = "New York, NY"



def search(term, location)
  begin
    url = "#{API_HOST}#{SEARCH_PATH}"
    params = {
      term: term,
      location: location,
      
    }
    response = HTTP.auth("Bearer #{YELP_API_KEY}").get(url, params: params)
    names=[]
    final= JSON.parse(response)
    final["businesses"].each do |business|
      names << [business["name"], business["location"]["display_address"], business["image_url"],  business["rating"], business["price"], business["display_phone"], business["coordinates"]["longitude"] ,business["coordinates"]["latitude"] ]
    end 
    
    names
  rescue
  names<< ["I'm sorry I didn't get that. Can you please refresh the page and try again? Thank you",["Error"]," ","Error","Error","Error"," "]
  end
  
end


# def find_food(food)
#     # begin
#       url = "https://api.nutritionix.com/v1_1/search/#{food}?results=0:20&fields=item_name,brand_name,item_id,nf_calories&appId=#{NUTRITION_ID}&appKey=#{NUTRITION_KEY}"
#       uri = URI(url)
#       pp response = Net::HTTP.get(uri)
#       results= JSON.parse(response)
#       calories=[]
#       results["hits"].each do |item|
#           calories<< item["fields"]["nf_calories"]
#       end 
#       total=0
#       calories.each do |calorie|
#         total+=calorie
        
#       end
#       total/calories.length
#     # rescue
#     #   error= "I'm sorry I didn't get that. Can you please refresh the page and try again? Thank you"
#     #   error
#     # end
#   # its not an integer, so i cant put it in the array
#   # WAIT, why we doing it to the nutrution one? it should be the search thats the thing thats basically running the whol thing
#   # imma try begin and rescue again
# end 

def find_food(food)
    begin 
    url = "https://api.nutritionix.com/v1_1/search/#{food}?results=0:20&fields=item_name,brand_name,item_id,nf_calories&appId=42c566e4&appKey=84e21bd208e3060d6ede92b25eab1cb7"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    results= JSON.parse(response)
    calories=[]
    results["hits"].each do |item|
        calories<< item["fields"]["nf_calories"]
    end 
    total=0
    calories.each do |calorie|
        total+=calorie
    end 
    avg_cal = total/calories.length
    avg_cal.floor
    rescue
    avg_cal= "Unknown"
    end 
end 


# def run
#   begin 
#     #need arguments
#     search
#     find_food
#   rescue
#     "I'm sorry I didn't get that. Can you please refresh the page and try again? Thank you"
#   end
# end


# command = ARGV


# case command.first
# when "search"
#   term = options.fetch(:term, DEFAULT_TERM)
#   location = options.fetch(:location, DEFAULT_LOCATION)

#   raise "business_id is not a valid parameter for searching" if options.key?(:business_id)

#   response = search(term, location)

#   puts "Found #{response["total"]} businesses. Listing #{SEARCH_LIMIT}:"
#   response["businesses"].each {|biz| puts biz["name"]}
# else
#   puts "Please specify a command: search or lookup"
# end