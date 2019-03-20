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


/*  2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
What is one query would you use to obtain this information? */

SELECT
	a.actor_id AS ID,
    a.first_name AS FirstName,
    a.last_name AS LastName
FROM
	actor a
WHERE
	a.first_name = 'Joe';


-- 2b. Find all actors whose last name contain the letters GEN
SELECT
	a.actor_id AS ID,
    a.first_name AS FirstName,
    a.last_name AS LastName
FROM
	actor a
WHERE
	a.last_name LIKE '%GEN%';


/* 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name 
and first name, in that order */
SELECT
	a.actor_id AS ID,
    a.first_name AS FirstName,
    a.last_name AS LastName
FROM
	actor a
WHERE
	a.last_name LIKE '%LI%'
ORDER BY 
	a.last_name ASC,
    a.first_name ASC;


/* 2d. Using IN, display the country_id and country columns of the following countries: 
Afghanistan, Bangladesh, and China: */
SELECT
	c.country_id,
    c.country
FROM
	country c
WHERE
	c.country IN ('Afghanistan', 'Bangladesh', 'China');


/* 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
so create a column in the table actor named description and use the data type BLOB 
(Make sure to research the type BLOB, as the difference between it and VARCHAR are significant). */

ALTER TABLE actor 
	ADD COLUMN Description Blob;








