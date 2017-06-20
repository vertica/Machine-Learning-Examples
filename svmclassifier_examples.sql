--SVM Classification Functions 

--SVM_CLASSIFIER: 

SELECT SVM_CLASSIFIER('mySvmClassModel', 'mtcars', 'am', 'mpg,cyl,disp,hp,drat,wt,qsec,vs,gear,carb'
                          USING PARAMETERS exclude_columns = 'hp,drat');

--PREDICT_SVM_CLASSIFIER: 

SELECT PREDICT_SVM_CLASSIFIER (mpg,cyl,disp,wt,qsec,vs,gear,carb USING PARAMETERS model_name='mySvmClassModel') FROM mtcars;