-- Data cleaning for the Naive Bayes example
/***********

* DESCRIPTION
* 
* This file is used to clean the house84 data set.
* Since there are a number of votes in the data that are '?', we need to
* assign these votes to 'y' or 'n' in order to properly train the model.
* Each '?' vote is assigned to the mean value of the party per each vote.
*
****/

-- Fill in NULL values
-- Vote 1
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote1',1,1,'')
       ) as vote,
       (
    SELECT count(vote1) as yes FROM house84 WHERE party = 'democrat' AND vote1 = 'y'
       ) as Yes,
       (
    SELECT count(vote1) as no FROM house84 WHERE party = 'democrat' AND vote1 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote1',1,1,'')
       ) as vote,
       (
    SELECT count(vote1) as yes FROM house84 WHERE party = 'republican' AND vote1 = 'y'
       ) as Yes,
       (
    SELECT count(vote1) as no FROM house84 WHERE party = 'republican' AND vote1 = 'n'
       ) as No;
-- Vote 2
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote2',1,1,'')
       ) as vote,
       (
    SELECT count(vote2) as yes FROM house84 WHERE party = 'democrat' AND vote2 = 'y'
       ) as Yes,
       (
    SELECT count(vote2) as no FROM house84 WHERE party = 'democrat' AND vote2 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote2',1,1,'')
       ) as vote,
       (
    SELECT count(vote2) as yes FROM house84 WHERE party = 'republican' AND vote2 = 'y'
       ) as Yes,
       (
    SELECT count(vote2) as no FROM house84 WHERE party = 'republican' AND vote2 = 'n'
       ) as No;
-- Vote 3
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote3',1,1,'')
       ) as vote,
       (
    SELECT count(vote3) as yes FROM house84 WHERE party = 'democrat' AND vote3 = 'y'
       ) as Yes,
       (
    SELECT count(vote3) as no FROM house84 WHERE party = 'democrat' AND vote3 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote3',1,1,'')
       ) as vote,
       (
    SELECT count(vote3) as yes FROM house84 WHERE party = 'republican' AND vote3 = 'y'
       ) as Yes,
       (
    SELECT count(vote3) as no FROM house84 WHERE party = 'republican' AND vote3 = 'n'
       ) as No;
-- Vote 4
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote4',1,1,'')
       ) as vote,
       (
    SELECT count(vote4) as yes FROM house84 WHERE party = 'democrat' AND vote4 = 'y'
       ) as Yes,
       (
    SELECT count(vote4) as no FROM house84 WHERE party = 'democrat' AND vote4 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote4',1,1,'')
       ) as vote,
       (
    SELECT count(vote4) as yes FROM house84 WHERE party = 'republican' AND vote4 = 'y'
       ) as Yes,
       (
    SELECT count(vote4) as no FROM house84 WHERE party = 'republican' AND vote4 = 'n'
       ) as No;
-- Vote 5
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote5',1,1,'')
       ) as vote,
       (
    SELECT count(vote5) as yes FROM house84 WHERE party = 'democrat' AND vote5 = 'y'
       ) as Yes,
       (
    SELECT count(vote5) as no FROM house84 WHERE party = 'democrat' AND vote5 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote5',1,1,'')
       ) as vote,
       (
    SELECT count(vote5) as yes FROM house84 WHERE party = 'republican' AND vote5 = 'y'
       ) as Yes,
       (
    SELECT count(vote5) as no FROM house84 WHERE party = 'republican' AND vote5 = 'n'
       ) as No;
-- Vote 6
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote6',1,1,'')
       ) as vote,
       (
    SELECT count(vote6) as yes FROM house84 WHERE party = 'democrat' AND vote6 = 'y'
       ) as Yes,
       (
    SELECT count(vote6) as no FROM house84 WHERE party = 'democrat' AND vote6 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote6',1,1,'')
       ) as vote,
       (
    SELECT count(vote6) as yes FROM house84 WHERE party = 'republican' AND vote6 = 'y'
       ) as Yes,
       (
    SELECT count(vote6) as no FROM house84 WHERE party = 'republican' AND vote6 = 'n'
       ) as No;
-- Vote 7
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote7',1,1,'')
       ) as vote,
       (
    SELECT count(vote7) as yes FROM house84 WHERE party = 'democrat' AND vote7 = 'y'
       ) as Yes,
       (
    SELECT count(vote7) as no FROM house84 WHERE party = 'democrat' AND vote7 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote7',1,1,'')
       ) as vote,
       (
    SELECT count(vote7) as yes FROM house84 WHERE party = 'republican' AND vote7 = 'y'
       ) as Yes,
       (
    SELECT count(vote7) as no FROM house84 WHERE party = 'republican' AND vote7 = 'n'
       ) as No;
