--Kmeans Functions 

--KMEANS: 
DROP MODEL myKmeansModel;
SELECT KMEANS('myKmeansModel', 'iris1', '*', 5
                  USING PARAMETERS max_iterations=20, output_view='myKmeansView', key_columns='id',
                  exclude_columns='Species, id');

--APPLY_KMEANS: 

SELECT id, APPLY_KMEANS(Sepal_Length, 2.2, 1.3, Petal_Width USING PARAMETERS model_name='myKmeansModel', match_by_pos=true) FROM iris2;

SELECT id, APPLY_KMEANS(0,0,0,0 USING PARAMETERS model_name='myKmeansModel', match_by_pos='true') FROM iris ORDER BY id;