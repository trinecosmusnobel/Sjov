#Scraping Danish entries in everyday sexism project

library(tidyverse)
library(dplyr)
library(rvest)

pages <- paste0("https://everydaysexism.com/country/dk/page/", 1:450)
  
a <- list()

for (i in 1:length(pages)) {
  
  url_use = pages[[i]]
  
  a[[i]] <- 
    tryCatch({
      
      Sys.sleep(5)
      
      ind.page <- read_html(url_use) 
      
      title <- ind.page %>% html_nodes("article") %>% html_nodes("h2") %>% html_text2()
      date <- ind.page %>% html_nodes("time") %>% html_text2()
      entry <- ind.page %>% html_nodes("div.entry-summary") %>% html_text2()
      
      tibble(Title = title, Date = date, Entry = entry)
      
    }, 
    
    error = function(e) 
      tibble(Title = character(), Date = character(), Entry = character()))
  
}

a_t <- map_dfr(a, bind_rows)                                  

saveRDS(a_t, file = "ESP_scraped_entries.rds")
