/*****************************
 * Copyright (c) 2017 EntIT Software LLC
 *****************************/

/**
 * DESCRIPTION
 *
 * This file contains a series of SQL commands to load the Machine Learning
 * example data sets.
 *
 * You need to first install MicroFocus Vertica before running
 * the commands in this file.
 *
*/

-- mtcars data set
DROP TABLE IF EXISTS mtcars;
DROP TABLE IF EXISTS mtcars_train;
DROP TABLE IF EXISTS mtcars_test;
DROP MODEL IF EXISTS myRFRegressorModel;
DROP MODEL IF EXISTS logistic_reg_mtcars;
DROP MODEL IF EXISTS svm_class;
CREATE TABLE mtcars (car_model varchar(30), mpg float, cyl int,
                     disp float, hp int, drat float, wt float,
                     qsec float, vs float, am float, gear int,
                     carb int, tf VARCHAR(5));
COPY mtcars FROM LOCAL 'mtcars.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;
CREATE TABLE mtcars_train AS (SELECT * FROM mtcars WHERE tf = 'train');
CREATE TABLE mtcars_test AS (SELECT * FROM mtcars WHERE tf = 'test');

-- iris data set
DROP TABLE IF EXISTS iris;
DROP TABLE IF EXISTS iris1;
DROP TABLE IF EXISTS iris2;
DROP MODEL IF EXISTS rf_iris;
CREATE TABLE iris (id int, Sepal_Length float, Sepal_Width float,
                   Petal_Length float, Petal_Width float, Species varchar(10));
CREATE TABLE iris1 (id int, Sepal_Length float, Sepal_Width float,
                    Petal_Length float, Petal_Width float, Species varchar(10));
CREATE TABLE iris2 (id int, Sepal_Length float, Sepal_Width float,
                    Petal_Length float, Petal_Width float, Species varchar(10));
COPY iris FROM LOCAL 'iris.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;
COPY iris1 FROM LOCAL 'iris1.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;
COPY iris2 FROM LOCAL 'iris2.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;

-- faithful data set
DROP TABLE IF EXISTS faithful;
DROP TABLE IF EXISTS faithful_testing;
DROP TABLE IF EXISTS faithful_training;
DROP MODEL IF EXISTS linear_reg_faithful;
DROP MODEL IF EXISTS svm_faithful;
CREATE TABLE faithful (id int, eruptions float, waiting int);
COPY faithful FROM LOCAL 'faithful.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;
CREATE TABLE faithful_testing (id int, eruptions float, waiting int);
COPY faithful_testing FROM LOCAL 'faithful_testing.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;
CREATE TABLE faithful_training (id int, eruptions float, waiting int);
COPY faithful_training FROM LOCAL 'faithful_training.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;

-- baseball data set
DROP TABLE IF EXISTS baseball;
CREATE TABLE baseball (id INT, first_name varchar(50), last_name varchar(50), dob DATE,
                           team varchar(20), hr int, hits int, avg float, salary float);
COPY baseball FROM LOCAL 'baseball.csv' DELIMITER ',' SKIP 1;

-- transactions data set
DROP TABLE IF EXISTS transaction_data;
CREATE TABLE transaction_data (first_name varchar(30), last_name varchar(30),
                               store varchar(30), cost float, fraud varchar(5));
COPY transaction_data FROM LOCAL 'transactions_data.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;

-- salary data set
DROP TABLE IF EXISTS salary_data;
CREATE TABLE salary_data (employee_id INT, first_name varchar(30), last_name varchar(30),
                          years_worked INT, current_salary INT);
COPY salary_data FROM LOCAL 'salary_data.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;

-- agar dish data set
DROP TABLE IF EXISTS agar_dish;
DROP TABLE IF EXISTS agar_dish_1;
DROP TABLE IF EXISTS agar_dish_2;
DROP MODEL IF EXISTS agar_dish_1;
CREATE TABLE agar_dish (id INT, x FLOAT, y FLOAT);
CREATE TABLE agar_dish_1 (id INT, x FLOAT, y FLOAT);
CREATE TABLE agar_dish_2 (id INT, x FLOAT, y FLOAT);
COPY agar_dish FROM LOCAL 'agar_dish.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;
COPY agar_dish_1 FROM LOCAL 'agar_dish_training.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;
COPY agar_dish_2 FROM LOCAL 'agar_dish_testing.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;

-- house84 data set
DROP TABLE IF EXISTS house84 CASCADE;
DROP TABLE IF EXISTS dem_votes CASCADE;
DROP TABLE IF EXISTS rep_votes CASCADE;
DROP TABLE IF EXISTS house84_clean CASCADE;
DROP MODEL IF EXISTS naive_house84_model;
CREATE TABLE house84 (id INT, party varchar(10), vote1 varchar(1), vote2 varchar(1),
                      vote3 varchar(1), vote4 varchar(1), vote5 varchar(1), vote6 varchar(1),
                      vote7 varchar(1), vote8 varchar(1), vote9 varchar(1), vote10 varchar(10),
                      vote11 varchar(1), vote12 varchar(1), vote13 varchar(1), vote14 varchar(1),
                      vote15 varchar(1), vote16 varchar(1));
