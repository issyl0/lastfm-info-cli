# Isabell Long <isabell@issyl0.co.uk>, 2012.
# Look at someone's last.fm without opening a web browser.
require 'rubygems'
require 'rest_client'
require 'json'

def display_recently_played(entire_parsed_json)
end

def display_num_tracks(entire_parsed_json)
end

def display_loved_tracks(entire_parsed_json)
end

def display_banned_tracks(entire_parsed_json)
end

def find_results(username,apikey,method,limit)
  url = "http://ws.audioscrobbler.com/2.0/?method=#{method}#{limit}&user=#{username}&api_key=#{apikey}&format=json"
  response = RestClient.get(url)
  entire_parsed_json = JSON.parse(response)
  
  if method == "user.getrecenttracks"
    display_recently_played(entire_parsed_json)
  elsif method == "user.getuserinfo"
    display_num_tracks(entire_parsed_json)
  elsif method == "user.getlovedtracks"
    display_loved_tracks(entire_parsed_json)
  elsif method == "user.getbannedtracks"
    display_banned_tracks(entire_parsed_json)
  end
end

# Initial stuff.
# API key requested to avoid putting mine in the source. :-)
puts "Enter your API key:"
apikey = gets.chomp

puts "Is opening a web browser too much effort?  Enter a username to research:"
username = gets.chomp
puts "What would you like to find out about #{username}'s music?\n
  1. Recently played tracks.\n
  2. Number of tracks listened to.\n
  3. Loved tracks.\n
  4. Banned tracks."
choice = gets.chomp.to_i # Hopefully 1 to 4, so an integer.

puts "How many requests would you like to see?  Press enter for the default of 50."
l = gets.chomp
if l == "" then
  limit = "&limit=50"
else
  limit = "&limit=#{l}"
end

# Handle the user's choice.
if choice == 1 then
  method = "user.getrecenttracks"
  find_results(username,apikey,method,limit)
elsif choice == 2 then
  method = "user.getuserinfo"
  find_results(username,apikey,method,limit)
elsif choice == 3 then
  method = "user.getlovedtracks"
  find_results(username,apikey,method,limit)
elsif choice == 4 then
  method = "user.getbannedtracks"
  find_results(username,apikey,method,limit)
else
  puts "Enter a number between 1 and 4."
end