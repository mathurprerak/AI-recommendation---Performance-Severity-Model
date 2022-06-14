### 1. model
### 2. save model results
### 3. evaluate in new data

## 1. modeling step

## 2. save model results
lines <- "time_grain,model,io_type,op_size,b,n
minute,HFA,nsRead,0.5,0.1295693,1.22575
minute,HFA,nsRead,1,0.1552203,1.20611
minute,HFA,nsRead,2,0.1375211,1.214983
minute,HFA,nsRead,4,0.3973689,1.373327
minute,HFA,nsRead,8,0.4466779,1.437339
minute,HFA,nsRead,16,0.530045,1.420987
minute,HFA,nsRead,32,1.107638,1.46628
minute,HFA,nsRead,64,1.209065,1.378658
minute,HFA,nsRead,128,2.363077,1.376234
minute,HFA,nsRead,256,3.73578,1.26259
minute,HFA,nsRead,512,4.607435,1.309086
minute,HFA,seqRead,0.5,0.1295693,1.22575
minute,HFA,seqRead,1,0.1552203,1.20611
minute,HFA,seqRead,2,0.1375211,1.214983
minute,HFA,seqRead,4,0.3973689,1.373327
minute,HFA,seqRead,8,0.4466779,1.437339
minute,HFA,seqRead,16,0.530045,1.420987
minute,HFA,seqRead,32,1.107638,1.46628
minute,HFA,seqRead,64,1.209065,1.378658
minute,HFA,seqRead,128,2.363077,1.376234
minute,HFA,seqRead,256,3.73578,1.26259
minute,HFA,seqRead,512,4.607435,1.309086
minute,HFA,write,0.5,0.1295693,1.22575
minute,HFA,write,1,0.1552203,1.20611
minute,HFA,write,2,0.1375211,1.214983
minute,HFA,write,4,0.3973689,1.373327
minute,HFA,write,8,0.4466779,1.437339
minute,HFA,write,16,0.530045,1.420987
minute,HFA,write,32,1.107638,1.46628
minute,HFA,write,64,1.209065,1.378658
minute,HFA,write,128,2.363077,1.376234
minute,HFA,write,256,3.73578,1.26259
minute,HFA,write,512,4.607435,1.309086
minute,AFA,nsRead,0.5,3.03509e-05,9.187715
minute,AFA,nsRead,1,0.01856692,2.676437
minute,AFA,nsRead,2,0.0008218127,5.64145
minute,AFA,nsRead,4,0.005552206,5.106355
minute,AFA,nsRead,8,0.005920429,6.202854
minute,AFA,nsRead,16,0.01078989,6.208824
minute,AFA,nsRead,32,0.05233761,6.019853
minute,AFA,nsRead,64,0.2231349,5.079823
minute,AFA,nsRead,128,2.11341,5.157953
minute,AFA,nsRead,256,17.57817,4.683163
minute,AFA,nsRead,512,12.31752,3.017494
minute,AFA,seqRead,0.5,3.03509e-05,9.187715
minute,AFA,seqRead,1,0.01856692,2.676437
minute,AFA,seqRead,2,0.0008218127,5.64145
minute,AFA,seqRead,4,0.005552206,5.106355
minute,AFA,seqRead,8,0.005920429,6.202854
minute,AFA,seqRead,16,0.01078989,6.208824
minute,AFA,seqRead,32,0.05233761,6.019853
minute,AFA,seqRead,64,0.2231349,5.079823
minute,AFA,seqRead,128,2.11341,5.157953
minute,AFA,seqRead,256,17.57817,4.683163
minute,AFA,seqRead,512,12.31752,3.017494
minute,AFA,write,0.5,3.03509e-05,9.187715
minute,AFA,write,1,0.01856692,2.676437
minute,AFA,write,2,0.0008218127,5.64145
minute,AFA,write,4,0.005552206,5.106355
minute,AFA,write,8,0.005920429,6.202854
minute,AFA,write,16,0.01078989,6.208824
minute,AFA,write,32,0.05233761,6.019853
minute,AFA,write,64,0.2231349,5.079823
minute,AFA,write,128,2.11341,5.157953
minute,AFA,write,256,17.57817,4.683163
minute,AFA,write,512,12.31752,3.017494"


