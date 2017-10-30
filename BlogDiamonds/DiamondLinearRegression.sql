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
select summarize_numcol(carat,depthh,tablee,price,x,y,z) over() from diamond;
/*
Column  Count   Mean                    StdDev                  Min     25%     Median  75%     Max          
carat	53940	0.797939747868013	0.47401124440542	0.2	0.4	0.7	1.04	5.01
depthh	53940	61.7494048943266	1.43262131883365	43.0	61.0	61.8	62.5	79.0
price	53940	3932.79972191325	3989.4397381464	        326.0	945.8	2389.1	5333.5	18823.0
tablee	53940	57.4571839080457	2.23449056282133	43.0	56.0	57.0	59.0	95.0
x	53940	5.7311572117167	        1.12176074679249	0.0	4.71	5.7	6.54	10.74
y	53940	5.73452595476456	1.14213467412356	0.0	4.72	5.71	6.54	58.9
z	53940	3.53873377827212	0.705698846949988	0.0	2.91	3.53	4.04	31.8

*/

drop table if exists diamond_sample;
create table diamond_sample as select 
id,
carat,
power(carat, 1/5) as pcarat,
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

drop view if exists diamond_train;
create view diamond_train as select * from diamond_encoded where part='train';
drop view if exists diamond_test;
create view diamond_test as select * from diamond_encoded where part='test';


