# Isabell Long <isabell@issyl0.co.uk>, 2012.
# Look at someone's last.fm without opening a web browser.
require 'rubygems'
require 'rest_client'

def find_recently_played(username,apikey)
  # Output the raw XML from the request.  Focus on the most recent
  # track for now.
  url = "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&limit=1&user=#{username}&api_key=#{apikey}"
  response = RestClient.get(url)
  puts response.body
end

def find_num_tracks(username,apikey)
end

def find_loved_tracks(username,apikey)
end

def find_banned_tracks(username,apikey)
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

# Get the user's choice.
if choice == 1 then
  find_recently_played(username,apikey)
elsif choice == 2 then
  find_num_tracks(username,apikey)
elsif choice == 3 then
  find_loved_tracks(username,apikey)
elsif choice == 4 then
  find_banned_tracks(username,apikey)
else
  puts "Enter a number between 1 and 4."
end