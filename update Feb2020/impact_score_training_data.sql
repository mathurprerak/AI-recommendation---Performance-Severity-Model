DROP TABLE if exists scratch0.perf_sev_per_hour_all;

CREATE TABLE scratch0.perf_sev_per_hour_all 
AS
SELECT s."Array SN",
       s."Array Hostname",
       date_trunc('hour',s."Sensors Local Timestamp") AS "Sensors Local Hour",
       map_raw_model_to_array_type("Array Model") AS array_type,
       map_raw_model_to_array_series("Array Model") AS array_model,
       SUM(reads) AS reads,
       SUM(writes) AS writes,
       SUM(readBytes) AS readBytes,
       SUM(writeBytes) AS writeBytes,
       SUM("nsNumReadS0B-512B") AS "nsNumReadS0B-512B",
       SUM("nsNumReadS512B-1k") AS "nsNumReadS512B-1k",
       SUM("nsNumReadS1k-2k") AS "nsNumReadS1k-2k",
       SUM("nsNumReadS2k-4k") AS "nsNumReadS2k-4k",
       SUM("nsNumReadS4k-8k") AS "nsNumReadS4k-8k",
       SUM("nsNumReadS8k-16k") AS "nsNumReadS8k-16k",
       SUM("nsNumReadS16k-32k") AS "nsNumReadS16k-32k",
       SUM("nsNumReadS32k-64k") AS "nsNumReadS32k-64k",
       SUM("nsNumReadS64k-128k") AS "nsNumReadS64k-128k",
       SUM("nsNumReadS128k-256k") AS "nsNumReadS128k-256k",
       SUM("nsNumReadS256k-512k") AS "nsNumReadS256k-512k",
       SUM("nsNumReadS512k-max") AS "nsNumReadS512k-max",
       SUM("seqNumReadS0B-512B") AS "seqNumReadS0B-512B",
       SUM("seqNumReadS512B-1k") AS "seqNumReadS512B-1k",
       SUM("seqNumReadS1k-2k") AS "seqNumReadS1k-2k",
       SUM("seqNumReadS2k-4k") AS "seqNumReadS2k-4k",
       SUM("seqNumReadS4k-8k") AS "seqNumReadS4k-8k",
       SUM("seqNumReadS8k-16k") AS "seqNumReadS8k-16k",
       SUM("seqNumReadS16k-32k") AS "seqNumReadS16k-32k",
       SUM("seqNumReadS32k-64k") AS "seqNumReadS32k-64k",
       SUM("seqNumReadS64k-128k") AS "seqNumReadS64k-128k",
       SUM("seqNumReadS128k-256k") AS "seqNumReadS128k-256k",
       SUM("seqNumReadS256k-512k") AS "seqNumReadS256k-512k",
       SUM("seqNumReadS512k-max") AS "seqNumReadS512k-max",
       SUM("numWriteS0B-512B") AS "numWriteS0B-512B",
       SUM("numWriteS512B-1k") AS "numWriteS512B-1k",
       SUM("numWriteS1k-2k") AS "numWriteS1k-2k",
       SUM("numWriteS2k-4k") AS "numWriteS2k-4k",
       SUM("numWriteS4k-8k") AS "numWriteS4k-8k",
       SUM("numWriteS8k-16k") AS "numWriteS8k-16k",
       SUM("numWriteS16k-32k") AS "numWriteS16k-32k",
       SUM("numWriteS32k-64k") AS "numWriteS32k-64k",
       SUM("numWriteS64k-128k") AS "numWriteS64k-128k",
       SUM("numWriteS128k-256k") AS "numWriteS128k-256k",
       SUM("numWriteS256k-512k") AS "numWriteS256k-512k",
       SUM("numWriteS512k-max") AS "numWriteS512k-max",
       SUM("nsTimeReadS0B-512B") AS "nsTimeReadS0B-512B",
       SUM("nsTimeReadS512B-1k") AS "nsTimeReadS512B-1k",
       SUM("nsTimeReadS1k-2k") AS "nsTimeReadS1k-2k",
       SUM("nsTimeReadS2k-4k") AS "nsTimeReadS2k-4k",
       SUM("nsTimeReadS4k-8k") AS "nsTimeReadS4k-8k",
       SUM("nsTimeReadS8k-16k") AS "nsTimeReadS8k-16k",
       SUM("nsTimeReadS16k-32k") AS "nsTimeReadS16k-32k",
       SUM("nsTimeReadS32k-64k") AS "nsTimeReadS32k-64k",
       SUM("nsTimeReadS64k-128k") AS "nsTimeReadS64k-128k",
       SUM("nsTimeReadS128k-256k") AS "nsTimeReadS128k-256k",
       SUM("nsTimeReadS256k-512k") AS "nsTimeReadS256k-512k",
       SUM("nsTimeReadS512k-max") AS "nsTimeReadS512k-max",
       SUM("seqTimeReadS0B-512B") AS "seqTimeReadS0B-512B",
       SUM("seqTimeReadS512B-1k") AS "seqTimeReadS512B-1k",
       SUM("seqTimeReadS1k-2k") AS "seqTimeReadS1k-2k",
       SUM("seqTimeReadS2k-4k") AS "seqTimeReadS2k-4k",
       SUM("seqTimeReadS4k-8k") AS "seqTimeReadS4k-8k",
       SUM("seqTimeReadS8k-16k") AS "seqTimeReadS8k-16k",
       SUM("seqTimeReadS16k-32k") AS "seqTimeReadS16k-32k",
       SUM("seqTimeReadS32k-64k") AS "seqTimeReadS32k-64k",
       SUM("seqTimeReadS64k-128k") AS "seqTimeReadS64k-128k",
       SUM("seqTimeReadS128k-256k") AS "seqTimeReadS128k-256k",
       SUM("seqTimeReadS256k-512k") AS "seqTimeReadS256k-512k",
       SUM("seqTimeReadS512k-max") AS "seqTimeReadS512k-max",
       SUM("timeWriteS0B-512B") AS "timeWriteS0B-512B",
       SUM("timeWriteS512B-1k") AS "timeWriteS512B-1k",
       SUM("timeWriteS1k-2k") AS "timeWriteS1k-2k",
       SUM("timeWriteS2k-4k") AS "timeWriteS2k-4k",
       SUM("timeWriteS4k-8k") AS "timeWriteS4k-8k",
       SUM("timeWriteS8k-16k") AS "timeWriteS8k-16k",
       SUM("timeWriteS16k-32k") AS "timeWriteS16k-32k",
       SUM("timeWriteS32k-64k") AS "timeWriteS32k-64k",
       SUM("timeWriteS64k-128k") AS "timeWriteS64k-128k",
       SUM("timeWriteS128k-256k") AS "timeWriteS128k-256k",
       SUM("timeWriteS256k-512k") AS "timeWriteS256k-512k",
       SUM("timeWriteS512k-max") AS "timeWriteS512k-max"
