library(dplyr)
library(lubridate)

vids <- read.csv("../data_input/USvideos.csv")
vids <- vids %>% 
  select(-c(thumbnail_link, description)) %>% 
  mutate(trending_date = ydm(trending_date),
         title = as.character(title),
         category_id = as.factor(sapply(as.character(vids$category_id), switch,
                                        "1" = "Film and Animation",
                                        "2" = "Autos and Vehicles", 
                                        "10" = "Music", 
                                        "15" = "Pets and Animals", 
                                        "17" = "Sports",
                                        "19" = "Travel and Events", 
                                        "20" = "Gaming", 
                                        "22" = "People and Blogs", 
                                        "23" = "Comedy",
                                        "24" = "Entertainment", 
                                        "25" = "News and Politics",
                                        "26" = "Howto and Style", 
                                        "27" = "Education",
                                        "28" = "Science and Technology", 
                                        "29" = "Nonprofit and Activism",
                                        "43" = "Shows")),
         publish_time = ymd_hms(publish_time,tz="America/New_York"),
         publish_hour = hour(publish_time)
  )

# pw is a helper function for mapping time from integer to a factor level
pw <- function(x){
  if(x < 8){
    x <- "12am to 8am"
  }else if(x >= 8 & x < 16){
    x <- "8am to 3pm"
  }else{
    x <- "3pm to 12am"
  }  
}

vids <- vids %>% 
  mutate(publish_when = as.factor(sapply(vids$publish_hour, pw)),
         publish_wday = ordered(as.factor(weekdays(vids$publish_time)),
                                levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", 
                                           "Saturday", "Sunday")
         ),
         timetotrend = as.factor(ifelse(trending_date - as.Date(publish_time) <= 7, 
                                        trending_date - as.Date(publish_time),
                                        "8+")),
         video_id = as.character(video_id),
         tags = as.character(tags),
         comments_disabled = as.logical(comments_disabled),
         ratings_disabled = as.logical(ratings_disabled),
         video_error_or_removed = as.logical(video_error_or_removed)
  ) %>% 
  distinct(title, .keep_all = T) %>% 
  write_rds(path="cleaned/cleaned.rds")
