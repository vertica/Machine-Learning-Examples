/*
The script is created using DbVisulizer. It should work in any other SQL editors, just to make sure the comments notation is the same.
*/

-- 11 columns
DROP TABLE if exists diamond;
CREATE TABLE diamond(id int, carat float, cut varchar(10), color varchar(1), clarity varchar(10), 
depthh float, tablee float, price float, x float, y float, z float);

COPY diamond(id, carat, cut, color, clarity, depthh, tablee, price, x, y, z) 
FROM '/home/release/vxu/diamonds.csv' DELIMITER ',' SKIP 1 ENCLOSED BY '"';

Select count(*) from diamond;  --53940
--id int, f1
select count(distinct id) from diamond;  --53940 
--carat float, f2
select count(*) from diamond where carat is NULL OR ABS(carat) = float 'Infinity' OR carat != carat;
--cut varchar(10), f3
Select cut, count(*) from diamond group by cut;
/*
Ideal	21551
Premium	13791
Good	4906
Very Good	12082
Fair	1610
*/

--color varchar(1), f4 
Select color, count(*) from diamond group by color;
/*
Color   Count
E	9797
G	11292
H	8304
F	9542
D	6775
I	5422
J	2808
*/
--clarity varchar(10), f5
Select clarity, count(*) from diamond group by clarity;
/*
I1(worst), SI2, SI1, VS2, VS1, VVS2, VVS1, IF(best)
I1	741
VS2	12258
IF	1790
VS1	8171
VVS1	3655
SI1	13065
SI2	9194
VVS2	5066
*/
--depthh float, f6
select count(*) from diamond where depthh is null;
--tablee float, f7
select count(*) from diamond where tablee is null;
--price float, f8
select count(*) from diamond where price is null;
--x float, f9
select count(*) from diamond where x is null;
--y float, f10
select count(*) from diamond where y is null; 
--z float, f11
select count(*) from diamond where z is null; 
--check distribution of numerical columns

select summarize_numcol(price, carat, x, y, z, depthh, tablee) over() from diamond;
/*
Column  Count   Mean                    StdDev                  Min     25%     Median  75%     Max          
carat	53940	0.797939747868013	0.47401124440542	0.2	0.4	0.7	1.04	5.01
depthh	53940	61.7494048943266	1.43262131883365	43.0	61.0	61.8	62.5	79.0
price	53940	3932.79972191325	3989.4397381464	326.0	945.776729559749	2389.07528957529	5351.875	18823.0
tablee	53940	57.4571839080457	2.23449056282133	43.0	56.0	57.0	59.0	95.0
x	53940	5.7311572117167	1.12176074679249	0.0	4.71	5.7	6.54	10.74
y	53940	5.73452595476456	1.14213467412356	0.0	4.72	5.71	6.54	58.9
z	53940	3.53873377827212	0.705698846949988	0.0	2.91	3.53	4.04	31.8

*/

--Create the sample table. 
drop table if exists diamond_sample;
create table diamond_sample as select 
id,
carat,
log10(carat) as logcarat,
cut,
color,
clarity,
depthh,
tablee,
price,
log10(price) as logprice,
x,
y,
z,
case when random()<0.3 then 'test' else 'train' end as part
from diamond;

--create one-hot encoding
drop model if exists diamond_onehot;
select one_hot_encoder_fit('diamond_onehot', 'diamond_sample', 'cut,color,clarity');

--model stats
SELECT GET_MODEL_SUMMARY(using parameters model_name='diamond_onehot');
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_onehot');
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_onehot', attr_name='varchar_categories');
/*
clarity	I1	0
clarity	IF	1
clarity	SI1	2
clarity	SI2	3
clarity	VS1	4
clarity	VS2	5
clarity	VVS1	6
clarity	VVS2	7
color	D	0
color	E	1
color	F	2
color	G	3
color	H	4
color	I	5
color	J	6
cut	Fair	0
cut	Good	1
cut	Ideal	2
cut	Premium	3
cut	Very Good	4
*/

--Apply the one_hot_encoding
drop table if exists diamond_encoded;                
create table diamond_encoded as (select apply_one_hot_encoder(* using parameters model_name='diamond_onehot', drop_first='true')
       from diamond_sample);

--Normailize the nunerical features
drop view if exists diamond_normalized;
SELECT NORMALIZE('diamond_normalized', 'diamond_encoded', 'carat,logcarat,depthh,tablee,x,y,z', 'robust_zscore');

