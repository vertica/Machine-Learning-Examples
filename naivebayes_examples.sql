--Naive Bayes Functions 

--NAIVE_BAYES: 

SELECT NAIVE_BAYES('naive_house84_model', 'house84_train', 'party', '*' USING PARAMETERS exclude_columns='party, id');

--PREDICT_NAIVE_BAYES: 

SELECT party, PREDICT_NAIVE_BAYES (vote1, vote2, vote3 USING PARAMETERS model_name = 'naive_house84_model',
                                    type = 'response') AS Predicted_Party FROM house84_test;

--PREDICT_NAIVE_BAYES_CLASSES: 

 SELECT PREDICT_NAIVE_BAYES_CLASSES (id, vote1, vote2 USING PARAMETERS model_name = 'votes_naive_model',
                                                        key_columns = 'id',
                                                        exclude_columns = 'id',
                                                        classes = 'democrat, republican', 
                                                        match_by_pos = 'false') 
        OVER() FROM house84_test;