COPY house84 FROM LOCAL 'house-votes-84.csv' DELIMITER ',' ENCLOSED BY '"';
CREATE TABLE house84_clean AS SELECT * FROM house84;
CREATE TABLE dem_votes (vote varchar(8), yes INT, no INT);
CREATE TABLE rep_votes (vote varchar(8), yes INT, no INT);
DROP TABLE IF EXISTS house84_test CASCADE;
DROP TABLE IF EXISTS house84_train CASCADE;

-- data set for missing value imputation
CREATE TABLE small_input_impute(pid int, pclass int, gender int,  x1 float, x2 float, x3 float, x4 INT, x5 char, x6 varchar);
INSERT INTO small_input_impute VALUES( 1, 0, 0, -9.445818, -9.740541, -9.786974, 3, 't', 'A');
INSERT INTO small_input_impute VALUES( 2, 0, 0, -9.618292, -9.308881, -9.562255, 4, 't', 'A');
INSERT INTO small_input_impute VALUES( 3, 0, 0, -9.060605, -9.390844, -9.559848, 6, 't', 'B');
INSERT INTO small_input_impute VALUES( 4, 0, 0, -2.264599, -2.615146, -2.107290, 15, 't', 'B');
INSERT INTO small_input_impute VALUES( 5, 0, 1, -2.590837, -2.892819, -2.702960, 2, 't', 'C');
INSERT INTO small_input_impute VALUES( 6, 0, 1, -2.264599, -2.615146, -2.107290, 11, 't', 'C');
INSERT INTO small_input_impute VALUES( 7, 1, 1, 3.829239,  3.087650,  'INFINITY', NULL, 'f', 'C');
INSERT INTO small_input_impute VALUES( 8, 1, 1, 3.273592,  NULL,  3.477332, 18, 'f', 'B');
INSERT INTO small_input_impute VALUES( 9, 1, 1, NULL,      3.841606,  3.754375, 20, 'f', 'B');
INSERT INTO small_input_impute VALUES( 10,1, 1,   NULL,      3.841606,  3.754375, 20, 't', 'A');
INSERT INTO small_input_impute VALUES( 11, 0, 0, -9.445818, -9.740541, -9.786974, 3, 't','B');
INSERT INTO small_input_impute VALUES( 12, 0, 0, -9.618292, -9.308881, -9.562255, 4, 't', 'C');
INSERT INTO small_input_impute VALUES( 13, 0, 0, -9.060605, -9.390844, -9.559848, 6, 't', 'C');
INSERT INTO small_input_impute VALUES( 14, 0, 0, -2.264599, -2.615146, -2.107290, 15, 'f','A');
INSERT INTO small_input_impute VALUES( 15, 0, 1, -2.590837, -2.892819, -2.702960, 2, 'f','A');
INSERT INTO small_input_impute VALUES( 16, 0, 1, -2.264599, -2.615146, -2.107290, 11, 'f', 'A');
INSERT INTO small_input_impute VALUES( 17, 1, 1, 3.829239,  3.087650,  'INFINITY', NULL, 'f', 'B');
INSERT INTO small_input_impute VALUES( 18, 1, 1, 3.273592,  NULL,  3.477332, 18, 't', 'B');
INSERT INTO small_input_impute VALUES( 19, 1, 1, NULL,      3.841606,  3.754375, 20, 't', NULL);
INSERT INTO small_input_impute VALUES( 20,1, 1,   NULL,      3.841606,  3.754375, 20, NULL, 'C');

-- titanic data set
DROP TABLE IF EXISTS titanic_training;
DROP TABLE IF EXISTS titanic_testing;
DROP MODEL IF EXISTS titanic_encoder;
CREATE TABLE titanic_training(passenger_id int, survived int, pclass int, name varchar(50), 
                           sex varchar(10), age int, sibling_and_spouse_count int, parent_and_child_count int,
                           ticket varchar(15), fare float, cabin varchar(10), embarkation_point varchar(15));
COPY titanic_training FROM LOCAL 'titanic_training.csv' DELIMITER ',' ENCLOSED BY '"';
CREATE TABLE titanic_testing(passenger_id int, pclass int, name varchar(50), 
                           sex varchar(10), age int, sibling_and_spouse_count int, parent_and_child_count int,
                           ticket varchar(15), fare float, cabin varchar(10), embarkation_point varchar(15));
COPY titanic_testing FROM LOCAL 'titanic_testing.csv' DELIMITER ',' ENCLOSED BY '"';

--data set for SVD
CREATE TABLE small_svd (id int, x1 int, x2 int, x3 int, x4 int);
INSERT INTO small_svd VALUES (1,7,3,8,2);
INSERT INTO small_svd VALUES (2,1,1,4,1);
INSERT INTO small_svd VALUES (3,2,3,2,0);
INSERT INTO small_svd VALUES (4,6,2,7,4);
INSERT INTO small_svd VALUES (5,7,3,8,2);
INSERT INTO small_svd VALUES (6,1,1,4,1);
INSERT INTO small_svd VALUES (7,2,3,2,0);
INSERT INTO small_svd VALUES (8,6,2,7,4);

