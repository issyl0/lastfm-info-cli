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
  if entire_parsed_json["recenttracks"]["track"] == nil then
    puts "No recent tracks.\n"
  else
    entire_parsed_json["recenttracks"]["track"].each do |track|
    
      trackname = track["name"].to_s
      trackartist = track["artist"]["#text"].to_s
    
      align_columns(trackname,trackartist) 
    end
  end
end

def display_num_tracks(entire_parsed_json)
  # Capitalise the username for aesthetic value.  Print it and the
  # user's play count.
  
  if entire_parsed_json["user"]["playcount"] == nil then
    puts "No tracks played.\n"
  else
    puts entire_parsed_json["user"]["name"].to_s.capitalize + "'s play count:\t" + entire_parsed_json["user"]["playcount"].to_s
  end
end

def json_tracks(entire_parsed_json,track_kind)
  # Get the tracks.
  
  tracks = entire_parsed_json[track_kind]["track"]
  
  if tracks == nil
    return false
  end
  if tracks.class == Hash then # Make it an array.
    tracks = [tracks]
  end
  tracks.each do |track|
    # Yield calls the specified function after it in
    # display_banned_tracks() or display_loved_tracks()
    # (align_columns(trackname, trackartist) in this case) and fills
    # in its parameters.
    yield track["name"].to_s, track["artist"]["name"].to_s
    # True if not false (i.e. nil, above).
    true
  end
end

def display_loved_tracks(entire_parsed_json)
  # The specified user's loved tracks.

  # Call this function to get the data and align the returned data.
  return_value = json_tracks(entire_parsed_json, "lovedtracks") do |trackname, trackartist|
    align_columns(trackname, trackartist)
  end
  # If false, inform the user of the lack of tracks.
  if return_value == false
    puts "No loved tracks.\n"
  end
end

def display_banned_tracks(entire_parsed_json)
  # Specified user's banned tracks.
  
  # Call this function to get the data and align the returned data.
  return_value = json_tracks(entire_parsed_json, "bannedtracks") do |trackname, trackartist|
    align_columns(trackname, trackartist)
  end
  # If false, inform the user of the lack of tracks.
  if return_value == false
    puts "No banned tracks.\n"
  end
end

def find_results(username,apikey,method,limit)
  url = "http://ws.audioscrobbler.com/2.0/?method=#{method}&user=#{username}&api_key=#{apikey}&format=json"
  if method != "user.getinfo" then
    url = "http://ws.audioscrobbler.com/2.0/?method=#{method}#{limit}&user=#{username}&api_key=#{apikey}&format=json"
  end
  response = RestClient.get(url)
  entire_parsed_json = JSON.parse(response)
  
  if method == "user.getrecenttracks" then
    display_recently_played(entire_parsed_json)
  elsif method == "user.getinfo" then
    display_num_tracks(entire_parsed_json)
  elsif method == "user.getlovedtracks" then
    display_loved_tracks(entire_parsed_json)
  elsif method == "user.getbannedtracks" then
    display_banned_tracks(entire_parsed_json)
  end
end

# API key.
apikey = "8fadfb361ea43d4798d8379e5b96349b"

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
    # Menu choices are numbers, so assume that whatever the user
    # enters can be converted to an integer.
    choice = gets.chomp.to_i

    if choice != 2 && choice != 5 && choice != 6 then
      puts "How many requests would you like to see?  Press enter for the default of 50."
      l = gets.chomp
      if l == "" then
        limit = "&limit=50"
      else
        limit = "&limit=#{l}"
      end
    end
    
    # Handle the user's choice.
    case choice
      when (1..4) # Options one to four.
        choices = ["getrecenttracks", "getinfo", "getlovedtracks", "getbannedtracks"]
        # Choice 4 would be choice 3 in the array (getbannedtracks).
        find_results(username,apikey,"user.#{choices[choice-1]}",limit)
      when 5
        username_entered = false
      when 6
        quit = true
      else
        puts "Enter a number between 1 and 6."
    end
end