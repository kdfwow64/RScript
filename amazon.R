amazon_storefronts_new<-read.csv("file1.csv")
i<- 1

for (url in amazon_storefronts_new$urls){
  
  download.file(url,destfile = 'scrape.html',quiet = TRUE)
  website <- read_html('scrape.html')
  pagemax <- website%>%html_nodes(xpath="//span[@class='pagnDisabled']|//input[@value='Go']")%>%html_text()
  pagemax <- data.frame(matrix(unlist(pagemax), nrow=length(pagemax), byrow=T))
  pagemax <- unique(pagemax)
  colnames(pagemax) <- "number"

  print(pagemax$number)
  
  assign(paste0('table_page', i), data.frame(pagemax))
  
  Sys.sleep(sample(seq(1, 2, by=0.002), 1))
  if(i %% 400 == 0)
    Sys.sleep(1000)
  
  cat('Page', i, 'sur', 1000,'\n')
  
  i <- i +1
}


pagemax_number <- rbindlist(mget(ls(pattern = "^table_page\\d+")))

rm(list = ls(pattern = "^table_page\\d+"))
