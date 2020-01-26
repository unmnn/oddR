source('crawl.R', echo=TRUE)
library(tidyverse)
library(rvest)
library(stringr)
Sys.setenv("GCS_AUTH_FILE" = "gar-creds-un-6c3ad4645d9c.json")
Sys.setenv("GCS_DEFAULT_BUCKET" = "betting-data")
library(googleCloudStorageR)

events <- c(
  "football/euro-2020/winner",
  "football/euro-2020/top-goalscorer",
  "football/champions-league/winner",
  "football/world-cup/2022-world-cup/winner",
  "politics/us-politics/us-presidential-election-2020/winner",
  "politics/european-politics/german-politics/hamburg-state-election-2020"
)

crawl_res <- map_dfr(events, crawl)

csv_out <- paste0(Sys.Date(), "-betting-data.csv")
write_rds(crawl_res, csv_out)

gcs_upload(crawl_res, name = csv_out)
unlink(csv_out)

# gcs_list_objects()
# gcs_get_object(gcs_list_objects()$name[[1]])