original_model<-read.csv(text=lines)
original_model

refit_model_1116_1121<-read.csv(text="model,io_type,op_size,b,n
HFA,nsRead,0.5,0.0289674504615883,1.57289823072004
HFA,nsRead,1,0.0961716347047647,1.30215460718243
HFA,nsRead,2,0.0897166711637325,1.22713894561449
HFA,nsRead,4,0.184875263197438,1.55078449308712
HFA,nsRead,8,0.21351977000605,1.56462070425408
HFA,nsRead,16,0.31566164180552,1.49365574818156
HFA,nsRead,32,0.882738360473442,1.53944887576926
HFA,nsRead,64,0.791864621427119,1.43994185459611
HFA,nsRead,128,1.55146430102691,1.37069924600897
HFA,nsRead,256,5.42707214600844,1.43149729118808
HFA,nsRead,512,7.70073681484359,1.39678357582161
HFA,seqRead,4,0.382118428487,0.604562140095628
HFA,seqRead,8,0.48691773727328,0.745874479590843
HFA,seqRead,16,0.441610419790024,0.84271938938691
HFA,seqRead,32,0.714732325163671,0.896301039857487
HFA,seqRead,64,0.573094846031983,0.882561317333219
HFA,seqRead,128,0.778515898057908,0.887591720232146
HFA,seqRead,256,2.3139129926574,1.05924776173418
HFA,seqRead,512,5.52258852798784,1.21855932039861
HFA,write,0.5,0.0263525157520446,1.80205585599155
HFA,write,1,0.0143223516696881,1.66619347623477
HFA,write,2,0.0141910837869847,1.68818110759891
HFA,write,4,0.0167982258039739,1.56984151322991
HFA,write,8,0.0206273052405087,1.59054114589933
HFA,write,16,0.0258459564451243,1.6403482178839
HFA,write,32,0.0405330913235491,1.73043164465771
HFA,write,64,0.0639389951081664,1.83753180304404
HFA,write,128,0.120925542802931,2.09401402962936
HFA,write,256,0.237997220636636,3.36208809660433
HFA,write,512,3.46241736601799,3.70034450170382
AFA,nsRead,0.5,0.00200612430309755,4.84419440632645
AFA,nsRead,1,0.00908309811164744,3.84600620468934
AFA,nsRead,2,0.0111118104315019,3.80215786401768
AFA,nsRead,4,0.00978627977766059,4.03700432649137
AFA,nsRead,8,0.0204766437809661,3.98562577136531
AFA,nsRead,16,0.0363855814167699,4.19657354569123
AFA,nsRead,32,0.117759105234392,4.26027332330529
AFA,nsRead,64,0.351569917865365,3.67174679937159
AFA,nsRead,128,2.29535616558133,3.58119561928659
AFA,nsRead,256,16.8735958204368,3.71617259226411
AFA,nsRead,512,32.3587135478502,2.92115822971825
AFA,seqRead,4,0.159010856924012,0.980799879687084
AFA,seqRead,8,0.167800628743923,1.14588474486926
AFA,seqRead,16,0.119713786216055,1.52982109482187
AFA,seqRead,32,0.209021264077332,1.25935586815017
AFA,seqRead,64,0.160989042881501,1.11306159385655
AFA,seqRead,128,0.241391826866859,0.982659455346187
AFA,seqRead,256,0.60322527001924,1.20241749364457
AFA,seqRead,512,0.778622389625073,1.0729221066391
AFA,write,0.5,0.000098125820508227,4.01571816709697
AFA,write,1,2.08825882779869E-07,5.95002767550432
AFA,write,2,1.05703634648654E-07,6.28666657993637
AFA,write,32,2.03922986552489E-06,6.82479301813651
AFA,write,64,2.45987294196578E-05,6.61629363604244
AFA,write,128,0.00252397483387084,5.24629902036717
AFA,write,256,0.0626676324219492,5.1974696488739
AFA,write,512,3.78350006800315,4.69924311509651")
refit_model_1116_1121

## 3. evaluate in new data
library(minpack.lm)
library(plyr)
library(readxl)

setwd("~/OneDrive - Hewlett Packard Enterprise/Sue Huang/AI Recommendation/1. Performance Severity Model/evaluation_weekly")
pps=read.table("dt_1122_1128.txt",header=TRUE,sep="\t")
head(pps)
dim(pps)

# create new col for one-hot
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

dim(pps)
head(pps)

model_single_2par=function(x,b,n){
  100*(x^n)/(b+x^n)
}

evaluate_66seg=function(dt_input,system,op_type,size,model_results,comment){
  df_temp=dt_input[dt_input$model==system & dt_input$io_type==op_type & dt_input$io_size==size,]
  head(df_temp)
  
  # production
  model_slice=model_results[(model_results$model==system & model_results$io_type==op_type & model_results$op_size==size),]
  model_slice
  estimated_b=model_slice$b
  estimated_n=model_slice$n
  
  estimated_p=model_single_2par(df_temp$l,estimated_b,estimated_n)
  error=mean(df_temp$percentile-estimated_p)
  results=rbind(c(comment,system,op_type,size,estimated_b,estimated_n,error,paste(estimated_p,collapse=";")))
  colnames(results)=c('model','system','type','size','estimated_b','estimated_n','error','predicted_percentile')
  return(results)
  
}

evaluate_66seg(pps,'HFA','nsRead',0.5,refit_model_1116_1121,'refit')

pdf(file="evaluation_1122_1128.pdf")
results=data.frame()
dt_input=pps
for (system in c("HFA","AFA")){
  for (op_type in c("nsRead","write",'seqRead')){
    for (size in c(0.5,1,2,4,8,16,32,64,128,256,512)){
      df_temp=dt_input[dt_input$model==system & dt_input$io_type==op_type & dt_input$io_size==size,]
      plot(df_temp$latency,df_temp$percentile,log='x',xlim=range(0.01:100),ylim=range(0:100),xlab='Latency',ylab='Percentile')
      title(paste(system,op_type,size))
      l=seq(0,100,0.01)
      
      results_existing=try(evaluate_66seg(pps,system,op_type,size,original_model,comment='original_model'))
      if (length(results_existing)>1){
        results=rbind(results,results_existing)
        lines(l,model_single_2par(l,as.numeric(results_existing[,'estimated_b']),as.numeric(results_existing[,'estimated_n'])),col='red',lty=2,lwd=3)
        legend('topleft',legend=paste('production_model, error=',round(as.numeric(results_existing[,'error']),2)),col='red',lty=2,lwd=3)

      }
      results_refit=try(evaluate_66seg(pps,system,op_type,size,refit_model_1116_1121,comment='refit_1116_1121'))
      if (length(results_refit)>1){
        results=rbind(results,results_refit)
        lines(l,model_single_2par(l,as.numeric(results_refit[,'estimated_b']),as.numeric(results_refit[,'estimated_n'])),col='blue',lty=2,lwd=3)
        legend('bottomright',legend=paste('refit_model, error=',round(as.numeric(results_refit[,'error']),2)),col=c('blue'),lty=2,cex=1,lwd=3)
        
      }
      #legend('topleft',legend=c(paste('production_model, error=',round(as.numeric(results_existing[,'error']),2)),paste('refit_model, error=',round(as.numeric(results_refit[,'error'])),2)),col=c('red','blue'),lty=2,lwd=3)
      
    }
  }
}
dev.off() 

results
write_clip(results)

evaluate_onehot_6seg=function(df_temp,system,op_type,model_results){
  
}