-----------------------------------------------------------------------------------------------------------------------------------
--Linear Regression with price
---------------------------------------------------------------------------------------------------------------------------------
drop model if exists diamond_linear_price;
SELECT linear_reg('diamond_linear_price', 'diamond_train', 'price', 'carat,
cut_1, cut_2, cut_3, cut_4,
color_1, color_2, color_3, color_4, color_5, color_6,
clarity_1, clarity_2, clarity_3, clarity_4, clarity_5, clarity_6, clarity_7,
depthh, tablee, x, y, z');

--model stats
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_price');
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_price', attr_name='accepted_row_count'); 
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_price', attr_name='rejected_row_count');
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_price', attr_name='details');
/*
predictor       coefficient     std_err                 t_value                 p_value      
Intercept	849.629805460572	532.799525562152	1.5946519557504	0.110798466749095
carat	11186.2202560655	57.3937889050186	194.902975905243	0.0
cut_1	589.986108077551	39.7544235774223	14.8407662590943	1.10302672676201E-49
cut_2	873.011274258506	39.5928770068076	22.0497054080814	4.57542816796691E-107
cut_3	790.992267364603	38.1491560234816	20.7342009578857	5.77606358700111E-95
cut_4	749.773113318106	38.2045465309435	19.6252326332635	2.51286045912128E-85
color_1	-221.439939059652	21.4393218379963	-10.3286820699338	5.64414075241455E-25
color_2	-271.505913599764	21.6065900346115	-12.5658844438127	3.84288549759258E-36
color_3	-482.847379146706	21.2201297802856	-22.7542142364884	7.63548325339103E-114
color_4	-979.897799550243	22.5871264083659	-43.3830218963713	0.0
color_5	-1468.24091445729	25.3371988017813	-57.9480362428253	0.0
color_6	-2355.35696339532	31.4065925607575	-74.9956226177282	0.0
clarity_1	5274.64265030774	60.4966108938347	87.1890602196575	0.0
clarity_2	3654.62119505951	51.3793224491341	71.1301944216491	0.0
clarity_3	2684.19447962541	51.6053017424428	52.0139285886162	0.0
clarity_4	4559.25625558917	52.5126571693252	86.8220444623095	0.0
clarity_5	4256.62303486792	51.6647080136626	82.3893756206321	0.0
clarity_6	4994.23344358968	55.6821232814207	89.6918642694089	0.0
clarity_7	4939.54376885199	54.0494912783006	91.3892740158884	0.0
depthh	-46.8220622055233	6.47519643475679	-7.23098714877549	4.88592173412906E-13
tablee	-23.6019051065384	3.49187135175932	-6.75909927055218	1.4086954885486E-11
x	-874.265145237325	49.5378813642146	-17.6484161445968	1.99194742589774E-69
y	28.5816630825575	20.1569719798551	1.41795420022026	0.156212398882399
z	-251.470118663739	73.3267221080152	-3.42944715697651	6.05458951945689E-4
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
--Prediction	16202	3921.35752242715	3830.6247649371	-4868.22783997425	1065.07967826221	2776.8546032615	5892.02988889398	30605.3179714267

select MSE(price, prediction) OVER() FROM pred_linear_price;
--1278446.6900854

select RSQUARED(price, prediction) OVER() FROM pred_linear_price;
--0.919913974869682	

select CORR(price, prediction) FROM pred_linear_price;
--0.959121770019172

-----------------------------------------------------------------------------------------------------------------------------------
--Linear Regression with log(price)
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
Intercept	-1.10665718484688	0.0368287913758221	-30.0486967805681	4.69390936597707E-196
carat	-0.24249456742244	0.00396724054065628	-61.1242411286526	0.0
cut_1	0.0382988550853431	0.00274795171909247	13.9372372590271	4.83962963663018E-44
cut_2	0.0667953237846851	0.0027367851082729	24.4064919758488	1.5080128689431E-130
cut_3	0.0476418518973176	0.00263699053949277	18.0667511634234	1.18054362524503E-72
cut_4	0.0522416937710499	0.00264081930687267	19.7823810342087	1.16332536071246E-86
color_1	-0.0247450298574412	0.00148195385568006	-16.6975710900835	2.28797086126365E-62
color_2	-0.0390492844001231	0.00149351596341741	-26.1458768145818	2.36463166806028E-149
color_3	-0.0677236164354904	0.00146680260614366	-46.1709136265727	0.0
color_4	-0.111547570811283	0.00156129374438922	-71.4456015801954	0.0
color_5	-0.166445788827922	0.00175138746179396	-95.0365310126356	0.0
color_6	-0.22691552273499	0.00217092318921676	-104.524896994103	0.0
clarity_1	0.470468858460933	0.00418171742777817	112.50613332592	0.0
clarity_2	0.262461085936856	0.00355150156245984	73.901441776382	0.0
clarity_3	0.189107646298943	0.00356712196722606	53.0140679338758	0.0
clarity_4	0.35376499530377	0.00362984124927711	97.4601837957026	0.0
clarity_5	0.323965736740071	0.00357122831692084	90.7154928194003	0.0
clarity_6	0.433486365040373	0.00384892478936105	112.625314539424	0.0
clarity_7	0.404826273941644	0.00373607209233019	108.356119458378	0.0
depthh	0.0192094381838501	4.47586094153459E-4	42.9178619147716	0.0
tablee	0.0038006976294519	2.41369211786586E-4	15.7464061025828	1.09434589404785E-55
x	0.479818650145035	0.00342421532008546	140.125139716114	0.0
y	0.00181925063174049	0.00139331377037478	1.30570060414398	0.191662356943799
z	0.0645753666635756	0.00506857536695652	12.7403386530583	4.20884914114955E-37
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
--PredPrice	16202	3945.51770243427	4350.69934600789	1.81514453424419	959.355191138727	2310.10251804976	5146.00317845892	116281.593460037

select MSE(price, PredPrice) OVER() FROM pred_linear_logprice;
--1962046.28571317

select RSQUARED(price, PredPrice) OVER() FROM pred_linear_logprice;
--0.877091090803344	

select CORR(price, PredPrice) FROM pred_linear_logprice;
--0.947203403411035


-----------------------------------------------------------------------------------------------------------------------------------
--Linear Regression with log(price), and log(carat)
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
Intercept	3.2046673079285	0.0324200761236867	98.8482351399268	0.0
logcarat	1.77332046147251	0.00918064347270932	193.15862409252	0.0
cut_1	0.0342614255322045	0.00204238056241494	16.7752406983805	6.26732630835686E-63
cut_2	0.0689069037117638	0.00203407708686241	33.8762499006631	7.87341944412491E-248
cut_3	0.0584946693655723	0.00196100326030814	29.8289505935757	2.92085076802485E-193
cut_4	0.049060450094343	0.00196230330066077	25.00146133262	7.70019367282684E-137
color_1	-0.0228961179006193	0.00110157603046526	-20.7848730068581	2.03658954100074E-95
color_2	-0.0404234991302397	0.0011100580296125	-36.4156630120955	2.16640658377611E-285
color_3	-0.0691723850121368	0.00109029704945689	-63.4436138725621	0.0
color_4	-0.109283806382857	0.00115991754131635	-94.2168753296326	0.0
color_5	-0.161381001428347	0.00129981060029071	-124.157320606751	0.0
color_6	-0.221457978121034	0.00160988574581455	-137.561301289107	0.0
clarity_1	0.480420995356283	0.00310795258875432	154.57796785402	0.0
clarity_2	0.25680791481259	0.00263560984867956	97.43775807381	0.0
clarity_3	0.184733285279307	0.00264951836442445	69.7233458577807	0.0
clarity_4	0.352150291213206	0.00269472163031943	130.681509826847	0.0
clarity_5	0.321483660072495	0.00265144353695715	121.248540876505	0.0
clarity_6	0.440250213764685	0.00286026008712073	153.919643792905	0.0
clarity_7	0.409976952601454	0.00277531363708313	147.722746403661	0.0
depthh	6.72546110052963E-4	3.37875677519287E-4	1.99051353737817	0.0465415994897193
tablee	8.81925849154364E-5	1.80120132392009E-4	0.489632023606867	0.624397159355924
x	0.0244700029321621	0.00295863946415755	8.27069442850473	1.37495215050303E-16
y	-7.4098291074165E-4	0.00103561059245019	-0.715503410397273	0.474302463779537
z	0.00234320208392091	0.00377509634683834	0.620699942104354	0.534800818384606
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
--PredPrice	16202	3897.3366615195	3988.14782835374	232.452267035354	952.340387260536	2428.74074106442	5253.57176161772	32354.2008497385

select MSE(price, PredPrice) OVER() FROM pred_linear_logprice_logcarat;
--690261.988588932	

select RSQUARED(price, PredPrice) OVER() FROM pred_linear_logprice_logcarat;
--0.956759762144682	

select CORR(price, PredPrice) FROM pred_linear_logprice_logcarat;
--0.978363784710021



-----------------------------------------------------------------------------------------------------------------------------------
--Linear Regression with L1, log(price), and log(carat)
---------------------------------------------------------------------------------------------------------------------------------
drop model if exists diamond_linear_logprice_logcarat_l1;
SELECT linear_reg('diamond_linear_logprice_logcarat_l1', 'diamond_train', 'logprice', 'logcarat,
cut_1, cut_2, cut_3, cut_4,
color_1, color_2, color_3, color_4, color_5, color_6,
clarity_1, clarity_2, clarity_3, clarity_4, clarity_5, clarity_6, clarity_7,
depthh, tablee, x, y, z'
using parameters regularization='L1', lambda=0.0001);

--model stats
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice_logcarat_l1');
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice_logcarat_l1', attr_name='accepted_row_count'); 
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice_logcarat_l1', attr_name='rejected_row_count');
SELECT GET_MODEL_ATTRIBUTE(using parameters model_name='diamond_linear_logprice_logcarat_l1', attr_name='details');
/*
predictor       coefficient     std_err                 t_value                 p_value      
Intercept	3.20627674968964	0.0326813079912564	98.1073569805545	0.0
logcarat	1.70452470343898	0.00925461851925636	184.18097946364	0.0
cut_1	0.0248513150420479	0.00205883749134525	12.0705568781001	1.74212147815449E-33
cut_2	0.0592222967540651	0.00205046710871861	28.8823441752619	1.89577957977459E-181
cut_3	0.0484922568383891	0.00197680447379432	24.5306288412591	7.54587989935812E-132
cut_4	0.0401247539990596	0.00197811498950696	20.2843384797668	5.41700752032948E-91
color_1	-0.017707509891794	0.00111045222072011	-15.9462150296848	4.65344544441911E-57
color_2	-0.0349070892313992	0.00111900256543415	-31.1948250251383	6.07301651834865E-211
color_3	-0.0632368553426645	0.0010990823568507	-57.5360480936688	0.0
color_4	-0.103785305271019	0.00116926383107931	-88.761238064824	0.0
color_5	-0.155322802983699	0.00131028410903126	-118.541316278753	0.0
color_6	-0.214330507057191	0.00162285775298721	-132.069805047713	0.0
clarity_1	0.421662292163101	0.00313299559778671	134.58757888488	0.0
clarity_2	0.204189110634472	0.00265684685257892	76.8539257113265	0.0
clarity_3	0.132251608735387	0.0026708674392372	49.516350677875	0.0
clarity_4	0.29794907055152	0.00271643494035256	109.68386031467	0.0
clarity_5	0.268132615401986	0.00267280812426945	100.318692152761	0.0
clarity_6	0.383835119626048	0.00288330725954413	133.123210630953	0.0
clarity_7	0.354806957625394	0.00279767633487096	126.822017687675	0.0
depthh	3.13541234127817E-4	3.40598184829402E-4	0.920560496483159	0.357285822781854
tablee	-1.59890128873257E-4	1.81571489828582E-4	-0.880590499225436	0.378545114126731
x	0.0372628030262343	0.00298247934997002	12.4939014335871	9.48843756834416E-36
y	0.0	0.00104395525173303	0.0	1.0
z	0.00310402253601275	0.00380551501289256	0.815664246625423	0.414697344388341
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
--PredPrice	16202	3892.10966081033	3994.13309821425	237.093256586936	954.695912864247	2427.54034576284	5230.55329224424	34189.2871311887

select MSE(price, PredPrice) OVER() FROM pred_linear_logprice_logcarat_l1;
--755491.495832627	

select RSQUARED(price, PredPrice) OVER() FROM pred_linear_logprice_logcarat_l1;
--0.952673575370631	

select CORR(price, PredPrice) FROM pred_linear_logprice_logcarat_l1;
--0.976360325136843