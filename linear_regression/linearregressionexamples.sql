--Linear Regression Functions 

--LINEAR_REG: 
DROP MODEL myLinearRegModel;
SELECT LINEAR_REG('myLinearRegModel', 'faithful', 'eruptions', 'waiting' USING PARAMETERS optimizer='BFGS');

--PREDICT_LINEAR_REG: 
SELECT PREDICT_LINEAR_REG(waiting USING PARAMETERS model_name='myLinearRegModel')FROM faithful ORDER BY id;
