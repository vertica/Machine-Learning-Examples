--Data Preparation Functions 

--BALANCE: 

CREATE TABLE backyard_bugs (id identity, bug_type int, finder varchar(20));

COPY backyard_bugs FROM STDIN;
1|Ants
1|Beetles
3|Ladybugs
3|Ants
3|Beetles
3|Caterpillars
2|Ladybugs
3|Ants
3|Beetles
1|Ladybugs
3|Ladybugs
\.

SELECT bug_type, COUNT(bug_type) FROM backyard_bugs GROUP BY bug_type;

SELECT BALANCE('backyard_bugs_balanced', 'backyard_bugs', 'bug_type', 'under_sampling');

SELECT bug_type, COUNT(bug_type) FROM backyard_bugs_balanced GROUP BY bug_type;

--DETECT_OUTLIERS: 

CREATE TABLE baseball_roster (id identity, last_name varchar(30), hr int, avg float);

COPY baseball_roster FROM STDIN;
Polo|7|.233
Gloss|45|.170
Gus|12|.345
Gee|1|.125
Laus|3|.095
Hilltop|16|.222
Wicker|78|.333
Scooter|0|.121
Hank|999999|.8888
Popup|35|.378
\.

SELECT * FROM baseball_roster;

SELECT DETECT_OUTLIERS('baseball_outliers', 'baseball_roster', 'id, hr, avg', 'robust_zscore' USING PARAMETERS
outlier_threshold=3.0);

SELECT * FROM baseball_outliers;

--IMPUTE: 

SELECT impute('output_view','small_input_impute', 'pid, x1,x2,x3,x4','mean' USING PARAMETERS exclude_columns='pid');

SELECT impute('output_view3','small_input_impute', 'pid, x5,x6','mode' USING PARAMETERS exclude_columns='pid');
