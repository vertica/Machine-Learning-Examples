--Evaluation Functions 

--CONFUSION_MATRIX: 

SELECT CONFUSION_MATRIX(obs::int, pred::int USING PARAMETERS num_classes=2) OVER()
	FROM (SELECT am AS obs, PREDICT_LOGISTIC_REG(mpg, cyl, disp,drat, wt, qsec, vs, gear, carb
             USING PARAMETERS model_name='myLogisticRegModel')AS PRED
             FROM mtcars) AS prediction_output;
	     
--CROSS_VALIDATE: 
SELECT CROSS_VALIDATE('svm_classifier', 'mtcars', 'am', 'mpg' USING PARAMETERS 
cv_fold_count= 6, cv_hyperparams='{"C":[1,5]}', cv_model_name='cv_svm', 
cv_metrics='accuracy,error_rate');

SELECT GET_MODEL_ATTRIBUTE(USING PARAMETERS attr_name='run_details', 
model_name='cv_svm');	     

--GET_MODEL_ATTRIBUTE: 

SELECT GET_MODEL_ATTRIBUTE (USING PARAMETERS model_name='myLinearRegModel');

SELECT GET_MODEL_ATTRIBUTE (USING PARAMETERS model_name='myLinearRegModel', attr_name='details');

--ERROR_RATE: 

SELECT ERROR_RATE(obs::int, pred::int USING PARAMETERS num_classes=2) OVER() 
	FROM (SELECT am AS obs, PREDICT_LOGISTIC_REG (mpg, cyl, disp, drat, wt, qsec, vs, gear, carb
                USING PARAMETERS model_name='myLogisticRegModel', type='response') AS pred
             FROM mtcars) AS prediction_output; 
	     
--GET_MODEL_SUMMARY:

SELECT GET_MODEL_SUMMARY(USING PARAMETERS model_name='myLinearRegModel');

--LIFT_TABLE: 

SELECT LIFT_TABLE(obs::int, prob::float USING PARAMETERS num_bins=2) OVER() 
	FROM (SELECT am AS obs, PREDICT_LOGISTIC_REG(mpg, cyl, disp, drat, wt, qsec, vs, gear, carb
                                                    USING PARAMETERS model_name='myLogisticRegModel',
                                                    type='probability') AS prob
             FROM mtcars) AS prediction_output;

--MSE: 

SELECT MSE(obs, prediction) OVER()
   FROM (SELECT eruptions AS obs,
                PREDICT_LINEAR_REG (waiting USING PARAMETERS model_name='myLinearRegModel') AS prediction
         FROM faithful_testing) AS prediction_output;
	 
--ROC: 

SELECT ROC(obs::int, prob::float USING PARAMETERS num_bins=2) OVER() 
	FROM (SELECT am AS obs,
                    PREDICT_LOGISTIC_REG (mpg, cyl, disp, drat, wt,
                                          qsec, vs, gear, carb
                                          USING PARAMETERS model_name='myLogisticRegModel',
                                                           type='probability') AS prob
             FROM mtcars) AS prediction_output;


--RSQUARED: 

SELECT RSQUARED(obs, prediction) OVER()
     FROM (SELECT eruptions AS obs,
                  PREDICT_LINEAR_REG (waiting
                                       USING PARAMETERS model_name='myLinearRegModel') AS prediction
           FROM faithful_testing) AS prediction_output;
	   
--SUMMARIZE_CATCOL
SELECT SUMMARIZE_CATCOL (current_salary USING PARAMETERS TOPK = 5) OVER() FROM salary_data;
	   
--SUMMARIZE_NUMCOL
SELECT SUMMARIZE_NUMCOL(years_worked, current_salary) OVER() FROM salary_data;
