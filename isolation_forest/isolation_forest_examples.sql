#Originally published by George Larionov here : https://www.vertica.com/blog/detect-outliers-using-isolation-forest/
#Dataset : https://archive.ics.uci.edu/ml/machine-learning-databases/kddcup99-mld/kddcup.data.gz

#Create Table
CREATE TABLE web_traffic_train(duration int, protocol_type VARCHAR, service VARCHAR, flag VARCHAR,
                               src_bytes INT, dst_bytes INT, land BOOL, wrong_fragment INT, urgent INT,
                               hot INT, num_failed_logins INT, logged_in BOOL, num_compromised INT, root_shell INT,
                               su_attempted INT, num_root INT, num_file_creations INT, num_shells INT, num_access_files INT,
                               num_outbound_cmds INT, is_host_login BOOL, is_guest_login BOOL, count INT, srv_count INT,
                               serror_rate FLOAT, srv_serror_rate FLOAT, rerror_rate FLOAT, srv_rerror_rate FLOAT,
                               same_srv_rate FLOAT, diff_srv_rate FLOAT, srv_diff_host_rate FLOAT, dst_host_count INT,
                               dst_host_srv_count INT, dst_host_same_srv_rate FLOAT, dst_host_diff_srv_rate FLOAT,
                               dst_host_same_src_port_rate FLOAT, dst_host_srv_diff_host_rate FLOAT,
                               dst_host_serror_rate FLOAT, dst_host_srv_serror_rate FLOAT, dst_host_rerror_rate FLOAT,
                               dst_host_srv_rerror_rate FLOAT, label VARCHAR);

#Load Data
COPY web_traffic_train FROM LOCAL 'path_to_data/kddcup.data.gz' GZIP DELIMITER ',';

#Use subset of data
CREATE VIEW web_traffic_http AS SELECT * FROM web_traffic_train WHERE service='http';

#Train
SELECT iforest('iforest_example', 'web_traffic_http', '*' USING PARAMETERS exclude_columns='label');

#create a vsql variable ‘columns’ that stores the string of column names
\set columns 'duration, protocol_type, service, flag, src_bytes, dst_bytes, land, wrong_fragment, urgent, hot, num_failed_logins, logged_in, num_compromised, root_shell, su_attempted, num_root, num_file_creations, num_shells, num_access_files, num_outbound_cmds, is_host_login, is_guest_login, count, srv_count, serror_rate, srv_serror_rate, rerror_rate, srv_rerror_rate, same_srv_rate, diff_srv_rate, srv_diff_host_rate, dst_host_count, dst_host_srv_count, dst_host_same_srv_rate, dst_host_diff_srv_rate, dst_host_same_src_port_rate, dst_host_srv_diff_host_rate, dst_host_serror_rate, dst_host_srv_serror_rate, dst_host_rerror_rate, dst_host_srv_rerror_rate'

#apply the model 
SELECT apply_iforest(:columns USING PARAMETERS model_name='iforest_example') from web_traffic_http LIMIT 5; 

#examine the results
WITH prediction_result AS (SELECT apply_iforest(:columns USING PARAMETERS model_name='iforest_example', threshold=0.52) AS pred, label!='normal.' AS obs
                              FROM web_traffic_http)
   SELECT confusion_matrix(obs, pred.is_anomaly USING PARAMETERS num_classes=2) OVER() FROM prediction_result;
