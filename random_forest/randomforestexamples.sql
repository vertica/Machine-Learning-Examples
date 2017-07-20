-Random Forest Functions 

--RF_CLASSIFIER: 

SELECT RF_CLASSIFIER ('myRFModel', 'iris', 'Species', 'Sepal_Length, Sepal_Width, Petal_Length, Petal_Width' 
USING PARAMETERS ntree=100, sampling_size=0.3);

--PREDICT_RF_CLASSIFIER: 

SELECT PREDICT_RF_CLASSIFIER (Sepal_Length, Sepal_Width, Petal_Length, Petal_Width
                                  USING PARAMETERS model_name='myRFModel') FROM iris;

--PREDICT_RF_CLASSIFIER_CLASSES: 
SELECT PREDICT_RF_CLASSIFIER_CLASSES(Sepal_Length, Sepal_Width, Petal_Length, Petal_Width
                               USING PARAMETERS model_name='myRFModel') OVER () FROM iris;

SELECT PREDICT_RF_CLASSIFIER_CLASSES(Sepal_Length, Sepal_Width, Petal_Length, Petal_Wdith
                          USING PARAMETERS model_name='myRFModel', match_by_pos='true') OVER () FROM iris;