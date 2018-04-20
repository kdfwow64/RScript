list.of.packages <- c("httr", "rvest","curl","dplyr", "data.table", "stringr", "mailR", "xlsx", "knitr", "kableExtra")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos='http://cran.us.r-project.org')
lapply(list.of.packages, require, character.only = TRUE)

for (i in 1:30){
  
  url <- paste0("http://www.seloger.com/list.htm?idtt=2&idtypebien=1,2&cp=75&tri=initial&naturebien=1,2,4&nb_pieces=1,2,3&pxmax=250000&surfacemin=18&LISTING-LISTpg=", i)
  
  url <- GET(url, add_headers('user-agent' = 'Maxence Voisin-maxence.voisin@epfedu.fr'))
  
  
  website <- data.frame(matrix("SeLoger", ncol = 1, nrow = 30))
  colnames(website) <- c("website")
  
  page <- data.frame(matrix(i, ncol = 1, nrow = 30))
  colnames(page) <- c("page")
  
  surface <- url%>%read_html()%>%html_nodes(xpath='//div/em')%>%html_text()
  surface <- data.frame(matrix(unlist(surface), nrow=length(surface), byrow=T))
  colnames(surface) <- c("title")
  surface <- data.frame(surface %>%filter(str_detect(surface$title, "m?")))
  
  Sys.sleep(sample(seq(1, 2, by=0.004), 1))
  
  prix <- url%>%read_html()%>%html_nodes(xpath="//div/span[@class='c-pa-cprice']")%>%html_text()
  prix <- data.frame(matrix(unlist(prix), nrow=length(prix), byrow=T))
  colnames(prix) <- c("title")
  
  Sys.sleep(sample(seq(1, 4, by=0.003), 1))
  
  city <- url%>%read_html()%>%html_nodes(xpath="//div[@class='c-pa-city']")%>%html_text()
  city <- data.frame(matrix(unlist(city), nrow=length(city), byrow=T))
  colnames(city) <- c("title")
  
  Sys.sleep(sample(seq(1, 5, by=0.002), 1))
  
  link <- url%>%read_html()%>%html_nodes(xpath="//div/a[@class='c-pa-link link_AB']")%>%html_attr("href")
  link <- data.frame(matrix(unlist(link), nrow=length(link), byrow=T))
  colnames(link) <- c("title")
  
  Sys.sleep(sample(seq(1, 2, by=0.007), 1))
  
  
  if(nrow(surface)==21){
    
    website <- as.data.frame(website[1:20,])
    page <- as.data.frame(page[1:20,])
    surface <- as.data.frame(surface[2:21,])
    prix <- as.data.frame(prix[1:20,])
    city <- as.data.frame(city[1:20,])
    link <- as.data.frame(link[1:20,])
    
  }else{
    
    website <- as.data.frame(website[1:20,])
    page <- as.data.frame(page[1:20,])
    surface <- as.data.frame(surface[1:20,])
    prix <- as.data.frame(prix[1:20,])
    city <- as.data.frame(city[1:20,])
    link <- as.data.frame(link[1:20,])
    
  }
  
  colnames(website) <- c("title")
  colnames(page) <- c("title")
  colnames(city) <- c("title")
  colnames(prix) <- c("title")
  colnames(surface) <- c("title")
  colnames(link) <- c("title")
  
  assign(paste0('table_page', i), data.frame(website, page, city, prix, surface, link))
  
  cat('Page', i, 'sur', 30,'\n')
}