-- Vote 8
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote8',1,1,'')
       ) as vote,
       (
    SELECT count(vote8) as yes FROM house84 WHERE party = 'democrat' AND vote8 = 'y'
       ) as Yes,
       (
    SELECT count(vote8) as no FROM house84 WHERE party = 'democrat' AND vote8 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote8',1,1,'')
       ) as vote,
       (
    SELECT count(vote8) as yes FROM house84 WHERE party = 'republican' AND vote8 = 'y'
       ) as Yes,
       (
    SELECT count(vote8) as no FROM house84 WHERE party = 'republican' AND vote8 = 'n'
       ) as No;
-- Vote 9
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote9',1,1,'')
       ) as vote,
       (
    SELECT count(vote9) as yes FROM house84 WHERE party = 'democrat' AND vote9 = 'y'
       ) as Yes,
       (
    SELECT count(vote9) as no FROM house84 WHERE party = 'democrat' AND vote9 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote9',1,1,'')
       ) as vote,
       (
    SELECT count(vote9) as yes FROM house84 WHERE party = 'republican' AND vote9 = 'y'
       ) as Yes,
       (
    SELECT count(vote9) as no FROM house84 WHERE party = 'republican' AND vote9 = 'n'
       ) as No;
-- Vote 10
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote10',1,1,'')
       ) as vote,
       (
    SELECT count(vote10) as yes FROM house84 WHERE party = 'democrat' AND vote10 = 'y'
       ) as Yes,
       (
    SELECT count(vote10) as no FROM house84 WHERE party = 'democrat' AND vote10 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote10',1,1,'')
       ) as vote,
       (
    SELECT count(vote10) as yes FROM house84 WHERE party = 'republican' AND vote10 = 'y'
       ) as Yes,
       (
    SELECT count(vote10) as no FROM house84 WHERE party = 'republican' AND vote10 = 'n'
       ) as No;
-- Vote 11
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote11',1,1,'')
       ) as vote,
       (
    SELECT count(vote11) as yes FROM house84 WHERE party = 'democrat' AND vote11 = 'y'
       ) as Yes,
       (
    SELECT count(vote11) as no FROM house84 WHERE party = 'democrat' AND vote11 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote11',1,1,'')
       ) as vote,
       (
    SELECT count(vote11) as yes FROM house84 WHERE party = 'republican' AND vote11 = 'y'
       ) as Yes,
       (
    SELECT count(vote11) as no FROM house84 WHERE party = 'republican' AND vote11 = 'n'
       ) as No;
-- Vote 12
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote12',1,1,'')
       ) as vote,
       (
    SELECT count(vote12) as yes FROM house84 WHERE party = 'democrat' AND vote12 = 'y'
       ) as Yes,
       (
    SELECT count(vote12) as no FROM house84 WHERE party = 'democrat' AND vote12 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote12',1,1,'')
       ) as vote,
       (
    SELECT count(vote12) as yes FROM house84 WHERE party = 'republican' AND vote12 = 'y'
       ) as Yes,
       (
    SELECT count(vote12) as no FROM house84 WHERE party = 'republican' AND vote12 = 'n'
       ) as No;
-- Vote 13
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote13',1,1,'')
       ) as vote,
       (
    SELECT count(vote13) as yes FROM house84 WHERE party = 'democrat' AND vote13 = 'y'
       ) as Yes,
       (
    SELECT count(vote13) as no FROM house84 WHERE party = 'democrat' AND vote13 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote13',1,1,'')
       ) as vote,
       (
    SELECT count(vote13) as yes FROM house84 WHERE party = 'republican' AND vote13 = 'y'
       ) as Yes,
       (
    SELECT count(vote13) as no FROM house84 WHERE party = 'republican' AND vote13 = 'n'
       ) as No;
-- Vote 14
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote14',1,1,'')
       ) as vote,
       (
    SELECT count(vote14) as yes FROM house84 WHERE party = 'democrat' AND vote14 = 'y'
       ) as Yes,
       (
    SELECT count(vote14) as no FROM house84 WHERE party = 'democrat' AND vote14 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote14',1,1,'')
       ) as vote,
       (
    SELECT count(vote14) as yes FROM house84 WHERE party = 'republican' AND vote14 = 'y'
       ) as Yes,
       (
    SELECT count(vote14) as no FROM house84 WHERE party = 'republican' AND vote14 = 'n'
       ) as No;
-- Vote 15
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote15',1,1,'')
       ) as vote,
       (
    SELECT count(vote15) as yes FROM house84 WHERE party = 'democrat' AND vote15 = 'y'
       ) as Yes,
       (
    SELECT count(vote15) as no FROM house84 WHERE party = 'democrat' AND vote15 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote15',1,1,'')
       ) as vote,
       (
    SELECT count(vote15) as yes FROM house84 WHERE party = 'republican' AND vote15 = 'y'
       ) as Yes,
       (
    SELECT count(vote15) as no FROM house84 WHERE party = 'republican' AND vote15 = 'n'
       ) as No;
