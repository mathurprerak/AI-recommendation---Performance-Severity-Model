##read the training data generated from the sql
pps<-read.csv('/Users/samalla/Desktop/MyJiras/IS27747/impactscore_training.csv')

##Fit AFA models, consider the right tail i.e, percentile >=50 for fitting the data
generate_fit_AFA <- function(system, op_type, op_size)
{
  pps_sub_full<-pps[pps$model==system & pps$io_type==op_type & pps$io_size==op_size, c('percentile', 'latency')]
  pps_sub_top<-pps[pps$model==system & pps$io_type==op_type & pps$io_size==op_size & pps$percentile >= 50, c('percentile', 'latency')]  
  
  x<-pps_sub_top$latency
  y<-pps_sub_top$percentile
  x_full<-pps_sub_full$latency
  y_full<-pps_sub_full$percentile
  m<-nls(y ~ 100*x^n/(b+x^n),start=list(b=2,n=1.4))
  c1<-summary(m)$coefficients[1]
  c2<-summary(m)$coefficients[2]
  z<-seq(0,100,0.01)
  #xulim<-max(x_full*1.1)
  plot(x_full,y_full,log='x',xlim=range(0.01:100),ylim=range(0:100))
  title(paste(system,op_type,op_size))
  lines(z,100*z^c2/(c1+z^c2),lty=2,col="red",lwd=3)
  list(c1=c1,c2=c2)
}

systems<-c('AFA')
op_types<-c('nsRead','seqRead','write')
op_sizes<-c(0.5,1,2,4,8,16,32,64,128,256,512) #lower bound on op size in kib, inclusive

l<-list()
for(k in 1:length(systems))
{
  for(j in 1:length(op_types)) 
  {
    for(i in 1:length(op_sizes))
    {
      coeffs<-list()
      coeffs=try(generate_fit_AFA(systems[k],op_types[j],op_sizes[i]))
      if (length(coeffs)>1)
      {
        l<-rbind(l,list(model=systems[k],io_type=op_types[j],op_size=op_sizes[i],coeff1=coeffs$c1,coeff2=coeffs$c2))
      }
    }
  }
}
perf_sev_summary <- data.frame(l)


##HFA FIT, We have observed a clear shift in the pattern of the data after a certain latency and we ahve tried to capture the normal behaviour (cont..)
## by restricting the fit to look before the signficant change occurs.
generate_fit_HFA <- function(system, op_type, op_size)
{
  pps_sub_full<-pps[pps$model==system & pps$io_type==op_type & pps$io_size==op_size, c('percentile', 'latency')]
  pps_sub_top<-pps[pps$model==system & pps$io_type==op_type & pps$io_size==op_size & pps$percentile >= 50, c('percentile', 'latency')]  
  
  x<-pps_sub_top$latency
  y<-pps_sub_top$percentile
  x_full<-pps_sub_full$latency
  y_full<-pps_sub_full$percentile
  m<-nls(y ~ 100*x^n/(b+x^n),start=list(b=2,n=1.4))
  c1<-summary(m)$coefficients[1]
  c2<-summary(m)$coefficients[2]
  z<-seq(0,100,0.01)
  #xulim<-max(x_full*1.1)
  plot(x_full,y_full,log='x',xlim=range(0.01:100),ylim=range(0:100))
  title(paste(system,op_type,op_size))
  lines(z,100*z^c2/(c1+z^c2),lty=2,col="red",lwd=3)
  list(c1=c1,c2=c2)
}

systems<-c('HFA')
op_types<-c('nsRead','seqRead')
op_sizes<-c(0.5,1,2,4,8,16,32,64,128,256,512) #lower bound on op size in kib, inclusive

l<-list()
for(k in 1:length(systems))
{
  for(j in 1:length(op_types)) 
  {
    for(i in 1:length(op_sizes))
    {
      coeffs<-list()
      coeffs=try(generate_fit_HFA(systems[k],op_types[j],op_sizes[i]))
      if (length(coeffs)>1)
      {
        l<-rbind(l,list(model=systems[k],io_type=op_types[j],op_size=op_sizes[i],coeff1=coeffs$c1,coeff2=coeffs$c2))
      }
    }
  }
}

perf_sev_summary <- data.frame(rbind(data.frame(l), perf_sev_summary))

##Writes needs a different filter of data
generate_fit_HFA_write <- function(system, op_type, op_size)
{
  pps_sub_full<-pps[pps$model==system & pps$io_type==op_type & pps$io_size==op_size, c('percentile', 'latency')]
  pps_sub_top<-pps[pps$model==system & pps$io_type==op_type & pps$io_size==op_size & pps$percentile <= 70, c('percentile', 'latency')]  
  
  x<-pps_sub_top$latency
  y<-pps_sub_top$percentile
  x_full<-pps_sub_full$latency
  y_full<-pps_sub_full$percentile
  m<-nls(y ~ 100*x^n/(b+x^n),start=list(b=2,n=1.4))
  c1<-summary(m)$coefficients[1]
  c2<-summary(m)$coefficients[2]
  z<-seq(0,100,0.01)
  #xulim<-max(x_full*1.1)
  plot(x_full,y_full,log='x',xlim=range(0.01:100),ylim=range(0:100))
  title(paste(system,op_type,op_size))
  lines(z,100*z^c2/(c1+z^c2),lty=2,col="red",lwd=3)
  list(c1=c1,c2=c2)
}

systems<-c('HFA')
op_types<-c('write')
op_sizes<-c(0.5,1,2,4,8,16,32,64,128,256,512) #lower bound on op size in kib, inclusive

