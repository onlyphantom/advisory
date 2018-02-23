# Source the etl for data
library(readr)
library(ggplot2)
library(tidyr)
library(ggpubr)
vids <- read_rds("cleaned/cleaned.rds")

popular_cats <- vids %>% 
  group_by(category_id) %>% 
  tally() %>% 
  filter(n >= quantile(n, 0.5)) 

repline <- vids %>% 
  group_by(trending_date, category_id) %>% 
  tally() %>% 
  filter(category_id %in% popular_cats$category_id) %>% 
  ggplot(aes(x=trending_date, y=n, group=category_id))+
  geom_line(aes(color=category_id))


offsflip <- vids %>% 
  filter(ratings_disabled == T | comments_disabled == T) %>% 
  group_by(category_id, channel_title) %>% 
  summarize(ratings_off = sum(ratings_disabled), comment_off = sum(comments_disabled)) %>% 
  gather(id.vars = c("ratings_off", "comment_off")) %>% 
  filter(value > 0) %>% 
  ggplot(aes(x=channel_title, y=value))+
  geom_col(aes(fill=category_id, group=category_id), position = "dodge")+
  coord_flip()+
  facet_wrap(~key)

offs <- vids %>% 
  filter(ratings_disabled == T | comments_disabled == T) %>% 
  group_by(category_id, channel_title) %>% 
  summarize(ratings_off = sum(ratings_disabled), comment_off = sum(comments_disabled)) %>% 
  gather(id.vars = c("ratings_off", "comment_off")) %>% 
  filter(value > 0) %>% 
  ggdotchart(x="channel_title", 
             y="value", 
             col="category_id",
             group="category_id",
             y.text.color = T,
             rotate=T,
             add="segments",
             ggtheme = theme_pubr())+
  facet_wrap(~key, nrow=1)+
  theme_cleveland()+
  theme(legend.position = "right",
        axis.text.y = element_text(size=4.5))