--Logistic Regression Functions 

--LOGISTIC_REG: 
DROP MODEL myLogisticRegModel;
SELECT LOGISTIC_REG('myLogisticRegModel', 'mtcars', 'am','mpg, cyl, disp, hp, drat, wt, qsec, vs, gear, carb'
                        USING PARAMETERS exclude_columns='hp', optimizer='BFGS');

--PREDICT_LOGISTIC_REG:

SELECT car_model,PREDICT_LOGISTIC_REG(mpg, cyl, disp, drat, wt, qsec, vs, gear, carb USING PARAMETERS model_name='myLogisticRegModel')FROM mtcars;