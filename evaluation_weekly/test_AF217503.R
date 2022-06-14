
####### single dt
setwd("~/OneDrive - Hewlett Packard Enterprise/Sue Huang/AI Recommendation/1. Performance Severity Model/evaluation_weekly")
pps=read.table("dt_AF217503_1128_10am.txt",header=TRUE,sep="\t")
pps


results=data.frame()
for (system in c("HFA","AFA")){
  for (op_type in c("nsRead","write",'seqRead')){
    for (size in c(0.5,1,2,4,8,16,32,64,128,256,512)){
      df_temp=pps[(pps$op_size_kb_lwr==size & pps$op_type==op_type),]
      df_temp
      model_slice_func=function(x,b,n){
        100*(x^n)/(b+x^n)
      }
      
      # production
      model_slice=original_model[(original_model$time_grain=='minute' & original_model$model==system & original_model$io_type==op_type & original_model$op_size==size),]
      model_slice
      b_orig=model_slice$coeff1
      n_orig=model_slice$coeff2
      
      results=rbind(results,c(system,op_type,size,'production',b_orig,n_orig,model_slice_func(df_temp$latency_ms,b_orig,n_orig)))
      colnames(results)=c('model','type','size',"production_or_refit",'estimated_b','estimated_n','predicted_percentile')
      results
      # refit
      model_temp=refit_model_1116_1121
      model_slice=model_temp[(model_temp$model==system & model_temp$io_type==op_type & model_temp$op_size==size),]
      model_slice
      estimated_b=model_slice$b
      estimated_n=model_slice$n
      
      results=rbind(results,c(system,op_type,size,'refit_1116_1121',estimated_b,estimated_n,model_slice_func(df_temp$latency_ms,estimated_b,estimated_n)))
      colnames(results)=c('model','type','size',"production_or_refit",'estimated_b','estimated_n','predicted_percentile')
      results
    }
  }
}
write_clip(results)