library('rvest')
library('xml2')
url <- 'http://solicitors.lawsociety.org.uk/search/results?Type=0&IncludeNlsp=True&Pro=True&Page='
burl<- 'http://solicitors.lawsociety.org.uk'
df<-data.frame('','','','','','','','','','','','','','','')
names(df)<-c('Company Name','Type','SRA ID','Tel','Email','Web','Address1','Address2','Address3','Postal code','Country','Google Maps','Facilities','Areas of practise at this branch','Areas of practise of this organisation')
for (i in 1:25) {
  eurl<-paste(url,i,sep='')
  webpage<-read_html(eurl) %>% html_nodes('#results section')
  for(j in 1:20) {
    str<-webpage[j]%>%html_nodes('h2 a')%>%html_attr('href')
    eeurl<-paste(burl,str,sep='')
    epage<-read_html(eeurl) %>% html_nodes('article')
    cName<-epage%>%html_nodes('h1')%>%html_text()
    eepage<-epage%>%html_nodes('#main-details-accordion')
    etop<-eepage%>%html_nodes('dl')
    esub<-etop[1]%>%html_nodes('dd')
    ct<-esub[1]%>%html_text()
    cs<-esub[2]%>%html_text()
    ctel<-''
    cemail<-''
    cweb<-''
    coffice1<-''
    coffice2<-''
    coffice3<-''
    cmap<-''
    cfac<-''
    cbra<-''
    corg<-''
    if(esub%>%length >2) {
      if(esub[3]%>%html_nodes('ul')%>%length>0){
        ctel<-esub[4]%>%html_text()
        if(esub%>%length >4)
          cemail<-esub[5]%>%html_nodes('a')%>%html_text()
        if(esub%>%length >6)
          cweb<-esub[7]%>%html_nodes('a')%>%html_text()
      } else {
        if(grepl('show',esub[3]%>%html_text()))
          cemail<-esub[3]%>%html_text()
        else {
          ctel<-esub[3]%>%html_text()
          if(esub%>%length >3)
            cemail<-esub[4]%>%html_nodes('a')%>%html_text()
          if(esub%>%length >5)
            cweb<-esub[6]%>%html_nodes('a')%>%html_text()
        }
      }
    }
    esub2<-strsplit(etop[2]%>%html_text(),',')
    coffice1<-esub2[[1]][2]
    coffice2<-esub2[[1]][3]
    coffice3<-esub2[[1]][4]
    cpostal<-esub2[[1]][5]
    tt<-strsplit(esub2[[1]][6],'\r')
    ccountry<-tt[[1]][1]
    cmap<-etop[2]%>%html_nodes('a')%>%html_attr('href')
    eepage%>%html_nodes('.facilities')
    eimg<-eepage%>%html_nodes('.facilities p img')%>%html_attr('alt')
    if(eimg[1] == 'Office has disabled access')
      efac<-'Office has disabled access'
    if(eimg[2] == 'Office support hearing induction loops')
      efac<-'Office does not support hearing induction loops'
    if(eimg[3] == 'Office accepts Legal Aid')
      efac<-'Office accepts Legal Aid'
    if(eimg[4] == 'Office provide Sign Language')
      efac<-'Office provide Sign Language'
    ebran<-epage%>%html_nodes('#branch-areas-of-practice-accordion')
    de<-data.frame(cName,ct,cs,ctel,cemail,cweb,coffice1,coffice2,coffice3,cpostal,ccountry,cmap,efac,"branc","organisation")
    names(de)<-c('Company Name','Type','SRA ID','Tel','Email','Web','Address1','Address2','Address3','Postal code','Country','Google Maps','Facilities','Areas of practise at this branch','Areas of practise of this organisation')
    df<-rbind(df,de)
  }
}
write.csv(df, file = "MyData.csv")
