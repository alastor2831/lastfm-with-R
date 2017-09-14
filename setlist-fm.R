library(tidyverse)
library(jsonline)
library(lubridate)
library(httr)


setlist_key <- "xxxxxxxxxxxxxxxxxxxxx"

setlist_root <- "https://api.setlist.fm"

username = "likeeatingpizza"



setlist_url <- modify_url(setlist_root, path = paste("rest/1.0/user", username, "attended", sep = "/"),
                          query = list(p = 1))

setlist_response <- GET(setlist_url, add_headers(`x-api-key` = setlist_key, Accept = "application/json"))

    raw_concerts <- content(setlist_resp, as = "text", encoding = "UTF-8") %>%
       fromJSON(flatten = TRUE)
    
    concerts <- tibble::tibble(
       date = raw_concerts$setlist$eventDate,
       artist = raw_concerts$setlist$artist.name,
       artist_mbid = raw_concerts$setlist$artist.mbid,
       venue = raw_concerts$setlist$venue.name,
       city = raw_concerts$setlist$venue.city.name,
       state_region = raw_concerts$setlist$venue.city.state,
       country = raw_concerts$setlist$venue.city.country.name,
       tour = raw_concerts$setlist$tour.name
    )
    
    concerts <- concerts %>% mutate(date = dmy(date))