FROM sensors0.array_ds_sys_diff s
  INNER JOIN cube0.arrays_byday t
          ON s."Array SN" = t."Array SN"
         AND s."Sensors Local Date" = t."ASUP Local Date"
WHERE "Grain" = 'pm'
AND   "ASUP Local Date" >= date_trunc('Week',now() -INTERVAL '1 week')
AND   "ASUP Local Date" <now()
AND   reads + writes > 0
AND   "timeReads" IS NOT NULL
AND   "timeWrites" IS NOT NULL
GROUP BY s."Array SN",
         s."Array Hostname",
         date_trunc('hour',s."Sensors Local Timestamp"),
         map_raw_model_to_array_type("Array Model"),
         map_raw_model_to_array_series("Array Model");


drop table if exists scratch0.melted_perf_sev_per_hour_all;
create table scratch0.melted_perf_sev_per_hour_all as
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 0   as op_size_kb_lwr, 0.5       as op_size_kb_upr, 'nsRead' as op_type, "nsNumReadS0B-512B"   as num_ops, "nsTimeReadS0B-512B"   as time_ops, case when "nsNumReadS0B-512B"   > 0 then ("nsTimeReadS0B-512B"  /1000)/"nsNumReadS0B-512B"   else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 0.5 as op_size_kb_lwr, 1         as op_size_kb_upr, 'nsRead' as op_type, "nsNumReadS512B-1k"   as num_ops, "nsTimeReadS512B-1k"   as time_ops, case when "nsNumReadS512B-1k"   > 0 then ("nsTimeReadS512B-1k"  /1000)/"nsNumReadS512B-1k"   else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 1   as op_size_kb_lwr, 2         as op_size_kb_upr, 'nsRead' as op_type, "nsNumReadS1k-2k"     as num_ops, "nsTimeReadS1k-2k"     as time_ops, case when "nsNumReadS1k-2k"     > 0 then ("nsTimeReadS1k-2k"    /1000)/"nsNumReadS1k-2k"     else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 2   as op_size_kb_lwr, 4         as op_size_kb_upr, 'nsRead' as op_type, "nsNumReadS2k-4k"     as num_ops, "nsTimeReadS2k-4k"     as time_ops, case when "nsNumReadS2k-4k"     > 0 then ("nsTimeReadS2k-4k"    /1000)/"nsNumReadS2k-4k"     else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 4   as op_size_kb_lwr, 8         as op_size_kb_upr, 'nsRead' as op_type, "nsNumReadS4k-8k"     as num_ops, "nsTimeReadS4k-8k"     as time_ops, case when "nsNumReadS4k-8k"     > 0 then ("nsTimeReadS4k-8k"    /1000)/"nsNumReadS4k-8k"     else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 8   as op_size_kb_lwr, 16        as op_size_kb_upr, 'nsRead' as op_type, "nsNumReadS8k-16k"    as num_ops, "nsTimeReadS8k-16k"    as time_ops, case when "nsNumReadS8k-16k"    > 0 then ("nsTimeReadS8k-16k"   /1000)/"nsNumReadS8k-16k"    else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 16  as op_size_kb_lwr, 32        as op_size_kb_upr, 'nsRead' as op_type, "nsNumReadS16k-32k"   as num_ops, "nsTimeReadS16k-32k"   as time_ops, case when "nsNumReadS16k-32k"   > 0 then ("nsTimeReadS16k-32k"  /1000)/"nsNumReadS16k-32k"   else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 32  as op_size_kb_lwr, 64        as op_size_kb_upr, 'nsRead' as op_type, "nsNumReadS32k-64k"   as num_ops, "nsTimeReadS32k-64k"   as time_ops, case when "nsNumReadS32k-64k"   > 0 then ("nsTimeReadS32k-64k"  /1000)/"nsNumReadS32k-64k"   else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 64  as op_size_kb_lwr, 128       as op_size_kb_upr, 'nsRead' as op_type, "nsNumReadS64k-128k"  as num_ops, "nsTimeReadS64k-128k"  as time_ops, case when "nsNumReadS64k-128k"  > 0 then ("nsTimeReadS64k-128k" /1000)/"nsNumReadS64k-128k"  else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 128 as op_size_kb_lwr, 256       as op_size_kb_upr, 'nsRead' as op_type, "nsNumReadS128k-256k" as num_ops, "nsTimeReadS128k-256k" as time_ops, case when "nsNumReadS128k-256k" > 0 then ("nsTimeReadS128k-256k"/1000)/"nsNumReadS128k-256k" else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 256 as op_size_kb_lwr, 512       as op_size_kb_upr, 'nsRead' as op_type, "nsNumReadS256k-512k" as num_ops, "nsTimeReadS256k-512k" as time_ops, case when "nsNumReadS256k-512k" > 0 then ("nsTimeReadS256k-512k"/1000)/"nsNumReadS256k-512k" else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 512 as op_size_kb_lwr, null::int as op_size_kb_upr, 'nsRead' as op_type, "nsNumReadS512k-max"  as num_ops, "nsTimeReadS512k-max"  as time_ops, case when "nsNumReadS512k-max"  > 0 then ("nsTimeReadS512k-max" /1000)/"nsNumReadS512k-max"  else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 0   as op_size_kb_lwr, 0.5       as op_size_kb_upr, 'seqRead' as op_type, "seqNumReadS0B-512B"   as num_ops, "seqTimeReadS0B-512B"   as time_ops, case when "seqNumReadS0B-512B"   > 0 then ("seqTimeReadS0B-512B"  /1000)/"seqNumReadS0B-512B"   else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 0.5 as op_size_kb_lwr, 1         as op_size_kb_upr, 'seqRead' as op_type, "seqNumReadS512B-1k"   as num_ops, "seqTimeReadS512B-1k"   as time_ops, case when "seqNumReadS512B-1k"   > 0 then ("seqTimeReadS512B-1k"  /1000)/"seqNumReadS512B-1k"   else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 1   as op_size_kb_lwr, 2         as op_size_kb_upr, 'seqRead' as op_type, "seqNumReadS1k-2k"     as num_ops, "seqTimeReadS1k-2k"     as time_ops, case when "seqNumReadS1k-2k"     > 0 then ("seqTimeReadS1k-2k"    /1000)/"seqNumReadS1k-2k"     else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 2   as op_size_kb_lwr, 4         as op_size_kb_upr, 'seqRead' as op_type, "seqNumReadS2k-4k"     as num_ops, "seqTimeReadS2k-4k"     as time_ops, case when "seqNumReadS2k-4k"     > 0 then ("seqTimeReadS2k-4k"    /1000)/"seqNumReadS2k-4k"     else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 4   as op_size_kb_lwr, 8         as op_size_kb_upr, 'seqRead' as op_type, "seqNumReadS4k-8k"     as num_ops, "seqTimeReadS4k-8k"     as time_ops, case when "seqNumReadS4k-8k"     > 0 then ("seqTimeReadS4k-8k"    /1000)/"seqNumReadS4k-8k"     else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 8   as op_size_kb_lwr, 16        as op_size_kb_upr, 'seqRead' as op_type, "seqNumReadS8k-16k"    as num_ops, "seqTimeReadS8k-16k"    as time_ops, case when "seqNumReadS8k-16k"    > 0 then ("seqTimeReadS8k-16k"   /1000)/"seqNumReadS8k-16k"    else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 16  as op_size_kb_lwr, 32        as op_size_kb_upr, 'seqRead' as op_type, "seqNumReadS16k-32k"   as num_ops, "seqTimeReadS16k-32k"   as time_ops, case when "seqNumReadS16k-32k"   > 0 then ("seqTimeReadS16k-32k"  /1000)/"seqNumReadS16k-32k"   else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 32  as op_size_kb_lwr, 64        as op_size_kb_upr, 'seqRead' as op_type, "seqNumReadS32k-64k"   as num_ops, "seqTimeReadS32k-64k"   as time_ops, case when "seqNumReadS32k-64k"   > 0 then ("seqTimeReadS32k-64k"  /1000)/"seqNumReadS32k-64k"   else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 64  as op_size_kb_lwr, 128       as op_size_kb_upr, 'seqRead' as op_type, "seqNumReadS64k-128k"  as num_ops, "seqTimeReadS64k-128k"  as time_ops, case when "seqNumReadS64k-128k"  > 0 then ("seqTimeReadS64k-128k" /1000)/"seqNumReadS64k-128k"  else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 128 as op_size_kb_lwr, 256       as op_size_kb_upr, 'seqRead' as op_type, "seqNumReadS128k-256k" as num_ops, "seqTimeReadS128k-256k" as time_ops, case when "seqNumReadS128k-256k" > 0 then ("seqTimeReadS128k-256k"/1000)/"seqNumReadS128k-256k" else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 256 as op_size_kb_lwr, 512       as op_size_kb_upr, 'seqRead' as op_type, "seqNumReadS256k-512k" as num_ops, "seqTimeReadS256k-512k" as time_ops, case when "seqNumReadS256k-512k" > 0 then ("seqTimeReadS256k-512k"/1000)/"seqNumReadS256k-512k" else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 512 as op_size_kb_lwr, null::int as op_size_kb_upr, 'seqRead' as op_type, "seqNumReadS512k-max"  as num_ops, "seqTimeReadS512k-max"  as time_ops, case when "seqNumReadS512k-max"  > 0 then ("seqTimeReadS512k-max" /1000)/"seqNumReadS512k-max"  else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 0   as op_size_kb_lwr, 0.5       as op_size_kb_upr, 'write' as op_type, "numWriteS0B-512B"   as num_ops, "timeWriteS0B-512B"   as time_ops, case when "numWriteS0B-512B"   > 0 then ("timeWriteS0B-512B"  /1000)/"numWriteS0B-512B"   else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 0.5 as op_size_kb_lwr, 1         as op_size_kb_upr, 'write' as op_type, "numWriteS512B-1k"   as num_ops, "timeWriteS512B-1k"   as time_ops, case when "numWriteS512B-1k"   > 0 then ("timeWriteS512B-1k"  /1000)/"numWriteS512B-1k"   else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 1   as op_size_kb_lwr, 2         as op_size_kb_upr, 'write' as op_type, "numWriteS1k-2k"     as num_ops, "timeWriteS1k-2k"     as time_ops, case when "numWriteS1k-2k"     > 0 then ("timeWriteS1k-2k"    /1000)/"numWriteS1k-2k"     else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 2   as op_size_kb_lwr, 4         as op_size_kb_upr, 'write' as op_type, "numWriteS2k-4k"     as num_ops, "timeWriteS2k-4k"     as time_ops, case when "numWriteS2k-4k"     > 0 then ("timeWriteS2k-4k"    /1000)/"numWriteS2k-4k"     else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 4   as op_size_kb_lwr, 8         as op_size_kb_upr, 'write' as op_type, "numWriteS4k-8k"     as num_ops, "timeWriteS4k-8k"     as time_ops, case when "numWriteS4k-8k"     > 0 then ("timeWriteS4k-8k"    /1000)/"numWriteS4k-8k"     else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 8   as op_size_kb_lwr, 16        as op_size_kb_upr, 'write' as op_type, "numWriteS8k-16k"    as num_ops, "timeWriteS8k-16k"    as time_ops, case when "numWriteS8k-16k"    > 0 then ("timeWriteS8k-16k"   /1000)/"numWriteS8k-16k"    else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 16  as op_size_kb_lwr, 32        as op_size_kb_upr, 'write' as op_type, "numWriteS16k-32k"   as num_ops, "timeWriteS16k-32k"   as time_ops, case when "numWriteS16k-32k"   > 0 then ("timeWriteS16k-32k"  /1000)/"numWriteS16k-32k"   else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 32  as op_size_kb_lwr, 64        as op_size_kb_upr, 'write' as op_type, "numWriteS32k-64k"   as num_ops, "timeWriteS32k-64k"   as time_ops, case when "numWriteS32k-64k"   > 0 then ("timeWriteS32k-64k"  /1000)/"numWriteS32k-64k"   else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 64  as op_size_kb_lwr, 128       as op_size_kb_upr, 'write' as op_type, "numWriteS64k-128k"  as num_ops, "timeWriteS64k-128k"  as time_ops, case when "numWriteS64k-128k"  > 0 then ("timeWriteS64k-128k" /1000)/"numWriteS64k-128k"  else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 128 as op_size_kb_lwr, 256       as op_size_kb_upr, 'write' as op_type, "numWriteS128k-256k" as num_ops, "timeWriteS128k-256k" as time_ops, case when "numWriteS128k-256k" > 0 then ("timeWriteS128k-256k"/1000)/"numWriteS128k-256k" else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 256 as op_size_kb_lwr, 512       as op_size_kb_upr, 'write' as op_type, "numWriteS256k-512k" as num_ops, "timeWriteS256k-512k" as time_ops, case when "numWriteS256k-512k" > 0 then ("timeWriteS256k-512k"/1000)/"numWriteS256k-512k" else null end as latency_ms from   scratch0.perf_sev_per_hour_all  union all
select "Array SN", "Array Hostname",  array_model, array_type, reads, writes, readBytes, writeBytes,  "Sensors Local Hour", 512 as op_size_kb_lwr, null::int as op_size_kb_upr, 'write' as op_type, "numWriteS512k-max"  as num_ops, "timeWriteS512k-max"  as time_ops, case when "numWriteS512k-max"  > 0 then ("timeWriteS512k-max" /1000)/"numWriteS512k-max"  else null end as latency_ms from   scratch0.perf_sev_per_hour_all ;
 
