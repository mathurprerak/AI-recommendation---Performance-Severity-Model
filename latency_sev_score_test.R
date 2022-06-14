library(clipr)

datainput <- "seqNumReadS512B-1k,seqNumReadS1k-2k,seqNumReadS2k-4k,seqNumReadS4k-8k,seqNumReadS8k-16k,seqNumReadS16k-32k,seqNumReadS32k-64k,seqNumReadS64k-128k,seqNumReadS128k-256k,seqNumReadS256k-512k,seqNumReadS512k-max,seqTimeReadS512B-1k,seqTimeReadS1k-2k,seqTimeReadS2k-4k,seqTimeReadS4k-8k,seqTimeReadS8k-16k,seqTimeReadS16k-32k,seqTimeReadS32k-64k,seqTimeReadS64k-128k,seqTimeReadS128k-256k,seqTimeReadS256k-512k,seqTimeReadS512k-max
0,0,0,2,45,514,2560,3909,43279,22,24864,0,0,0,216,117263,3069939,11045582,4907556,315546657,2046615,2974744824
0,0,0,2,1662,446,1911,3276,34688,21,23618,0,0,0,97467,2310098,2533713,9071256,11892263,293344166,1590143,2929902711
0,0,0,4,4398,914,1871,6063,89521,20,22472,0,0,0,77608,2513319,3895932,13081823,97219951,1400426119,2126022,4443795459
0,0,0,2,989,964,2950,10169,94816,20,21666,0,0,0,27,16700201,19199314,45543257,243962595,1572140258,2279892,4884780175
0,0,0,0,226,644,2003,22579,87385,23,22499,0,0,0,0,1479030,18775570,33341058,846619853,1338643927,2168619,4559378089
0,0,0,0,18,201,1338,21483,115475,23,23014,0,0,0,0,271912,606802,25217090,755925172,1543066082,2885679,4967636886
0,0,0,0,830,1513,3977,62776,103008,25,22347,0,0,0,0,30322677,20798029,77868916,555554307,1896372545,4355543,5033925046
"
dt=read.csv(text=datainput)

head(dt)

x1=perf_sev_score_commitFeb2020(input=dt,sql_parameter=data.frame(op_type = 'seqRead', array_type = 'HFA', time_grain = 'hour'))
x2=perf_sev_score_commitFeb2020(input=dt,sql_parameter=data.frame(op_type = 'seqRead', array_type = 'HFA', time_grain = 'minute'))
x1
x2
write_clip(x1,"table")

y1=perf_sev_score(input=dt,sql_parameter=data.frame(op_type = 'seqRead', array_type = 'HFA', time_grain = 'hour'))
write_clip(y1,"table")
