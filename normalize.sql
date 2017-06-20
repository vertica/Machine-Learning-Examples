--NORMALIZE Functions

--APPLY_NORMALIZE: 
SELECT APPLY_NORMALIZE (hp, cyl USING PARAMETERS model_name = 'mtcars_normfit') FROM mtcars;

--NORMALIZE_FIT: 
SELECT NORMALIZE_FIT('mtcars_normfit', 'mtcars', 'wt,hp', 'minmax');

SELECT NORMALIZE_FIT('mtcars_normfitz', 'mtcars', 'wt,hp', 'zscore');

SELECT NORMALIZE_FIT('mtcars_normfitrz', 'mtcars', 'wt,hp', 'robust_zscore');

--NORMALIZE: 
SELECT NORMALIZE('mtcars_norm', 'mtcars','wt, hp', 'minmax');

SELECT NORMALIZE('mtcars_norm', 'mtcars','wt, hp', 'zscore');

SELECT NORMALIZE('mtcars_norm', 'mtcars','wt, hp', 'robust_zscore'); 

--REVERSE_NORMALIZE:
SELECT REVERSE_NORMALIZE (hp, cyl USING PARAMETERS model_name = 'mtcars_normfit') FROM mtcars;

