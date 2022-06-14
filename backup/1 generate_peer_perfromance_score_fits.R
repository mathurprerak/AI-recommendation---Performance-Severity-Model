

generate_fit <- function(pps, system, op_type, op_size)
{
  pps_sub_full<-pps[pps$model==system & pps$io_type==op_type & pps$io_size==op_size, c('percentile', 'latency')]
  pps_sub_top<-pps[pps$model==system & pps$io_type==op_type & pps$io_size==op_size & pps$percentile >= 50, c('percentile', 'latency')]	
  
  x<-pps_sub_top$latency
  y<-pps_sub_top$percentile
  x_full<-pps_sub_full$latency
  y_full<-pps_sub_full$percentile
  m<-nls(y ~ 100*(x^n)/(b+(x^n)),start=list(b=2,n=1.4))
  c1<-summary(m)$coefficients[1]
  c2<-summary(m)$coefficients[2]
  z<-seq(0,100,0.01)
  plot(x_full,y_full,log='x',xlim=range(0.01:100),ylim=range(0:100))
  title(paste(system,op_type,op_size))
  lines(z,100*z^c2/(c1+z^c2),lty=2,col="red",lwd=3)
  list(c1=c1,c2=c2)
}


systems<-c('HFA','AFA')
op_types<-c('nsRead','seqRead','write')
op_sizes<-c(0.5,1,2,4,8,16,32,64,128,256,512) #lower bound on op size in kib, inclusive

length(systems)*length(op_types)*length(op_sizes)

setwd("~/OneDrive - Hewlett Packard Enterprise/Sue Huang/AI Recommendation/1. Performance Severity Model/evaluation_20211112_20211118")
impactscore_training_20211112_20211118 <- read_excel("impactscore_training_20211112_20211118.xlsx")
table(impactscore_training_20211112_20211118$model)
table(impactscore_training_20211112_20211118$io_type)
table(impactscore_training_20211112_20211118$io_size)

dim(impactscore_training_20211112_20211118)/100
head(impactscore_training_20211112_20211118)

k=1
j=1
i=1

l<-list()
for(k in 1:length(systems))
{
  for(j in 1:length(op_types)) 
  {
    for(i in 1:length(op_sizes))
    {
      coeffs<-list()
      coeffs=try(generate_fit(impactscore_training_20211112_20211118,systems[k],op_types[j],op_sizes[i]))
      if (length(coeffs)>1)
      {
        l<-rbind(l,list(model=systems[k],io_type=op_types[j],op_size=op_sizes[i],coeff1=coeffs$c1,coeff2=coeffs$c2))
      }
    }
  }
}
perf_sev_summary <- data.frame(l)
perf_sev_summary
