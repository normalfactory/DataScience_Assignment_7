/*
SQL Assignment

March 19, 2019
Scott McEachern
*/

-- Set current database
use sakila;


-- 1a. Display the first and last names of all actors from the table actor
SELECT
	a.first_name AS FirstName,
    a.last_name AS LastName
FROM 
	actor a;


-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT
	UPPER(CONCAT(a.first_name, ' ', a.last_name)) AS `Actor Name`
FROM 
	actor a;


