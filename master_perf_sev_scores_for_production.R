perf_sev_score_commitFeb2020 <- function(input, sql_parameters) {
  # UDF_input<-read.csv('C:/Users/dadamson/Desktop/example_UDF_input.csv')
  # nsReadCounts <- UDF_input[,seq(5,15)]
  # nsReadTimes <- UDF_input[,seq(17,27)]
  
  
  if(!is.null(sql_parameters[['op_type']]))
  {
    op_type=toString(sql_parameters[['op_type']])
  }
  else
  {
    stop("Expected parameter 'io_type' is missing from the sql function invocation (syntax: USING PARAMETERS op_type = 'nsRead|seqRead|write').")
  }
  
  if(!is.null(sql_parameters[['array_type']]))
  {
    array_type=toString(sql_parameters[['array_type']])
  }
  else
  {
    stop("Expected parameter 'array_type' is missing from the sql function invocation (syntax: USING PARAMETERS array_type = 'HFA|AFA').")
  }
  
  grain_minutes=NA
  grain_text=NA
  if(!is.null(sql_parameters[['time_grain_minutes']]))
  {
    
    if(sql_parameters[['time_grain_minutes']] %in% c(1,5,20,60,240,720,1440)) 
    {
      grain_minutes=toString(sql_parameters[['time_grain_minutes']])
    }
    else
    {
      stop("The parameter 'time_grain_minutes' is provided with an unsupported option. Currently only 1, 5, 20, 60, 240, 720 or 1440 minutes are supported.")
    }
  }
  else if(!is.null(sql_parameters[['time_grain']]))
  {
    
    if(sql_parameters[['time_grain']] %in% c('minute','5minute','20minute','hour','4hour','12hour','day')) 
    {
      grain_text=toString(sql_parameters[['time_grain']])
    }
    else
    {
      stop("The parameter 'time_grain' is provided with an unsupported option. Currently only 'minute','5minute','20minute','hour','4hour','12hour','day' are supported.")
    }
  }
  else
  {
    stop("Expected parameter 'time_grain_minutes' is missing from the sql function invocation (syntax: USING PARAMETERS time_grain_minutes = '1|5|20|60|240|720|1440').")
  }
  
  
  # originally we had a clear plan for how the scoring was supposed to change as a function of the aggregation granularity
  # upon more detailed analysis - the expected effect (narrowing of the variation as aggregation grain increase) is being convolved with an additional variable offset effect (that I attempt to explain by outliers within the hour shifting the average upwards)
  # different operation types and sizes seem to experience a mixing of these effects in different proportions - which muddles the justification for changing the scoring as a function of time)
  # unless we get justification using customer cases that shows that changing the aggregation merits a change in the scoring function - I think we should table this & not expect we know the correct way to do this.
  # the dominant effect is, as ever, the operation size variation.
  if(!is.na(grain_minutes))
  {
    grain<-switch(toString(grain_minutes),
                  '1'    = 'hour',
                  '5'    = 'hour',
                  '20'   = 'hour',
                  '60'   = 'hour',
                  '240'  = 'hour',
                  '720'  = 'hour',
                  '1440' = 'hour'
    )
  }
  else if(!is.na(grain_text))
  {
    grain<-switch(toString(grain_text),
                  'minute'   = 'hour',
                  '5minute'  = 'hour',
                  '20minute' = 'hour',
                  'hour'     = 'hour',
                  '4hour'    = 'hour',
                  '12hour'   = 'hour',
                  'day'      = 'hour'
    )
  }
  
  counts <- input[,seq(1,11)]
  times <- input[,seq(12,22)]
  latencies <- (times/counts)/1000
  
  #fit results of model derived from install base
  lines <- "time_grain,model,io_type,op_size,coeff1,coeff2
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
minute,AFA,write,512,12.31752,3.017494
hour,AFA,nsRead,0.5,0.00242350738806161,4.94993100681241
hour,AFA,nsRead,1,0.00836273743919754,4.27879933446997
hour,AFA,nsRead,2,0.0109836414846382,4.09523197028681
hour,AFA,nsRead,4,0.0197932993974314,3.90646431039819
hour,AFA,nsRead,8,0.0487400760945331,3.56004031850515
hour,AFA,nsRead,16,0.0760441143090992,3.8208953334063
hour,AFA,nsRead,32,0.212180756123896,4.01662907041418
hour,AFA,nsRead,64,0.594222293747623,3.51032362596604
hour,AFA,nsRead,128,3.37366217371593,3.42945556574254
hour,AFA,nsRead,256,17.9504365851935,3.37184916432531
hour,AFA,nsRead,512,56.3557838889419,3.07621493736135
hour,AFA,seqRead,0.5,0.00242350738806161,4.94993100681241
hour,AFA,seqRead,1,0.00836273743919754,4.27879933446997
hour,AFA,seqRead,2,0.0109836414846382,4.09523197028681
hour,AFA,seqRead,4,0.143096532315098,1.30268171892911
hour,AFA,seqRead,8,0.0916704271687756,1.58759591546867
hour,AFA,seqRead,16,0.120066913343491,1.61523084598326
hour,AFA,seqRead,32,0.18401946108951,1.40674813660825
hour,AFA,seqRead,64,0.171908343196899,1.43728260454357
hour,AFA,seqRead,128,0.237303654874913,1.33043358060289
hour,AFA,seqRead,256,0.678192443655563,1.43309278204023
hour,AFA,seqRead,512,0.909658489388057,1.28894010026475
hour,AFA,write,0.5,0.101647478273125,0.0840391120382238
hour,AFA,write,1,0.0821796158723312,0.0372649596847508
hour,AFA,write,2,0.0841721205138854,0.037109742984222
hour,AFA,write,4,0.0771851696515099,0.036565368446
hour,AFA,write,8,0.0886925383438576,0.0421386264709147
hour,AFA,write,16,0.108763227035507,0.0436693735608746
hour,AFA,write,32,0.156257946084195,0.0666949811143046
hour,AFA,write,64,0.000118060608883783,5.90040709445818
hour,AFA,write,128,0.00453243982460618,5.0718912688049
hour,AFA,write,256,0.072222827465486,5.31619004037143
hour,AFA,write,512,4.31220668995116,4.64683652162833
hour,HFA,nsRead,0.5,0.0374955064523777,1.75303431346959
hour,HFA,nsRead,1,0.091148020052921,1.77518049865031
hour,HFA,nsRead,2,0.0834912614320716,1.77423061788242
hour,HFA,nsRead,4,0.332333837092326,1.28281457961315
hour,HFA,nsRead,8,0.288243722174359,1.70723692600063
hour,HFA,nsRead,16,0.430740450992263,1.82104490093999
hour,HFA,nsRead,32,1.11774037758538,1.962863160066
hour,HFA,nsRead,64,1.3460995285575,1.79154739558271
hour,HFA,nsRead,128,2.94147193892209,1.76177695033379
hour,HFA,nsRead,256,10.493787051407,1.74706996270106
hour,HFA,nsRead,512,17.1995502086343,1.77043035273879
hour,HFA,seqRead,0.5,0.0374955064523777,1.75303431346959
hour,HFA,seqRead,1,0.091148020052921,1.77518049865031
hour,HFA,seqRead,2,0.0834912614320716,1.77423061788242
hour,HFA,seqRead,4,0.582747915604252,0.931683320417547
hour,HFA,seqRead,8,0.460871674630161,1.08803186515996
hour,HFA,seqRead,16,0.551292026706443,1.14177506351071
hour,HFA,seqRead,32,0.790808332386348,1.1894855800826
hour,HFA,seqRead,64,0.853531997675914,1.21170926113332
hour,HFA,seqRead,128,1.30116756139278,1.29107516336306
hour,HFA,seqRead,256,3.31069052824054,1.28235955741801
hour,HFA,seqRead,512,6.00218436993878,1.42309477734199
hour,HFA,write,0.5,0.0128965730618575,2.350722078365
hour,HFA,write,1,0.1050851,0.05779161
hour,HFA,write,2,0.000364781184029938,3.56313716471709
hour,HFA,write,4,0.00052017688216732,3.28661032095741
hour,HFA,write,8,0.000552924272546927,3.49896212071964
hour,HFA,write,16,0.00034319914613732,4.05794571064954
hour,HFA,write,32,0.000655026619208662,4.47661470928165
hour,HFA,write,64,0.0044487734631232,4.11762955079001
hour,HFA,write,128,0.0814898767229803,3.01750525414362
hour,HFA,write,256,0.250848127642304,3.91145864395133
hour,HFA,write,512,5.34132677456268,4.06837581492436
day,HFA,nsRead,0.5,0.1875712,1.482187 
day,HFA,nsRead,1,0.3178889,1.496639 
day,HFA,nsRead,2,0.2889994,1.445994 
day,HFA,nsRead,4,0.762678,1.533267 
day,HFA,nsRead,8,0.8101357,1.89963  
day,HFA,nsRead,16,1.087524,1.912728 
day,HFA,nsRead,32,2.092792,2.0067   
day,HFA,nsRead,64,3.861382,1.837659 
day,HFA,nsRead,128,10.06064,1.940138 
day,HFA,nsRead,256,14.35845,1.632507 
day,HFA,nsRead,512,17.23352,1.5876   
day,HFA,seqRead,0.5,0.1875712,1.482187 
day,HFA,seqRead,1,0.3178889,1.496639 
day,HFA,seqRead,2,0.2889994,1.445994 
day,HFA,seqRead,4,0.762678,1.533267 
day,HFA,seqRead,8,0.8101357,1.89963  
day,HFA,seqRead,16,1.087524,1.912728 
day,HFA,seqRead,32,2.092792,2.0067   
day,HFA,seqRead,64,3.861382,1.837659 
day,HFA,seqRead,128,10.06064,1.940138 
day,HFA,seqRead,256,14.35845,1.632507 
day,HFA,seqRead,512,17.23352,1.5876   
day,HFA,write,0.5,0.1875712,1.482187 
day,HFA,write,1,0.3178889,1.496639 
day,HFA,write,2,0.2889994,1.445994 
day,HFA,write,4,0.762678,1.533267 
day,HFA,write,8,0.8101357,1.89963  
day,HFA,write,16,1.087524,1.912728 
day,HFA,write,32,2.092792,2.0067   
day,HFA,write,64,3.861382,1.837659 
day,HFA,write,128,10.06064,1.940138 
day,HFA,write,256,14.35845,1.632507 
day,HFA,write,512,17.23352,1.5876   
day,AFA,nsRead,0.5,3.265734e-05,9.043661 
day,AFA,nsRead,1,0.00106016,5.315816 
day,AFA,nsRead,2,0.00106016,5.315816 
day,AFA,nsRead,4,0.000838139,6.397723 
day,AFA,nsRead,8,0.0008803157,7.948489 
day,AFA,nsRead,16,0.004349208,6.900752 
day,AFA,nsRead,32,0.03282763,6.247409 
day,AFA,nsRead,64,0.2417951,5.315818 
day,AFA,nsRead,128,2.071667,5.404995 
day,AFA,nsRead,256,13.24875,4.087651 
day,AFA,nsRead,512,36.35111,3.49506  
day,AFA,seqRead,0.5,3.265734e-05,9.043661 
day,AFA,seqRead,1,0.00106016,5.315816 
day,AFA,seqRead,2,0.00106016,5.315816 
day,AFA,seqRead,4,0.000838139,6.397723 
day,AFA,seqRead,8,0.0008803157,7.948489 
day,AFA,seqRead,16,0.004349208,6.900752 
day,AFA,seqRead,32,0.03282763,6.247409 
day,AFA,seqRead,64,0.2417951,5.315818 
day,AFA,seqRead,128,2.071667,5.404995 
day,AFA,seqRead,256,13.24875,4.087651 
day,AFA,seqRead,512,36.35111,3.49506  
day,AFA,write,0.5,3.265734e-05,9.043661 
day,AFA,write,1,0.00106016,5.315816 
day,AFA,write,2,0.00106016,5.315816 
day,AFA,write,4,0.000838139,6.397723 
day,AFA,write,8,0.0008803157,7.948489 
day,AFA,write,16,0.004349208,6.900752 
day,AFA,write,32,0.03282763,6.247409 
day,AFA,write,64,0.2417951,5.315818 
day,AFA,write,128,2.071667,5.404995 
day,AFA,write,256,13.24875,4.087651 
day,AFA,write,512,36.35111,3.49506"
  
  
  df_full<-read.csv(text=lines)
  
  #invented rows AFA seqRead: 0.5-2
  #invented rows AFA write: 0.5-64
  #several in AFA seq 
  
  df <- df_full[(df_full$io_type==op_type & df_full$model==array_type & df_full$time_grain==grain),]
  c <- counts
  t <- times
  l <- latencies
  b <- t(replicate(length(l[,1]),as.vector(df$coeff1)))
  n <- t(replicate(length(l[,1]),as.vector(df$coeff2)))
  q <- 100*((l^n)/(b+(l^n)))
  r <- q*c 
  s <- rowSums(r,na.rm=TRUE)/rowSums(c,na.rm=TRUE)
  
  return(
    list(
      perf_sev_score=s
    )
  )
}

udf_parameters <- function() {
  param <- data.frame(datatype=rep(NA,3), length=rep(NA,3), scale=rep(NA,3), name=rep(NA,3))
  param[1,1] = "varchar"
  param[1,4] = "op_type"
  param[2,1] = "varchar"
  param[2,4] = "array_type"
  param[3,1] = "varchar"
  param[3,4] = "time_grain"
  param[4,1] = "int"
  param[4,4] = "time_grain_minutes"
  param
}

perf_sev_score_factory <- function() {
  list (
    name		= perf_sev_score,
    udxtype		= c("scalar"),
    intype		= c("int","int","int","int","int","int","int","int","int","int","int","int","int","int","int","int","int","int","int","int","int","int"),
    outtype		= c("numeric"),
    parametertypecallback=udf_parameters,
    outnames	= c("perf_sev_score")
  )
}