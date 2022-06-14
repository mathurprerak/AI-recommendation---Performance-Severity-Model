library(minpack.lm)
library(plyr)

setwd("~/OneDrive - Hewlett Packard Enterprise/Sue Huang/AI Recommendation/1. Performance Severity Model/evaluation_20211112_20211118")
pps <- read_excel("impactscore_training_20211112_20211118.xlsx")

pps
dim(pps)

pps$p   <- pps$percentile
pps$l   <- pps$latency
pps$s   <- pps$io_size
pps$t   <- pps$io_type
pps$m   <- pps$model
pps$s1  <- pps$io_size==0.5
pps$s2  <- pps$io_size==1.0
pps$s3  <- pps$io_size==2.0
pps$s4  <- pps$io_size==4.0
pps$s5  <- pps$io_size==8.0
pps$s6  <- pps$io_size==16.0
pps$s7  <- pps$io_size==32.0
pps$s8  <- pps$io_size==64.0
pps$s9  <- pps$io_size==128.0
pps$s10 <- pps$io_size==256.0
pps$s11 <- pps$io_size==512.0

pps

start <- list(n=1.4,f1=0.3,f2=0.4,f3=0.5,f4=0.6,f5=0.7,f6=0.8,f7=0.9,f8=1.0,f9=1.1,f10=1.2,f11=1.3)
percentile_cutoff = 100



system='HFA'
op_type='nsRead'
method='binding'
start
filter_lt_4k=FALSE
percentile_cutoff=100

generate_fit_onehot <- function(system, op_type, method, start, filter_lt_4k, percentile_cutoff) {
  if (filter_lt_4k) { #remove f1,f2,f3 coefficients if those columns arent used since nlsLM will crash
    start$f1 <- NULL; start$f2 <- NULL; start$f3 <- NULL;
  }
  #for charting
  df_full <- pps[pps$m==system & pps$t==op_type,c('p','l','s')]
  dim(df_full)
  #for modeling
  df <- pps[(pps$m==system & pps$t==op_type & pps$p <= percentile_cutoff),]
  df <- df[,c('p','l','s1','s2','s3','s4','s5','s6','s7','s8','s9','s10','s11')]
  dim(df)
  #offset is one-hot encoded so only one s# variable should be 1 at a time all others 0
  #pick model and perform regression
  if (method=='binding') { #binding equation sigmoid
    z <- function(l,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,n,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11) {
      100 * (l^n)/(((s1*f1)+(s2*f2)+(s3*f3)+(s4*f4)+(s5*f5)+(s6*f6)+(s7*f7)+(s8*f8)+(s9*f9)+(s10*f10)+(s11*f11))+l^n)
    }
    zt <- function(l,s4,s5,s6,s7,s8,s9,s10,s11,n,f4,f5,f6,f7,f8,f9,f10,f11) {
      100 * (l^n)/(((s4*f4)+(s5*f5)+(s6*f6)+(s7*f7)+(s8*f8)+(s9*f9)+(s10*f10)+(s11*f11))+l^n)
    }
  } else if (method=='erf') { #error function sigmoid
    erf <- function(x) 2 * pnorm(x * sqrt(2)) - 1
    z <- function(l,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,n,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11) {
      50 * (1 + erf((l-((s1*f1)+(s2*f2)+(s3*f3)+(s4*f4)+(s5*f5)+(s6*f6)+(s7*f7)+(s8*f8)+(s9*f9)+(s10*f10)+(s11*f11)))/(n)))
    }
    zt <- function(l,s4,s5,s6,s7,s8,s9,s10,s11,n,f4,f5,f6,f7,f8,f9,f10,f11) {
      50 * (1 + erf((l-((s4*f4)+(s5*f5)+(s6*f6)+(s7*f7)+(s8*f8)+(s9*f9)+(s10*f10)+(s11*f11)))/(n)))
    }
  } else if (method=='logistic') { #logistic function sigmoid
    z <- function(l,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,n,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11) {
      100 * (1 / (1 + exp(n*l+((s1*f1)+(s2*f2)+(s3*f3)+(s4*f4)+(s5*f5)+(s6*f6)+(s7*f7)+(s8*f8)+(s9*f9)+(s10*f10)+(s11*f11)))))
    }
    zt <- function(l,s4,s5,s6,s7,s8,s9,s10,s11,n,f4,f5,f6,f7,f8,f9,f10,f11) {
      100 * (1 / (1 + exp(n*l+((s4*f4)+(s5*f5)+(s6*f6)+(s7*f7)+(s8*f8)+(s9*f9)+(s10*f10)+(s11*f11)))))
    }
  }
  if (filter_lt_4k) {
    model <- nlsLM(p ~ zt(l,s4,s5,s6,s7,s8,s9,s10,s11,n,f4,f5,f6,f7,f8,f9,f10,f11), start=start, data=df)
    c <- summary(model)$coefficients
    n=c[1];f4=c[2];f5=c[3];f6=c[4];f7=c[5];f8=c[6];f9=c[7];f10=c[8];f11=c[9];
  } else {
    model <- nlsLM(p ~ z(l,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,n,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11), start=start, data=df)
    c <- summary(model)$coefficients
    n=c[1];f1=c[2];f2=c[3];f3=c[4];f4=c[5];f5=c[6];f6=c[7];f7=c[8];f8=c[9];f9=c[10];f10=c[11];f11=c[12];
  }
  #extract coefficients and chart results
  sizes <- c(0.5,1,2,4,8,16,32,64,128,256,512)
  par(mfrow=c(4,3))
  for (i in 1:11) {
    size = sizes[i]
    df_slice = df_full[(df_full$s==size),]
    plot(df_slice$l,df_slice$p,log='x',xlim=range(0.01:100),ylim=range(0:100))
    title(paste(system,op_type,size))
    l <- seq(0,100,0.01)
    if (filter_lt_4k) {
      lines(l,zt(l,i==4,i==5,i==6,i==7,i==8,i==9,i==10,i==11,n,f4,f5,f6,f7,f8,f9,f10,f11),lty=2,col="red",lwd=3)
    } else {
      lines(l,z(l,i==1,i==2,i==3,i==4,i==5,i==6,i==7,i==8,i==9,i==10,i==11,n,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11),lty=2,col="red",lwd=3)
    }
  }
  #return model as output
  model
}