l<-list()
for(i in 1:length(op_sizes))
{
  coeffs<-list()
  coeffs=try(generate_fit_HFA_write(systems,op_types,op_sizes[i]))
  if (length(coeffs)>1)
  {
    l<-rbind(l,list(model=systems,io_type=op_types,op_size=op_sizes[i],coeff1=coeffs$c1,coeff2=coeffs$c2))
  }
}

perf_sev_summary <- data.frame(rbind(data.frame(l), perf_sev_summary))

##AFA and HFA small blocksizes

generate_fit_v2 <- function(system, op_type, op_size,start_list)
{
  pps_sub_full<-pps[pps$model==system & pps$io_type==op_type & pps$io_size==op_size, c('percentile', 'latency')]
  pps_sub_top<-pps[pps$model==system & pps$io_type==op_type & pps$io_size==op_size & pps$percentile >= 50, c('percentile', 'latency')]  
  
  x<-pps_sub_top$latency
  y<-pps_sub_top$percentile
  x_full<-pps_sub_full$latency
  y_full<-pps_sub_full$percentile
  erf <- function(x) 2 * pnorm(x * sqrt(2)) - 1
  #m<-nls(y ~ 100*x^n/(b+x^n),start=list(b=2,n=1.4))
  #m<-nls(y ~ 50*(1+erf((x-b2)/n2)),start=list(b2=2,n2=1.4))
  m<-nls(y ~ 50*(1+erf((x-b2)/n2)),start=start_list)
  c1<-summary(m)$coefficients[1]
  c2<-summary(m)$coefficients[2]
  z<-seq(0,100,0.01)
  #xulim<-max(x_full*1.1)
  plot(x_full,y_full,log='x',xlim=range(0.01:100),ylim=range(0:100))
  title(paste(system,op_type,op_size))
  #lines(z,100*z^c2/(c1+z^c2),lty=2,col="red",lwd=3)
  lines(z,50*(1+erf((z-c1)/c2)),lty=2,col="red",lwd=3)
  list(c1=c1,c2=c2)
}
systems<-c('AFA')
op_types<-c('write')
op_sizes<-c(0.5,1,2,4,8,16,32) #lower bound on op size in kib, inclusive

l<-list()
for(i in 1:length(op_sizes))
{
  coeffs<-list()
  coeffs=try(generate_fit_v2(systems,op_types,op_sizes[i],list(b2=-0.1,n2=0.4)))
  if (length(coeffs)>1)
  {
    l<-rbind(l,list(model=systems,io_type=op_types,op_size=op_sizes[i],coeff1=coeffs$c1,coeff2=coeffs$c2))
  }
}
perf_sev_summary <- data.frame(rbind(data.frame(l), perf_sev_summary))


# generate_fit_v3 <- function(system, op_type, op_size,start_list)
# {
#   pps_sub_full<-pps[pps$model==system & pps$io_type==op_type & pps$io_size==op_size, c('percentile', 'latency')]
#   pps_sub_top<-pps[pps$model==system & pps$io_type==op_type & pps$io_size==op_size & pps$percentile <=70, c('percentile', 'latency')] 
  
#   x<-pps_sub_top$latency
#   y<-pps_sub_top$percentile
#   x_full<-pps_sub_full$latency
#   y_full<-pps_sub_full$percentile
#   erf <- function(x) 2 * pnorm(x * sqrt(2)) - 1
#   #m<-nls(y ~ 100*x^n/(b+x^n),start=list(b=2,n=1.4))
#   #m<-nls(y ~ 50*(1+erf((x-b2)/n2)),start=list(b2=2,n2=1.4))
#   m<-nls(y ~ 50*(1+erf((x-b2)/n2)),start=start_list)
#   c1<-summary(m)$coefficients[1]
#   c2<-summary(m)$coefficients[2]
#   z<-seq(0,100,0.01)
#   #xulim<-max(x_full*1.1)
#   plot(x_full,y_full,log='x',xlim=range(0.01:100),ylim=range(0:100))
#   title(paste(system,op_type,op_size))
#   #lines(z,100*z^c2/(c1+z^c2),lty=2,col="red",lwd=3)
#   lines(z,50*(1+erf((z-c1)/c2)),lty=2,col="red",lwd=3)
#   list(c1=c1,c2=c2)
# }
# systems<-c('HFA')
# op_types<-c('write')
# op_sizes<-c(1) #lower bound on op size in kib, inclusive

# l<-list()
# coeffs<-list()
# coeffs=try(generate_fit_v2(systems,op_types,op_sizes,list(b2=-0.1,n2=0.4)))
# l<-rbind(l,list(model=systems,io_type=op_types,op_size=op_sizes,coeff1=coeffs$c1,coeff2=coeffs$c2))
# perf_sev_summary <- data.frame(rbind(data.frame(l), perf_sev_summary))

perf_sev_summary_df = as.data.frame(matrix(unlist(perf_sev_summary), nrow=length(unlist(perf_sev_summary[1]))))
colnames(perf_sev_summary_df) = names(perf_sev_summary)
perf_sev_summary_df = perf_sev_summary_df[order(perf_sev_summary_df$model, perf_sev_summary_df$model, perf_sev_summary_df$io_type),]
write.csv(perf_sev_summary_df, "/Users/samalla/Desktop/MyJiras/IS27747/perf_sev_scores.csv")
##Saving all plots
# plots.dir.path <- list.files(tempdir(), pattern="rs-graphics", full.names = TRUE); 
# plots.png.paths <- list.files(plots.dir.path, pattern=".png", full.names = TRUE);
# file.copy(from=plots.png.paths, to="/Users/samalla/Desktop/MyJiras/IS27747/")