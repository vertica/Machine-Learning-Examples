--NORMALIZE Functions
--NORMALIZE: 
DROP VIEW mtcars_norm;
SELECT NORMALIZE('mtcars_norm', 'mtcars','wt, hp', 'minmax');
DROP VIEW mtcars_norm;
SELECT NORMALIZE('mtcars_norm', 'mtcars','wt, hp', 'zscore');
DROP VIEW mtcars_norm;
SELECT NORMALIZE('mtcars_norm', 'mtcars','wt, hp', 'robust_zscore'); 

--NORMALIZE_FIT: 
DROP MODEL mtcars_normfit;
SELECT NORMALIZE_FIT('mtcars_normfit', 'mtcars', 'wt,hp', 'minmax');
DROP MODEL mtcars_normfitz;
SELECT NORMALIZE_FIT('mtcars_normfitz', 'mtcars', 'wt,hp', 'zscore');
DROP MODEL mtcars_normfitrz;
SELECT NORMALIZE_FIT('mtcars_normfitrz', 'mtcars', 'wt,hp', 'robust_zscore');

--APPLY_NORMALIZE: 
SELECT APPLY_NORMALIZE (hp, cyl USING PARAMETERS model_name = 'mtcars_normfit') FROM mtcars;

--REVERSE_NORMALIZE:
SELECT REVERSE_NORMALIZE (hp, cyl USING PARAMETERS model_name = 'mtcars_normfit') FROM mtcars;

