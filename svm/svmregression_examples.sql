--SVM Regression Functions

--SVM_REGRESSOR: 
DROP MODEL mySvmRegModel;
SELECT SVM_REGRESSOR('mySvmRegModel', 'faithful', 'eruptions', 'waiting' USING PARAMETERS error_tolerance=0.1, max_iterations=100);

--PREDICT_SVM_REGRESSOR: 

SELECT PREDICT_SVM_REGRESSOR(waiting USING PARAMETERS model_name='mySvmRegModel') FROM faithful ORDER BY id;