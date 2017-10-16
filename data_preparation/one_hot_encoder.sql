SELECT ONE_HOT_ENCODER_FIT('titanic_encoder', 'titanic_training', 'sex, embarkation_point');

SELECT GET_MODEL_SUMMARY(USING PARAMETERS model_name='titanic_encoder');

SELECT * FROM (SELECT GET_MODEL_ATTRIBUTE(USING PARAMETERS model_name='titanic_encoder', attr_name='varchar_categories')) AS attrs
    INNER JOIN (SELECT passenger_id, name, sex, age, embarkation_point FROM titanic_training) AS original_data ON attrs.category_level ILIKE
    original_data.embarkation_point ORDER BY original_data.passenger_id LIMIT 10;

CREATE VIEW titanic_training_encoded AS SELECT passenger_id, survived, pclass, sex_1, age, sibling_and_spouse_count, parent_and_child_count, fare, embarkation_point_1, embarkation_point_2 FROM
    (SELECT APPLY_ONE_HOT_ENCODER(* USING PARAMETERS model_name='titanic_encoder') FROM titanic_training) AS sq;
CREATE VIEW titanic_testing_encoded AS SELECT passenger_id, name, pclass, sex_1, age, sibling_and_spouse_count, parent_and_child_count, fare, embarkation_point_1, embarkation_point_2 FROM
    (SELECT APPLY_ONE_HOT_ENCODER(* USING PARAMETERS model_name='titanic_encoder') FROM titanic_testing) AS sq;

SELECT LOGISTIC_REG('titanic_log_reg', 'titanic_training_encoded', 'survived', '*'
                    USING PARAMETERS exclude_columns='passenger_id, survived');
SELECT passenger_id, name,
    PREDICT_LOGISTIC_REG(pclass, sex_1, age, sibling_and_spouse_count, parent_and_child_count, fare,
                         embarkation_point_1, embarkation_point_2 USING PARAMETERS model_name='titanic_log_reg')
                         FROM titanic_testing_encoded ORDER BY passenger_id LIMIT 10;

DROP VIEW titanic_training_encoded;
DROP VIEW titanic_testing_encoded;
DROP MODEL titanic_encoder;
DROP MODEL titanic_log_reg;

