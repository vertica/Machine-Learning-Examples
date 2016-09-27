/*****************************
 * HPE Vertica
 * Copyright (c) 2005 - 2016 Vertica, an HPE company
 *****************************/

/**
 * DESCRIPTION
 *
 * This file contains a series of SQL commands to load the Machine Learning
 * example data sets.
 *
 * You need to first install HPE Vertica before running
 * the commands in this file.
 *
*/

-- mtcars data set
DROP TABLE IF EXISTS mtcars;
DROP TABLE IF EXISTS mtcars_train;
DROP TABLE IF EXISTS mtcars_test;
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
CREATE TABLE iris (id int, Sepal_Length float, Sepal_Width float,
                   Petal_Length float, Petal_Wdith float, Species varchar(10));
CREATE TABLE iris1 (id int, Sepal_Length float, Sepal_Width float,
                    Petal_Length float, Petal_Wdith float, Species varchar(10));
CREATE TABLE iris2 (id int, Sepal_Length float, Sepal_Width float,
                    Petal_Length float, Petal_Wdith float, Species varchar(10));
COPY iris FROM LOCAL 'iris.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;
COPY iris1 FROM LOCAL 'iris1.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;
COPY iris2 FROM LOCAL 'iris2.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;

-- faithful data set
DROP TABLE IF EXISTS faithful;
DROP TABLE IF EXISTS faithful_testing;
DROP TABLE IF EXISTS faithful_training;
CREATE TABLE faithful (id int, eruptions float, waiting int);
COPY faithful FROM LOCAL 'faithful.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;
CREATE TABLE faithful_testing (id int, eruptions float, waiting int);
COPY faithful_test FROM LOCAL 'faithful_testing.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;
CREATE TABLE faithful_training (id int, eruptions float, waiting int);
COPY faithful_training FROM LOCAL 'faithful_training.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;

-- baseball data set
DROP TABLE IF EXISTS baseball;
CREATE TABLE baseball (id identity, first_name varchar(50), last_name varchar(50), dob DATE,
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
DROP TABLE IF EXISTS agar_dish_training;
DROP TABLE IF EXISTS agar_dish_testing;
CREATE TABLE agar_dish (id INT, x FLOAT, y FLOAT);
CREATE TABLE agar_dish_training (id INT, x FLOAT, y FLOAT);
CREATE TABLE agar_dish_testing (id INT, x FLOAT, y FLOAT);
COPY agar_dish FROM LOCAL 'agar_dish.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;
COPY agar_dis_training FROM LOCAL 'agar_dish_training.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;
COPY agar_dish_testing FROM LOCAL 'agar_dish_testing.csv' DELIMITER ',' ENCLOSED BY '"' SKIP 1;

