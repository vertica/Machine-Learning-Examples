--Linear Regression Functions 

--LINEAR_REG: 

SELECT LINEAR_REG('myLinearRegModel', 'faithful', 'eruptions', 'waiting' USING PARAMETERS optimizer='BFGS');

--PREDICT_LINEAR_REG: 
SELECT PREDICT_LINEAR_REG(waiting USING PARAMETERS model_name='linear_reg_faithful')FROM faithful ORDER BY id;
