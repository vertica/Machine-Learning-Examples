--Evaluation Functions 

--CONFUSION_MATRIX: 

SELECT CONFUSION_MATRIX(obs, pred USING PARAMETERS num_classes=2) OVER()
	FROM (SELECT am AS obs, PREDICT_LOGISTIC_REG(mpg, cyl, disp, hp, drat, wt, qsec, vs, gear, carb
             USING PARAMETERS model_name='mtcars_log', owner='dbadmin')::INT AS pred
             FROM mtcars) AS prediction_output;

--GET_MODEL_ATTRIBUTE: 

SELECT GET_MODEL_ATTRIBUTE (USING PARAMETERS model_name='myLinearRegModel');

SELECT GET_MODEL_ATTRIBUTE (USING PARAMETERS model_name='myLinearRegModel', attr_name='data');

--ERROR_RATE: 

SELECT ERROR_RATE(obs, pred::int USING PARAMETERS num_classes=2) OVER() 
	FROM (SELECT am AS obs, PREDICT_LOGISTIC_REG (mpg, cyl, disp, hp, drat, wt, qsec, vs, gear, carb
                USING PARAMETERS model_name='logisticRegModel', owner='dbadmin', type='response') AS pred
             FROM mtcars) AS prediction_output;

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