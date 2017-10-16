--Evaluation Functions 

--APPLY_ONE_HOT_ENCODER: 

SELECT APPLY_ONE_HOT_ENCODER(cyl USING PARAMETERS model_name='one_hot_encoder_model', 
drop_first='true', ignore_null='false') FROM mtcars;

--CONFUSION_MATRIX: 

SELECT CONFUSION_MATRIX(obs, pred USING PARAMETERS num_classes=2) OVER()
	FROM (SELECT am AS obs, PREDICT_LOGISTIC_REG(mpg, cyl, disp, hp, drat, wt, qsec, vs, gear, carb
             USING PARAMETERS model_name='mtcars_log', owner='dbadmin')::INT AS pred
             FROM mtcars) AS prediction_output;
	     
--CROSS_VALIDATE: 
SELECT CROSS_VALIDATE('svm_classifier', 'mtcars', 'am', 'mpg' USING PARAMETERS 
cv_fold_count= 6, cv_hyperparams='{"C":[1,5]}', cv_model_name='cv_svm', 
cv_metrics='accuracy,error_rate');

SELECT GET_MODEL_ATTRIBUTE(USING PARAMETERS attr_name='details', 
model_name='cv_svm');	     

--GET_MODEL_ATTRIBUTE: 

SELECT GET_MODEL_ATTRIBUTE (USING PARAMETERS model_name='myLinearRegModel');

SELECT GET_MODEL_ATTRIBUTE (USING PARAMETERS model_name='myLinearRegModel', attr_name='data');

--ERROR_RATE: 

SELECT ERROR_RATE(obs, pred::int USING PARAMETERS num_classes=2) OVER() 
	FROM (SELECT am AS obs, PREDICT_LOGISTIC_REG (mpg, cyl, disp, hp, drat, wt, qsec, vs, gear, carb
                USING PARAMETERS model_name='logisticRegModel', owner='dbadmin', type='response') AS pred
             FROM mtcars) AS prediction_output;
	     
--GET_MODEL_SUMMARY:

SELECT GET_MODEL_SUMMARY(USING PARAMETERS model_name='linear_reg_faithful');

--LIFT_TABLE: 

SELECT LIFT_TABLE(obs, prob USING PARAMETERS num_bins=2) OVER() 
	FROM (SELECT am AS obs, PREDICT_LOGISTIC_REG(mpg, cyl, disp, hp, drat, wt, qsec, vs, gear, carb
                                                    USING PARAMETERS model_name='logisticRegModel',
                                                    owner='dbadmin', type='probability') AS prob FROM mtcars) AS prediction_output;

--MSE: 

SELECT MSE(obs, prediction) OVER()
   FROM (SELECT eruptions AS obs,
                PREDICT_LINEAR_REG (waiting USING PARAMETERS model_name='linearRegModel') AS prediction
         FROM faithful_testing) AS prediction_output;
	 
--ONE_HOT_ENCODER_FIT:

SELECT ONE_HOT_ENCODER_FIT ('one_hot_encoder_model','mtcars','*' 
USING PARAMETERS exclude_columns='mpg,disp,drat,wt,qsec,vs,am');

--ROC: 

SELECT ROC(obs, prob USING PARAMETERS num_bins=2) OVER() 
	FROM (SELECT am AS obs,
                    PREDICT_LOGISTIC_REG (mpg, cyl, disp, hp, drat, wt,
                                          qsec, vs, gear, carb
                                          USING PARAMETERS model_name='logisticRegModel',
                                                           owner='dbadmin',
                                                           type='probability') AS prob
             FROM mtcars) AS prediction_output;

--RSQUARED: 

SELECT RSQUARED(obs, prediction) OVER()
     FROM (SELECT eruptions AS obs,
                  PREDICT_LINEAR_REG (waiting
                                       USING PARAMETERS model_name='linear_reg_faithful') AS prediction
           FROM faithful_testing) AS prediction_output;

--SUMMARIZE_MODEL: 

SELECT SUMMARIZE_MODEL('linear_reg_faithful');