-- Vote 16
-- Dems
INSERT INTO dem_votes SELECT (
    SELECT INSERT('xvote16',1,1,'')
       ) as vote,
       (
    SELECT count(vote16) as yes FROM house84 WHERE party = 'democrat' AND vote16 = 'y'
       ) as Yes,
       (
    SELECT count(vote16) as no FROM house84 WHERE party = 'democrat' AND vote16 = 'n'
       ) as No;
-- Reps
INSERT INTO rep_votes SELECT (
    SELECT INSERT('xvote16',1,1,'')
       ) as vote,
       (
    SELECT count(vote16) as yes FROM house84 WHERE party = 'republican' AND vote16 = 'y'
       ) as Yes,
       (
    SELECT count(vote16) as no FROM house84 WHERE party = 'republican' AND vote16 = 'n'
       ) as No;

-- Update Statement
-- Vote 1
-- Dems
UPDATE house84_clean SET vote1 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote1') WHERE vote1 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote1 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote1') WHERE vote1 = '?' AND party = 'republican';
-- Vote 2
-- Dems
UPDATE house84_clean SET vote2 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote2') WHERE vote2 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote2 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote2') WHERE vote2 = '?' AND party = 'republican';
-- Vote 3
-- Dems
UPDATE house84_clean SET vote3 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote3') WHERE vote3 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote3 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote3') WHERE vote3 = '?' AND party = 'republican';
-- Vote 4
-- Dems
UPDATE house84_clean SET vote4 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote4') WHERE vote4 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote4 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote4') WHERE vote4 = '?' AND party = 'republican';
-- Vote 5
-- Dems
UPDATE house84_clean SET vote5 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote5') WHERE vote5 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote5 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote5') WHERE vote5 = '?' AND party = 'republican';
-- Vote 6
-- Dems
UPDATE house84_clean SET vote6 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote6') WHERE vote6 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote6 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote6') WHERE vote6 = '?' AND party = 'republican';
-- Vote 7
-- Dems
UPDATE house84_clean SET vote7 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote7') WHERE vote7 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote7 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote7') WHERE vote7 = '?' AND party = 'republican';
-- Vote 8
-- Dems
UPDATE house84_clean SET vote8 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote8') WHERE vote8 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote8 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote8') WHERE vote8 = '?' AND party = 'republican';
-- Vote 9
-- Dems
UPDATE house84_clean SET vote9 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote9') WHERE vote9 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote9 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote9') WHERE vote9 = '?' AND party = 'republican';
-- Vote 10
-- Dems
UPDATE house84_clean SET vote10 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote10') WHERE vote10 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote10 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote10') WHERE vote10 = '?' AND party = 'republican';
-- Vote 11
-- Dems
UPDATE house84_clean SET vote11 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote11') WHERE vote11 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote11 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote11') WHERE vote11 = '?' AND party = 'republican';
-- Vote 12
-- Dems
UPDATE house84_clean SET vote12 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote12') WHERE vote12 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote12 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote12') WHERE vote12 = '?' AND party = 'republican';
-- Vote 13
-- Dems
UPDATE house84_clean SET vote13 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote13') WHERE vote13 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote13 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote13') WHERE vote13 = '?' AND party = 'republican';
-- Vote 14
-- Dems
UPDATE house84_clean SET vote14 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote14') WHERE vote14 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote14 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote14') WHERE vote14 = '?' AND party = 'republican';
-- Vote 15
-- Dems
UPDATE house84_clean SET vote15 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote15') WHERE vote15 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote15 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote15') WHERE vote15 = '?' AND party = 'republican';
-- Vote 16
-- Dems
UPDATE house84_clean SET vote16 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM dem_votes WHERE vote = 'vote16') WHERE vote16 = '?' AND party = 'democrat';
-- Reps
UPDATE house84_clean SET vote16 = (SELECT CASE WHEN yes > no THEN 'y' WHEN yes < no THEN 'n' END FROM rep_votes WHERE vote = 'vote16') WHERE vote16 = '?' AND party = 'republican';

-- Commit the data
COMMIT;

-- Create training and testing
-- Use a 75% sample for the training data
CREATE TABLE house84_train AS SELECT * FROM house84_clean TABLESAMPLE(75);
CREATE TABLE house84_test AS SELECT * FROM house84_clean AS foo
                                       WHERE foo.id NOT IN ( 
                                             SELECT bar.id
                                             FROM house84_train AS bar
                                                           );
