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


/* 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
Delete the description column. */

ALTER TABLE actor
	DROP COLUMN Description;


/* 4a. List the last names of actors, as well as how many actors have that last name. */

SELECT
	a.last_name AS LastName,
    COUNT(a.last_name) As CountOfLastName
FROM
	actor a
GROUP BY 
	a.last_name;


/* 4b. List last names of actors and the number of actors who have that last name, 
but only for names that are shared by at least two actors */

SELECT 
	tq.LastName, 
    tq.CountOfLastName 
FROM
	(SELECT
		a.last_name AS LastName,
		COUNT(a.last_name) As CountOfLastName
	FROM
		actor a
	GROUP BY 
		a.last_name) AS tq
WHERE
    tq.CountOfLastName >= 2;


/* 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
Write a query to fix the record. */

UPDATE 
	actor
SET
	first_name = 'HARPO'
WHERE
	(first_name = 'GROUCHO') AND (last_name = 'WILLIAMS');


/* 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct 
name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. */

UPDATE
	actor
SET
	first_name = 'GROUCHO'
WHERE 
	first_name = 'HARPO';






