# During the 2016 US presidential election, then-candidate Donald J. Trump used his Twitter account as a way to communicate with potential voters. 
# On August 6, 2016 Todd Vaziri tweeted (https://twitter.com/tvaziri/status/762005541388378112) about Trump that "Every non-hyperbolic tweet is from iPhone (his staff). Every hyperbolic tweet is from Android (from him)."
# Data scientist David Robinson conducted an analysis (http://varianceexplained.org/r/trump-tweets/) to determine if data supported this assertion. Here we go through David's analysis to learn some of the basics of text mining.
# To learn more about text mining in R we recommend https://www.tidytextmining.com.

# We will use the following libraries:

library(tidyverse)
library(ggplot2)
library(lubridate)
library(tidyr)
library(scales)
set.seed(1)

# In general, we can extract data directly from Twitter using the rtweet package. 
# However, in this case, a group has already compiled data for us and made it available at http://www.trumptwitterarchive.com.

url <- 'http://www.trumptwitterarchive.com/data/realdonaldtrump/%s.json'
trump_tweets <- map(2009:2017, ~sprintf(url, .x)) %>%
  map_df(jsonlite::fromJSON, simplifyDataFrame = TRUE) %>%
  filter(!is_retweet & !str_detect(text, '^"')) %>%
  mutate(created_at = parse_date_time(created_at, orders = "a b! d! H!:M!:S! z!* Y!", tz="EST")) 

# For convenience we include the result of the code above in the dslabs package.

library(dslabs)
data("trump_tweets")

# This is the data frame with information about the tweet.

head(trump_tweets)

# The variables that are included are.

names(trump_tweets)

# The tweets are represented by the text variable.

trump_tweets %>% select(text) %>% head

# And the source variable tells us the device that was used to compose and upload each tweet.

trump_tweets %>% count(source) %>% arrange(desc(n))

# We can use extract to remove the Twitter for part of the source and filter out retweets.

trump_tweets %>% 
  extract(source, "source", "Twitter for (.*)") %>%
  count(source) 


