library(httr)
library(tidyverse)
library(jsonline)

lastfmkey = "xxxxxxxxxxxxxxxxxxxxxxxx"



### GET THE FIRST n TOP ALBUMS FOR A USER WITH PLAYCOUNT FOR THE SPECIFIED TIME-FRAME

user_topAlbum <- function(user = user, period = period, limit = 50, page = 1, format = "json"){
  call <- GET(url = "http://ws.audioscrobbler.com/2.0/",
              query = list(method = "user.getTopAlbums", user = user, period = period, 
                           limit = limit, page = page, api_key = lastfmkey, format = "json"))
  
  raw_json <- content(call, as = "text", encoding = "UTF-8")
  parsed_json <- fromJSON(raw_json)
  
  df <- tibble::tibble(
    album = parsed_json$topalbums$album$name,
    playcount = parsed_json$topalbums$album$playcount,
    mbid = parsed_json$topalbums$album$mbid
  )
  
  return(df)
}


### GET USER SCROBBLINGS  ###
# From lastfm API documentation:
# The endpoint artist.getRecentTracks returns the recent tracks listened to by this user.

user_scrobbles <- function(user, limit = 200, page = 1){
   lastfm_response <- GET(url = "http://ws.audioscrobbler.com/2.0/",
                   query = list(method = "user.getRecentTracks", user = user, page = page, limit = limit, api_key = lastfmkey, format = "json"))
  
   raw_scrobbles <- content(response, as = "text", encoding = "UTF-8") %>%
                  fromJSON(flatten = TRUE) 
      
   scrobbles <- tibble::tibble(
      artist = raw.scrobbles$recenttracks$track$`artist.#text`,
      artist_mbid = raw.scrobbles$recenttracks$track$artist.mbid,
      title = raw.scrobbles$recenttracks$track$name,
      title_mbid = raw.scrobbles$recenttracks$track$mbid,
      album = raw.scrobbles$recenttracks$track$`album.#text`,
      album_mbid = raw.scrobbles$recenttracks$track$album.mbid,
      url = raw.scrobbles$recenttracks$track$url,
      date = raw.scrobbles$recenttracks$track$`date.#text`
  )
   
   scrobbles <- scrobbles %>% mutate(date = parse_date_time(date, orders = "dbyH!M!", locale = "English", tz = "Europe/Rome"))
   
   return(scrobbles) 
}