produce_translation_coefficients <- function(system, op_type, method, start, filter_lt_4k, percentile_cutoff) {
  model = generate_fit_onehot(system, op_type, method, start, filter_lt_4k, percentile_cutoff)
  if (!filter_lt_4k) {
    c = summary(model)$coefficients
    n = c[1]
    f = c[2:12]
    d = c[5]
    k <- function(x) (d/x)^(1/n)
    ks <- lapply(f,k)
  } else {
    c = summary(model)$coefficients
    n = c[1]
    f = c[2:9]
    d = c[2]
    k <- function(x) (d/x)^(1/n)
    ks <- lapply(f,k)    
  }
  unlist(ks)
}



k_hrr = produce_translation_coefficients('HFA','nsRead',  'binding', start, filter_lt_4k=FALSE, percentile_cutoff=100)
k_hrr
k_hsr = produce_translation_coefficients('HFA','seqRead', 'logistic', start, filter_lt_4k=FALSE, percentile_cutoff=100)
k_hw  = produce_translation_coefficients('HFA','write',   'binding', start, filter_lt_4k=FALSE, percentile_cutoff=100)
k_arr = produce_translation_coefficients('AFA','nsRead',  'erf', start, filter_lt_4k=FALSE, percentile_cutoff=100)
k_asr = produce_translation_coefficients('AFA','seqRead', 'binding', start, filter_lt_4k=TRUE,  percentile_cutoff=100)
k_aw  = produce_translation_coefficients('AFA','write',   'binding', start, filter_lt_4k=FALSE, percentile_cutoff=100)
