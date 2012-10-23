# Isabell Long <isabell@issyl0.co.uk>, 2012.
# Look at someone's last.fm profile without opening a web browser.
require 'rubygems'
require 'rest_client'
require 'json'

def align_columns(trackname,trackartist)
  column_width = 70
  spaces = ' ' * (column_width - trackname.length)
  puts trackname + spaces + trackartist
end

def display_recently_played(entire_parsed_json)
  # Display recent tracks for the specified user.
  entire_parsed_json["recenttracks"]["track"].each do |track|
    
    trackname = track["name"].to_s
    trackartist = track["artist"]["#text"].to_s

    align_columns(trackname,trackartist)
  end
end

def display_num_tracks(entire_parsed_json)
  # Capitalise the username for aesthetic value.  Print it and the
  # user's play count.
  puts entire_parsed_json["user"]["name"].to_s.capitalize + "'s play count:\t" + entire_parsed_json["user"]["playcount"].to_s
end

def display_loved_tracks(entire_parsed_json)
  # The specified user's loved tracks.
  entire_parsed_json["lovedtracks"]["track"].each do |track|
    
    trackname = track["name"].to_s
    trackartist = track["artist"]["name"].to_s
    
    align_columns(trackname,trackartist) 
  end
end

def display_banned_tracks(entire_parsed_json)
  # Doesn't currently work due to trackartist.
  puts entire_parsed_json
  entire_parsed_json["bannedtracks"]["track"].each do |track|

    trackname = track[1].to_s
    trackartist = track["artist"]["name"].to_s

    align_columns(trackname,trackartist)
  end
end

def find_results(username,apikey,method,limit)
  url = "http://ws.audioscrobbler.com/2.0/?method=#{method}&user=#{username}&api_key=#{apikey}&format=json"
  if method != "user.getinfo" then
    url = "http://ws.audioscrobbler.com/2.0/?method=#{method}#{limit}&user=#{username}&api_key=#{apikey}&format=json"
  end
  response = RestClient.get(url)
  entire_parsed_json = JSON.parse(response)
  
  if method == "user.getrecenttracks"
    display_recently_played(entire_parsed_json)
  elsif method == "user.getinfo"
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

# Enable changing of the username.
username_entered = false
quit = false
while quit == false do
  if username_entered == false then
    puts "Enter a username to find out about:"
    username = gets.chomp
    username_entered = true
  end

  puts "What would you like to find out about #{username}'s music?\n
    1. Recently played tracks.\n
    2. Number of tracks listened to.\n
    3. Loved tracks.\n
    4. Banned tracks.\n
    5. Change username.\n
    6. Quit."
    choice = gets.chomp.to_i # Hopefully 1 to 4, so an integer.

    if choice != 5 || 6 then
      puts "How many requests would you like to see?  Press enter for the default of 50."
      l = gets.chomp
      if l == "" then
        limit = "&limit=50"
      else
        limit = "&limit=#{l}"
      end
    end
    
    # Handle the user's choice.
    if choice == 1 then
      method = "user.getrecenttracks"
      find_results(username,apikey,method,limit)
    elsif choice == 2 then
      method = "user.getinfo"
      find_results(username,apikey,method,limit)
    elsif choice == 3 then
      method = "user.getlovedtracks"
      find_results(username,apikey,method,limit)
    elsif choice == 4 then
      method = "user.getbannedtracks"
      find_results(username,apikey,method,limit)
    elsif choice == 5 then
      username_entered = false
    elsif choice == 6 then
      quit = true
    else
      puts "Enter a number between 1 and 6."
    end
end