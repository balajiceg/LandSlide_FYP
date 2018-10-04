load('classifier_n_result_temp')

library(maptools)
gpclibPermit()

dat=read.asciigrid("ndvi.txt",as.image = FALSE)
true_img=as.vector(dat$ndvi.txt)

#y_pred <- subset(true_img, !is.na(true_img))

j=1
new=c()
for (i in seq_along(true_img)){
  if(!is.na(true_img[i]))
  {
    new[i]=y1[j]
    j=j+1
  }
  else{
    new[i]=true_img[i]
  }
  
}
dat$ndvi.txt=new
write.asciigrid(dat,'trial_ascii1')