DROP TABLE if exists scratch0.ntiled_perf_sev_per_hour_all;

CREATE TABLE scratch0.ntiled_perf_sev_per_hour_all 
AS
at epoch latest
SELECT array_type,
       array_model,
       op_type,
       op_size_kb_lwr,
       latency_ms,
       num_ops,
       time_ops,
       reads,
       writes,
       readBytes,
       writeBytes,
       ntile(100) OVER (PARTITION BY array_model,op_type,op_size_kb_lwr ORDER BY latency_ms) AS ntile100_model,
       ntile(100) OVER (PARTITION BY array_type,op_type,op_size_kb_lwr ORDER BY latency_ms) AS ntile100_type,
       ntile(100) OVER (PARTITION BY op_type,op_size_kb_lwr ORDER BY latency_ms) AS ntile100
FROM scratch0.melted_perf_sev_per_hour_all
WHERE latency_ms IS NOT NULL;


DROP TABLE if exists scratch0.ntile_table_perf_sev_per_hour_all;

CREATE TABLE scratch0.ntile_table_perf_sev_per_hour_all 
AS
at epoch latest
SELECT array_type AS model,
       ntile100_type -1 AS percentile,
       op_type AS io_type,
       op_size_kb_lwr AS io_size,
       MIN(latency_ms) AS latency
