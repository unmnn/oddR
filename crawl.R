crawl <- function(event) {
  url <- paste0("https://www.oddschecker.com/", event)
  message(url)
  html <- read_html(url)
  
  raw_table <- html %>% html_node(".eventTable") %>% html_table()
  # col_names <- c("bet", html %>% html_nodes(".eventTable #t1 td") %>% html_attr("data-bk") %>% unique() %>% na.omit())
  
  bookies <-
    map_dfc(c("data-bk", "title"), ~ html %>% 
              html_nodes(".eventTableHeader .bookie-area a") %>% 
              html_attr(.x) %>%
              enframe() %>% select(!!.x := value)) %>%
    set_names(c("id", "title"))
  
  tab_chr <- raw_table %>%
    discard(~ all(.x[c(1,2)] == "")) %>%
    mutate(quickbet_X1 = if_else(X1 == "QuickBet", row_number(), NA_integer_)) %>%
    filter(row_number() >= 2 + max(quickbet_X1, na.rm = TRUE)) %>%
    as_tibble() %>%
    select(-ncol(.)) %>%
    set_names(c("bet", bookies$title))
  
  tab_clean <- tab_chr %>%
    gather(bookie, odds, -bet) %>%
    separate(odds, into = c("nominator", "denominator"), sep = "/", convert = TRUE, fill = "right") %>%
    mutate(odds = if_else(is.na(denominator), as.double(nominator), nominator/denominator)) %>%
    mutate(odds = odds + 1) %>% # UK odds to European odds -> net profit to total profit
    select(bet, bookie, odds)
  
  tab_out <- tab_clean %>%
    mutate(time = as.character(Sys.time())) %>%
    mutate(event = event) %>%
    select(event, time, bet, bookie, odds)
  
  tab_out
}