drop table if exists diamond_normalized_t;
Create table diamond_normalized_t as select * from diamond_normalized;
select summarize_numcol(carat,logcarat,depthh,tablee,x,y,z) over() from diamond_normalized_t;


--Create the tables for training and testing data set
drop table if exists diamond_train;
create table diamond_train as select * from diamond_normalized where part='train';
drop table if exists diamond_test;
create table diamond_test as select * from diamond_normalized where part='test';


-----------------------------------------------------------------------------------------------------------------------------------
--Model 1, Linear Regression with price
---------------------------------------------------------------------------------------------------------------------------------
drop model if exists diamond_linear_price;
SELECT linear_reg('diamond_linear_price', 'diamond_train', 'price', 'carat,
cut_1, cut_2, cut_3, cut_4,
color_1, color_2, color_3, color_4, color_5, color_6,
clarity_1, clarity_2, clarity_3, clarity_4, clarity_5, clarity_6, clarity_7,
depthh, tablee, x, y, z');

--model stats
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_price');
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_price', attr_name='accepted_row_count'); --37700
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_price', attr_name='rejected_row_count'); --0
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_price', attr_name='details');
/*
predictor       coefficient     std_err                 t_value                 p_value      
Intercept	-1326.53241459718	60.2218289956501	-22.0274348474703	7.42699774673366E-107
carat	5278.50904842385	26.938756377737	195.944793234263	0.0
cut_1	603.124226208551	40.0707660955058	15.051477298214	4.75081379797882E-51
cut_2	860.657044491809	39.7597885858415	21.6464190354948	2.79641007516693E-103
cut_3	786.654446408634	38.3483351133892	20.5133924088917	5.26641689239068E-93
cut_4	765.860962720468	38.3543492957936	19.968034311156	2.98868040101326E-88
color_1	-191.316702611951	21.44979508666	-8.91927880145267	4.89911565335019E-19
color_2	-282.400471572411	21.6691589381836	-13.0323688324971	9.71055338743047E-39
color_3	-482.751511664492	21.1957228111559	-22.7758928518544	4.68207272672185E-114
color_4	-967.031178700169	22.506072312744	-42.9675673863622	0.0
color_5	-1438.27778173819	25.3585193982953	-56.7177349413736	0.0
color_6	-2363.94675216243	31.3511745757354	-75.4021750110771	0.0
clarity_1	5343.38022617491	59.8677735031652	89.2530306959287	0.0
clarity_2	3716.04875900883	51.2236581899351	72.5455559075824	0.0
clarity_3	2742.52160882768	51.432337477998	53.3229042915051	0.0
clarity_4	4629.15417164905	52.347488848504	88.4312557006513	0.0
clarity_5	4309.41007939857	51.4615772219575	83.7403420577602	0.0
clarity_6	5046.14777101665	55.4990502499776	90.9231373922239	0.0
clarity_7	4976.86023067932	53.9219276095223	92.2975207177208	0.0
depthh	-62.9156177282894	5.512384119048	-11.4135039158256	4.01187592632454E-30
tablee	-36.3636176825445	5.18579922465155	-7.012153017742	2.38617516188861E-12
x	-1308.39694542989	49.3034584399931	-26.537630154735	9.24030459103336E-154
y	-7.96805735918315	26.5873426549698	-0.299693634771496	0.76441250465736
z	-35.477120923897	29.6746601345889	-1.19553588020861	0.231885237866883
*/

--save results to a table
drop table if exists pred_linear_price;
CREATE TABLE pred_linear_price AS 
(SELECT id, price, PREDICT_LINEAR_REG (carat, cut_1, cut_2, cut_3, cut_4, color_1, color_2, color_3, color_4, color_5, color_6,
                                       clarity_1, clarity_2, clarity_3, clarity_4, clarity_5, clarity_6, clarity_7,
                                       depthh, tablee, x, y, z
                   USING PARAMETERS model_name = 'diamond_linear_price') AS Prediction FROM diamond_test);

select * from pred_linear_price;

select summarize_numcol(Prediction) over() from pred_linear_price;
--Column  Count   Mean                    StdDev                  Min     25%     Median  75%     Max  
--Prediction	16174	3939.75288181181	3790.28402521643	-3812.24962649513	1064.01000864126	2846.67906738537	5931.82489295212	25783.2725190023

select MSE(price, prediction) OVER() FROM pred_linear_price;
--1268641.9733099

select RSQUARED(price, prediction) OVER() FROM pred_linear_price;
--0.919810051437739	

select CORR(price, prediction) FROM pred_linear_price;
--0.959093103572715

-----------------------------------------------------------------------------------------------------------------------------------
--Model 2, Linear Regression with log(price)
---------------------------------------------------------------------------------------------------------------------------------
drop model if exists diamond_linear_logprice;
SELECT linear_reg('diamond_linear_logprice', 'diamond_train', 'logprice', 'carat,
cut_1, cut_2, cut_3, cut_4,
color_1, color_2, color_3, color_4, color_5, color_6,
clarity_1, clarity_2, clarity_3, clarity_4, clarity_5, clarity_6, clarity_7,
depthh, tablee, x, y, z');

--model stats
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice');
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice', attr_name='accepted_row_count'); 
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice', attr_name='rejected_row_count');
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice', attr_name='details');
/*
predictor       coefficient     std_err                 t_value                 p_value      
Intercept	3.09605995347519	0.0042391748548671	730.344951428585	0.0
carat	-0.108275215930776	0.00189629077300428	-57.0984247100648	0.0
cut_1	0.0392902533414456	0.00282068789474327	13.9293161128065	5.40332560619539E-44
cut_2	0.0687272804677808	0.00279879736000887	24.5560044645615	4.07642374185861E-132
cut_3	0.0478147743398782	0.00269944139276206	17.7128403187721	6.41044804523351E-70
cut_4	0.0540316890418292	0.0026998647470714	20.0127391938572	1.23161378450178E-88
color_1	-0.0259894149800782	0.00150990817598697	-17.2125798067753	3.82552409417779E-66
color_2	-0.0392935483568537	0.00152534978144722	-25.7603526973156	4.44905165521915E-145
color_3	-0.0683809590106207	0.00149202335216812	-45.831024635944	0.0
color_4	-0.112015701697924	0.00158426234176475	-70.7052732018782	0.0
color_5	-0.167613557899025	0.00178505368539501	-93.8983288124102	0.0
color_6	-0.228096202957031	0.00220689263591788	-103.356275355082	0.0
clarity_1	0.472101548549524	0.00421425194624741	112.024993894802	0.0
clarity_2	0.265080913983232	0.00360576965851975	73.5157647568796	0.0
clarity_3	0.191917199852026	0.00362045914911546	53.0090775637987	0.0
clarity_4	0.355825950251745	0.00368487909023891	96.5638061759782	0.0
clarity_5	0.32602993074187	0.00362251741252963	90.0009285294785	0.0
clarity_6	0.434507153890342	0.00390672588681597	111.220281759894	0.0
clarity_7	0.406298006507907	0.00379570802581838	107.041427776918	0.0
depthh	0.0234690265849457	3.88031392230297E-4	60.4822884304596	0.0
tablee	0.00595539426464114	3.65042212137397E-4	16.3142619308903	1.25099280291439E-59
x	0.682418169324409	0.00347060168650639	196.628201956345	0.0
y	0.0160246713381662	0.00187155382558748	8.56222841100287	1.14824253133085E-17
z	0.0109391967121386	0.00208887832148643	5.2368759824911	1.64191417357525E-7
*/

--save results to a table
drop table if exists pred_linear_logprice;
CREATE TABLE pred_linear_logprice AS 
(select *, POWER(10, Prediction) AS PredPrice from 
(SELECT id, logprice, PREDICT_LINEAR_REG (carat, cut_1, cut_2, cut_3, cut_4, color_1, color_2, color_3, color_4, color_5, color_6,
                                       clarity_1, clarity_2, clarity_3, clarity_4, clarity_5, clarity_6, clarity_7,
                                       depthh, tablee, x, y, z
                   USING PARAMETERS model_name = 'diamond_linear_logprice') AS Prediction, price FROM diamond_test) pred_table);

select * from pred_linear_logprice;

select summarize_numcol(PredPrice) over() from pred_linear_logprice;
--Column  Count   Mean                    StdDev                  Min     25%     Median  75%     Max  
--PredPrice	16174	3946.89396111059	4210.39802421406	2.60543627789154	993.611399496821	2376.9122244251	5179.39005596189	34659.2070897588

select MSE(price, PredPrice) OVER() FROM pred_linear_logprice;
--1178434.37018554

select RSQUARED(price, PredPrice) OVER() FROM pred_linear_logprice;
--0.925512009284518	

select CORR(price, PredPrice) FROM pred_linear_logprice;
--0.966434031149332


-----------------------------------------------------------------------------------------------------------------------------------
--Model 3, Linear Regression with log(price), and log(carat)
---------------------------------------------------------------------------------------------------------------------------------
drop model if exists diamond_linear_logprice_logcarat;
SELECT linear_reg('diamond_linear_logprice_logcarat', 'diamond_train', 'logprice', 'logcarat,
cut_1, cut_2, cut_3, cut_4,
color_1, color_2, color_3, color_4, color_5, color_6,
clarity_1, clarity_2, clarity_3, clarity_4, clarity_5, clarity_6, clarity_7,
depthh, tablee, x, y, z');

--model stats
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice_logcarat');
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice_logcarat', attr_name='accepted_row_count'); 
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice_logcarat', attr_name='rejected_row_count');
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice_logcarat', attr_name='details');
/*
predictor       coefficient     std_err                 t_value                 p_value      
Intercept	3.11826509829559	0.00306207948319281	1018.34884280802	0.0
logcarat	0.56435354066327	0.00280766224053194	201.004783451569	0.0
cut_1	0.036876685099836	0.00204313497940334	18.0490694308435	1.62089560343134E-72
cut_2	0.0724658691546716	0.00202727381963588	35.7454767347053	3.09960779667786E-275
cut_3	0.0615242003376133	0.00195672167014164	31.4424893823349	3.12480062610267E-214
cut_4	0.0530374411863451	0.0019551311011288	27.1273067855776	1.63447337435939E-160
color_1	-0.024171107687049	0.00109375675570965	-22.0991619579679	1.55199330493489E-107
color_2	-0.0419637064720779	0.00110492480996285	-37.9787892295483	9.0432099442911E-310
color_3	-0.0705867411825717	0.00108081625228873	-65.3087340545608	0.0
color_4	-0.109487387054762	0.00114710515343032	-95.4466874526278	0.0
color_5	-0.162529190526099	0.00129086867047875	-125.906836414134	0.0
color_6	-0.222526125121231	0.00159450120772989	-139.558455046919	0.0
clarity_1	0.480289934573659	0.00305198952966276	157.369456843035	0.0
clarity_2	0.257059965340001	0.00260748831151864	98.5852800200225	0.0
clarity_3	0.184259114461504	0.00262061518552042	70.311396911528	0.0
clarity_4	0.3516408492282	0.00266577225312835	131.909561597222	0.0
clarity_5	0.320964988658119	0.00262091194506577	122.463095054521	0.0
clarity_6	0.440109683805514	0.00282904724097464	155.568163525573	0.0
clarity_7	0.409988252951317	0.00274760386174347	149.216653339235	0.0
depthh	7.90972822739655E-4	2.89063791284383E-4	2.73632619023353	0.00621584574986681
tablee	2.92237864502731E-4	2.65329168769566E-4	1.1014162741999	0.270722549661425
x	0.0255322876921813	0.00328662985696781	7.76853153635528	8.14025419627419E-15
y	-8.44454139081519E-4	0.0013563995361514	-0.622570353774628	0.533570659311895
z	0.00213381908060128	0.00151371673695231	1.40965547153656	0.158649678812544
*/

--save results to a table
drop table if exists pred_linear_logprice_logcarat;
CREATE TABLE pred_linear_logprice_logcarat AS 
(select *, POWER(10, Prediction) AS PredPrice from 
(SELECT id, logprice, PREDICT_LINEAR_REG (logcarat, cut_1, cut_2, cut_3, cut_4, color_1, color_2, color_3, color_4, color_5, color_6,
                                       clarity_1, clarity_2, clarity_3, clarity_4, clarity_5, clarity_6, clarity_7,
                                       depthh, tablee, x, y, z
                   USING PARAMETERS model_name = 'diamond_linear_logprice_logcarat') AS Prediction, price, logcarat FROM diamond_test) pred_table);

select * from pred_linear_logprice_logcarat;

select summarize_numcol(PredPrice) over() from pred_linear_logprice_logcarat;
--Column  Count   Mean                    StdDev                  Min     25%     Median  75%     Max      
--PredPrice	16174	3903.63753430587	3915.02967407529	284.394949029235	977.965044801579	2498.12656424235	5292.51168174105	27572.5296149607

select MSE(price, PredPrice) OVER() FROM pred_linear_logprice_logcarat;
--660891.356190454	

select RSQUARED(price, PredPrice) OVER() FROM pred_linear_logprice_logcarat;
--0.958225531731474	

select CORR(price, PredPrice) FROM pred_linear_logprice_logcarat;
--0.978983096422647



-----------------------------------------------------------------------------------------------------------------------------------
--Model 4, Linear Regression with L1, log(price), and log(carat)
---------------------------------------------------------------------------------------------------------------------------------
drop model if exists diamond_linear_logprice_logcarat_l1;
SELECT linear_reg('diamond_linear_logprice_logcarat_l1', 'diamond_train', 'logprice', 'logcarat,
cut_1, cut_2, cut_3, cut_4,
color_1, color_2, color_3, color_4, color_5, color_6,
clarity_1, clarity_2, clarity_3, clarity_4, clarity_5, clarity_6, clarity_7,
depthh, tablee, x, y, z'
using parameters regularization='L1', lambda=0.005);

--model stats
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice_logcarat_l1');
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice_logcarat_l1', attr_name='accepted_row_count'); 
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice_logcarat_l1', attr_name='rejected_row_count');
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice_logcarat_l1', attr_name='details');
/*
predictor       coefficient     std_err                 t_value                 p_value      
Intercept	3.43857656285387	0.00498754013172191	689.433362347046	0.0
logcarat	0.528798247012727	0.00457314324394084	115.631245033349	0.0
cut_1	0.0	0.00332787498176687	0.0	1.0
cut_2	0.00477674220074279	0.00330204019488101	1.44660328730945	0.14801636959356
cut_3	0.0	0.00318712427616852	0.0	1.0
cut_4	0.0	0.00318453354433828	0.0	1.0
color_1	0.0	0.0017815199583767	0.0	1.0
color_2	0.0	0.00179971057657811	0.0	1.0
color_3	0.0	0.00176044236045975	0.0	1.0
color_4	-0.00678915328470227	0.00186841426535187	-3.63364453515543	2.79816387073678E-4
color_5	-0.0331219677212305	0.00210257745892414	-15.7530309195737	9.85883004334992E-56
color_6	-0.0421943209033071	0.00259713662146344	-16.2464771990052	3.75807076113247E-59
clarity_1	0.0	0.00497110553280488	0.0	1.0
clarity_2	-0.0434274481661565	0.00424709830952357	-10.2252043633593	1.6459235163326E-24
clarity_3	-0.087257611449152	0.00426847946936848	-20.4423172409124	2.22922666930413E-92
clarity_4	0.0	0.00434203167079292	0.0	1.0
clarity_5	0.0	0.00426896283374555	0.0	1.0
clarity_6	0.00987223637444222	0.00460797530774275	2.14242388796093	0.0321657652588609
clarity_7	0.0143908209227927	0.00447531966486735	3.21559620327574	0.00130283433015808
depthh	-0.00621228650298316	4.70829469833119E-4	-13.19434508886	1.15793517979109E-39
tablee	-0.00477745658511014	4.32170322363672E-4	-11.0545688537352	2.3031915687514E-28
x	0.00394667456052415	0.00535328961893901	0.737242862138729	0.460979255223334
y	0.0058478491277301	0.00220931466943836	2.64690639528352	0.00812655552034063
z	0.0	0.00246555421407179	0.0	1.0
*/

--save results to a table
drop table if exists pred_linear_logprice_logcarat_l1;
CREATE TABLE pred_linear_logprice_logcarat_l1 AS 
(select *, POWER(10, Prediction) AS PredPrice from 
(SELECT id, logprice, PREDICT_LINEAR_REG (logcarat, cut_1, cut_2, cut_3, cut_4, color_1, color_2, color_3, color_4, color_5, color_6,
                                       clarity_1, clarity_2, clarity_3, clarity_4, clarity_5, clarity_6, clarity_7,
                                       depthh, tablee, x, y, z
                   USING PARAMETERS model_name = 'diamond_linear_logprice_logcarat_l1') AS Prediction, price, logcarat FROM diamond_test) pred_table);

select * from pred_linear_logprice_logcarat_l1;

select summarize_numcol(PredPrice) over() from pred_linear_logprice_logcarat_l1;
--Column  Count   Mean                    StdDev                  Min     25%     Median  75%     Max      
--PredPrice	16174	3894.1288885899	3895.96407220252	285.025864363303	977.872791539021	2510.97857533346	5291.92371262391	29912.9203169755

select MSE(price, PredPrice) OVER() FROM pred_linear_logprice_logcarat_l1;
--694735.037782806	

select RSQUARED(price, PredPrice) OVER() FROM pred_linear_logprice_logcarat_l1;
--0.9560862969094	

select CORR(price, PredPrice) FROM pred_linear_logprice_logcarat_l1;
--0.97791019391229

--Generate the residual 