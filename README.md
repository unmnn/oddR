# oddR
Crawl betting odds from oddschecker.com

Fun little side project which sets up a daily CRON job that crawls sports/politics 
betting data from oddschecker.com. The result is stored in a Google Cloud Storage 
bucket.

- `crawl.R`: contains function `crawl(event)` to crawl betting odds
  - `event` specifies the subsite of oddschecker.com which contains a betting odds table (CSS class `.eventTable`)
- `main.R`: list events to crawl, run crawling and write result as csv to Google Cloud Storage bucket
- `cron.R`: sets up the CRON job for my RStudio Server (http://3.18.104.26:8787/)
