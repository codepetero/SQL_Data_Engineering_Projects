/*
Question: What are the most optimal skills for data engineers- balancingboth demand and salary?
-Create a ranking column that combines demand count and median salary to identify the most valuable skills
-Focus only on remote Data Engineeer positions with specified annual salaries
-Why?
-This approacj highlights skills that balance market demand and financila reward.
it weighs core skills appropriately, rather than letting rare, outluer skills distort the results.
*/
SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) As demand_count,
    ROUND((MEDIAN(jpf.salary_year_avg)*LN(COUNT(jpf.*))), 1) As optimal_score

FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id=sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id=sd.skill_id
WHERE  
     jpf.job_title_short='Data Engineer'
     AND jpf.job_work_from_home=True
GROUP BY
       sd.skills
HAVING
        COUNT(jpf.*)>100
ORDER BY
     optimal_score DESC
LIMIT 25;

/* results
┌────────────┬───────────────┬──────────────┬──────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ demand_count │ optimal_score │
│  varchar   │    double     │    int64     │    double    │    double     │
├────────────┼───────────────┼──────────────┼──────────────┼───────────────┤
│ terraform  │      184000.0 │         3248 │          8.1 │     1487786.2 │
│ python     │      135000.0 │        28776 │         10.3 │     1386085.1 │
│ airflow    │      150000.0 │         9996 │          9.2 │     1381491.0 │
│ aws        │      137320.0 │        17823 │          9.8 │     1344124.9 │
│ sql        │      130000.0 │        29221 │         10.3 │     1336743.6 │
│ spark      │      140000.0 │        12799 │          9.5 │     1323997.1 │
│ kafka      │      145000.0 │         6415 │          8.8 │     1271127.2 │
│ kubernetes │      150500.0 │         4202 │          8.3 │     1255669.0 │
│ golang     │      184000.0 │          912 │          6.8 │     1254077.8 │
│ snowflake  │      135500.0 │         8639 │          9.1 │     1228177.7 │
│ azure      │      128000.0 │        14143 │          9.6 │     1223292.8 │
│ scala      │      137290.0 │         6304 │          8.7 │     1201146.2 │
│ java       │      135000.0 │         7267 │          8.9 │     1200298.3 │
│ databricks │      132750.0 │         8183 │          9.0 │     1196052.8 │
│ gcp        │      136000.0 │         6446 │          8.8 │     1192885.2 │
│ pyspark    │      140000.0 │         4898 │          8.5 │     1189521.5 │
│ git        │      140000.0 │         4641 │          8.4 │     1181975.9 │
│ hadoop     │      135000.0 │         5447 │          8.6 │     1161380.7 │
│ rust       │      210000.0 │          232 │          5.4 │     1143814.8 │
│ nosql      │      134415.0 │         4514 │          8.4 │     1131094.0 │
│ docker     │      135000.0 │         4316 │          8.4 │     1129961.4 │
│ redshift   │      130000.0 │         5737 │          8.7 │     1125109.9 │
│ pandas     │      140000.0 │         2929 │          8.0 │     1117538.3 │
│ mongodb    │      135750.0 │         3512 │          8.2 │     1108255.0 │
│ bigquery   │      135000.0 │         3523 │          8.2 │     1102554.2 │
└────────────┴───────────────┴──────────────┴──────────────┴───────────────┘
  25 rows                                                        5 columns
  */