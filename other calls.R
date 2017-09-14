library(lubridate)
library(httr)
library(jsonlinte)
library(tidyverse)



### GET ALBUM INFO (RELEASE DATE/YEAR) ###

album_info <- function(user = user, limit = 50, page = 1, from = from, format = "json"){
  call <- GET(url = "http://ws.audioscrobbler.com/2.0/",
              query = list(method = "album.getInfo", artist = artist, album = album, api_key = lastfmkey, format = "json"))
  
  parsed_json <- fromJSON(content(call, as = "text", encoding = "UTF-8"))
  
  df <- tibble(
    
  )
  
  return(df) 
}

albumReleaseDate <- function(album_mbid){
  
  call <- GET(url = "https://musicbrainz.org/", path = "ws/2/release-group", query = list(release = album_mbid, fmt = "xml"))
  
  date <- read_html(call) %>% 
          html_node(xpath = "//first-release-date") %>%
          html_text
  
  return(date)
}
