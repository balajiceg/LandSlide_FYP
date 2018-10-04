#incorrect file
library(maptools)
gpclibPermit()
filenames <- list.files( pattern="*.txt")

list_all=list()
for (file in filenames){
  dat<-read.asciigrid(file,as.image = TRUE)
  print(file)
  list_all[[tools::file_path_sans_ext(file)]]<-as.vector(dat$z)
}
df=data.frame(list_all)
rm(list_all)
dataset <- subset(df, !is.na(ndvi))
dataset$ls_basin[is.na(dataset$ls_basin)] <- 0
save(dataset,file='data1')