--data set for SUMMARIZE_NUMCOL
CREATE TABLE employee (id INT, name VARCHAR(64), age INT, gender CHAR(1), title VARCHAR(64), salary MONEY);
INSERT INTO employee VALUES(1, 'Leonardo da Vinci', 44, 'M', 'Artist', 1234.56);
INSERT INTO employee VALUES(2, 'Albert Einstein', 45, 'M', 'Scientist', 2345.67);
INSERT INTO employee VALUES(3, 'Myrddin Wyltt', 67, 'M', 'Wizard', 34567.78);
INSERT INTO employee VALUES(4, 'George Walker Bush', 71, 'M', 'President', 4567.89);
INSERT INTO employee VALUES(6, 'Elizabeth Alexandra Mary', 90, 'F', 'Queen', 5678.90);

-- for timeseries (autoregression, moving_average), daily min temperatures in Melbourne
drop table if exists temp_data;
CREATE TABLE temp_data(time timestamp, Temperature float);
COPY temp_data FROM LOCAL 'daily-min-temperatures.csv' DELIMITER ',';

-- world data set
drop table if exists world;
CREATE TABLE world (
country VARCHAR(20),
HDI NUMERIC(5,3),
em1970 NUMERIC(15,9),
em1971 NUMERIC(15,9),
em1972 NUMERIC(15,9),
em1973 NUMERIC(15,9),
em1974 NUMERIC(15,9),
em1975 NUMERIC(15,9),
em1976 NUMERIC(15,9),
em1977 NUMERIC(15,9),
em1978 NUMERIC(15,9),
em1979 NUMERIC(15,9),
em1980 NUMERIC(15,9),
em1981 NUMERIC(15,9),
em1982 NUMERIC(15,9),
em1983 NUMERIC(15,9),
em1984 NUMERIC(15,9),
em1985 NUMERIC(15,9),
em1986 NUMERIC(15,9),
em1987 NUMERIC(15,9),
em1988 NUMERIC(15,9),
em1989 NUMERIC(15,9),
em1990 NUMERIC(15,9),
em1991 NUMERIC(15,9),
em1992 NUMERIC(15,9),
em1993 NUMERIC(15,9),
em1994 NUMERIC(15,9),
em1995 NUMERIC(15,9),
em1996 NUMERIC(15,9),
em1997 NUMERIC(15,9),
em1998 NUMERIC(15,9),
em1999 NUMERIC(15,9),
em2000 NUMERIC(15,9),
em2001 NUMERIC(15,9),
em2002 NUMERIC(15,9),
em2003 NUMERIC(15,9),
em2004 NUMERIC(15,9),
em2005 NUMERIC(15,9),
em2006 NUMERIC(15,9),
em2007 NUMERIC(15,9),
em2008 NUMERIC(15,9),
em2009 NUMERIC(15,9),
em2010 NUMERIC(15,9),
gdp1970 NUMERIC(15,9),
gdp1971 NUMERIC(15,9),
gdp1972 NUMERIC(15,9),
gdp1973 NUMERIC(15,9),
gdp1974 NUMERIC(15,9),
gdp1975 NUMERIC(15,9),
gdp1976 NUMERIC(15,9),
gdp1977 NUMERIC(15,9),
gdp1978 NUMERIC(15,9),
gdp1979 NUMERIC(15,9),
gdp1980 NUMERIC(15,9),
gdp1981 NUMERIC(15,9),
gdp1982 NUMERIC(15,9),
gdp1983 NUMERIC(15,9),
gdp1984 NUMERIC(15,9),
gdp1985 NUMERIC(15,9),
gdp1986 NUMERIC(15,9),
gdp1987 NUMERIC(15,9),
gdp1988 NUMERIC(15,9),
gdp1989 NUMERIC(15,9),
gdp1990 NUMERIC(15,9),
gdp1991 NUMERIC(15,9),
gdp1992 NUMERIC(15,9),
gdp1993 NUMERIC(15,9),
gdp1994 NUMERIC(15,9),
gdp1995 NUMERIC(15,9),
gdp1996 NUMERIC(15,9),
gdp1997 NUMERIC(15,9),
gdp1998 NUMERIC(15,9),
gdp1999 NUMERIC(15,9),
gdp2000 NUMERIC(15,9),
gdp2001 NUMERIC(15,9),
gdp2002 NUMERIC(15,9),
gdp2003 NUMERIC(15,9),
gdp2004 NUMERIC(15,9),
gdp2005 NUMERIC(15,9),
gdp2006 NUMERIC(15,9),
gdp2007 NUMERIC(15,9),
gdp2008 NUMERIC(15,9),
gdp2009 NUMERIC(15,9),
gdp2010 NUMERIC(15,9)); 

COPY world FROM LOCAL 'world.csv' DELIMITER ',' SKIP 1; 
