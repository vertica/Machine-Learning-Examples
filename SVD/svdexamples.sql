
--APPLY_INVERSE_SVD

SELECT APPLY_INVERSE_SVD (* USING PARAMETERS model_name='svdmodel', exclude_columns='id', 
key_columns='id') OVER () FROM small_svd;


--APPLY_SVD
SELECT APPLY_SVD (id, x1, x2, x3, x4 USING PARAMETERS model_name='svdmodel', exclude_columns='id', 
key_columns='id') OVER () FROM small_svd;

--SVD
SELECT SVD ('svdmodel', 'small_svd', 'x1,x2,x3,x4');
