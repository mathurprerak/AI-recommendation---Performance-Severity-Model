perf_sev_score <- function(input, sql_parameters) {
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
hour,AFA,nsRead,0.5,0.00202935024472986,4.71070684445671
hour,AFA,nsRead,1,0.00657372314253324,4.23698910055233
hour,AFA,nsRead,2,0.00790062099241544,4.26161605002627
hour,AFA,nsRead,4,0.0109392917144615,3.94872971763475
hour,AFA,nsRead,8,0.0240734914031971,3.81947963542383
hour,AFA,nsRead,16,0.0450766299171223,3.94150412870282
hour,AFA,nsRead,32,0.118177142206257,4.14132879897973
hour,AFA,nsRead,64,0.370808248710781,3.78328025126648
hour,AFA,nsRead,128,2.17270859143756,3.60417211213791
hour,AFA,nsRead,256,17.8785226210857,3.72635304301756
hour,AFA,nsRead,512,48.9299851873514,3.24497124643675
hour,AFA,seqRead,0.5,0.00242350738806161,4.94993100681241
hour,AFA,seqRead,1,0.00836273743919754,4.27879933446997
hour,AFA,seqRead,2,0.0109836414846382,4.09523197028681
hour,AFA,seqRead,4,0.212301669900862,1.16657650262274
hour,AFA,seqRead,8,0.123575421656408,1.39625887336747
hour,AFA,seqRead,16,0.12143305888287,1.57996897457513
hour,AFA,seqRead,32,0.198424128312743,1.33253523838792
hour,AFA,seqRead,64,0.167305728627186,1.34103719337343
hour,AFA,seqRead,128,0.2144778898323,1.25861210233288
hour,AFA,seqRead,256,0.608570514805373,1.46225209192779
hour,AFA,seqRead,512,0.637842731943985,1.28089330297404
hour,AFA,write,0.5,0.00133317604110572,2.96621145096874
hour,AFA,write,1,1.95980448719002E-05,4.22447491777255
hour,AFA,write,2,5.99163917777892E-06,4.74954279540124
hour,AFA,write,4,9.70422389329369E-06,4.43513136556908
hour,AFA,write,8,0.000034945213325097,4.12730553765117
hour,AFA,write,16,2.10221572811913E-05,4.72032324629709
hour,AFA,write,32,0.000127154263677992,4.68189253401401
hour,AFA,write,64,0.00115598985809572,4.23105186611524
hour,AFA,write,128,0.0159946804539024,3.73636413207454
hour,AFA,write,256,0.107130064271462,4.31414405458982
hour,AFA,write,512,3.86926492880538,3.92513709773985
hour,HFA,nsRead,0.5,0.0230635953093976,1.81318293062603
hour,HFA,nsRead,1,0.064277969874646,1.94257661885044
hour,HFA,nsRead,2,0.0607733086433988,2.02799600631181
hour,HFA,nsRead,4,0.17273411829533,1.61802596554269
hour,HFA,nsRead,8,0.212384024395272,1.80386044514043
hour,HFA,nsRead,16,0.350218024851948,1.89232342969576
hour,HFA,nsRead,32,0.914777058714136,2.0678265817038
hour,HFA,nsRead,64,1.14132321239664,1.88104002422929
hour,HFA,nsRead,128,2.41002396124038,1.79950560522286
hour,HFA,nsRead,256,9.06858922056909,1.77545457382406
hour,HFA,nsRead,512,15.387630569626,1.75612053223714
hour,HFA,seqRead,0.5,0.0374955064523777,1.75303431346959
hour,HFA,seqRead,1,0.091148020052921,1.77518049865031
hour,HFA,seqRead,2,0.0834912614320716,1.77423061788242
hour,HFA,seqRead,4,0.769979701372943,0.924192323807984
hour,HFA,seqRead,8,0.548319274656508,1.01597741649579
hour,HFA,seqRead,16,0.577236332972725,1.05871700556416
hour,HFA,seqRead,32,0.827779126921847,1.11698078636484
hour,HFA,seqRead,64,0.731026016921248,1.12909249155296
hour,HFA,seqRead,128,1.008325144001,1.18697576018158
hour,HFA,seqRead,256,3.55789254112567,1.29470865813216
hour,HFA,seqRead,512,4.80466284968167,1.36861882717019
hour,HFA,write,0.5,0.00986416625762511,2.22288582993462
hour,HFA,write,1,0.000726247295389795,2.87658619808489
hour,HFA,write,2,0.00023736716577523,3.39458747700625
hour,HFA,write,4,0.00110380327490827,2.63658321195097
hour,HFA,write,8,0.00240028846827729,2.46770922361928
hour,HFA,write,16,0.0021805432817061,2.74154101197111
hour,HFA,write,32,0.00511224236263196,2.77114298048625
hour,HFA,write,64,0.0246824454759343,2.2914124028696
hour,HFA,write,128,0.0831200315383893,2.17644099450607
hour,HFA,write,256,0.161265804469958,3.33054346119762
hour,HFA,write,512,3.42087898076104,3.58946218727387
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