FROM scratch0.ntiled_perf_sev_per_hour_all
WHERE array_type IS NOT NULL
GROUP BY array_type,
         ntile100_type,
         op_type,
         op_size_kb_lwr;



-- select perf_sev_score(0,0,0,0,0,0,0,0,0,0,1000,0,0,0,0,0,0,0,0,0,0,10000
--      USING PARAMETERS op_type = 'nsRead', array_type = 'AFA', time_grain = 'hour') AS perf_sev_ns_read,
-- perf_sev_score("seqNumReadS512B-1k","seqNumReadS1k-2k","seqNumReadS2k-4k","seqNumReadS4k-8k","seqNumReadS8k-16k","seqNumReadS16k-32k","seqNumReadS32k-64k","seqNumReadS64k-128k","seqNumReadS128k-256k","seqNumReadS256k-512k","seqNumReadS512k-max","seqTimeReadS512B-1k","seqTimeReadS1k-2k","seqTimeReadS2k-4k","seqTimeReadS4k-8k","seqTimeReadS8k-16k","seqTimeReadS16k-32k","seqTimeReadS32k-64k","seqTimeReadS64k-128k","seqTimeReadS128k-256k","seqTimeReadS256k-512k","seqTimeReadS512k-max"
--      USING PARAMETERS op_type = 'seqRead', array_type = 'AFA', time_grain = 'hour') AS perf_sev_seq_read,
-- perf_sev_score("numWriteS512B-1k","numWriteS1k-2k","numWriteS2k-4k","numWriteS4k-8k","numWriteS8k-16k","numWriteS16k-32k","numWriteS32k-64k","numWriteS64k-128k","numWriteS128k-256k","numWriteS256k-512k","numWriteS512k-max","timeWriteS512B-1k","timeWriteS1k-2k","timeWriteS2k-4k","timeWriteS4k-8k","timeWriteS8k-16k","timeWriteS16k-32k","timeWriteS32k-64k","timeWriteS64k-128k","timeWriteS128k-256k","timeWriteS256k-512k","timeWriteS512k-max"
--      USING PARAMETERS op_type = 'write', array_type = 'AFA', time_grain = 'hour') AS perf_sev_write

