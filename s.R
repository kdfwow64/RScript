library('rvest')
library('xml2')
url <- 'http://www.myfxbook.com/community/outlook'

webpage<-read_html(url) %>% html_nodes("#outlookSymbolsTable input") %>% html_attr('value')
np <- webpage[1] %>% read_html() %>% html_nodes('tr')
ntd1<-np[2] %>% html_nodes("td")
ntd2<-np[3] %>% html_nodes("td")
df<-data.frame(np[1] %>% html_nodes("td") %>% html_text(),ntd1[2] %>% html_text(),ntd1[3] %>% html_text(),ntd1[4] %>% html_text(),ntd2[2] %>% html_text(),ntd2[3] %>% html_text(),ntd2[4] %>% html_text())
names(df)<-c("Symbol","Percentage short","Volumn short","Positions short","Percentage long","Volume long","Positions long")
for(i in 2:99) {
  np <- webpage[i] %>% read_html() %>% html_nodes('tr')
  ntd1<-np[2] %>% html_nodes("td")
  ntd2<-np[3] %>% html_nodes("td")
  de<-data.frame(np[1] %>% html_nodes("td") %>% html_text(),ntd1[2] %>% html_text(),ntd1[3] %>% html_text(),ntd1[4] %>% html_text(),ntd2[2] %>% html_text(),ntd2[3] %>% html_text(),ntd2[4] %>% html_text())
  names(de)<-c("Symbol","Percentage short","Volumn short","Positions short","Percentage long","Volume long","Positions long")
  df<-rbind(df,de)
}
