/*
SQL Assignment using sakila Database in MySQL

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


/* 5a. You cannot locate the schema of the address table. Which query would you use to re-create it? */

CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;


/* 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address */

SELECT 
	s.first_name AS FirstName,
    s.last_name AS LastName,
    a.address AS Address
FROM 
	staff s
    INNER JOIN address a ON (s.address_id = a.address_id);


/* 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. */

SELECT
	CONCAT(s.first_name, ' ', s.last_name) AS StaffName,
	SUM(p.amount) AS MonthlyTotal
FROM 
	payment p
	INNER JOIN staff s ON (p.staff_id = s.staff_id)
WHERE 
	p.payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY 
	StaffName
ORDER BY
	MonthlyTotal DESC;


/* 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join. */

SELECT 
	f.title AS Title,
    COUNT(f.film_id) AS NumActors
FROM 
	film f
    INNER JOIN film_actor fa ON (f.film_id = fa.film_id)
GROUP BY
	Title;
    

/* 6d. How many copies of the film Hunchback Impossible exist in the inventory system? */

SELECT 
	COUNT(f.film_id) AS NumFilmsInInvetory
FROM 
	film f
    INNER JOIN inventory i ON (f.film_id = i.film_id)
WHERE
	f.title = 'Hunchback Impossible';


/* 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
List the customers alphabetically by last name */

SELECT 
	c.first_name AS FirstName,
    c.last_name AS LastName,
    SUM(p.amount) AS TotalAmountPaid
FROM
	customer c
    INNER JOIN payment p ON (c.customer_id = p.customer_id)
GROUP BY
	c.customer_id
ORDER BY 
	c.last_name ASC;


/* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of 
movies starting with the letters K and Q whose language is English. */

SELECT 
	f.title As EnglishFilmsWithKandQ
FROM
	film f
    INNER JOIN language l ON (f.language_id = l.language_id)
WHERE
	(f.title LIKE 'K%' OR f.title LIKE 'Q%') AND 
    (l.name = 'English');


/* 7b. Use subqueries to display all actors who appear in the film Alone Trip. */

SELECT 
	a.first_name AS FirstName,
    a.last_name AS LastName
FROM 
	film f
    INNER JOIN film_actor fa ON (f.film_id = fa.film_id)
    INNER JOIN actor a ON (fa.actor_id = a.actor_id)
WHERE
	f.title = 'Alone Trip'
ORDER BY
	LastName ASC;

    
/* 7c. You want to run an email marketing campaign in Canada, for which you will need the names 
and email addresses of all Canadian customers. Use joins to retrieve this information. */

SELECT 
	c.first_name AS FirstName,
    c.last_name AS LastName,
    c.email
FROM 
	customer c
    INNER JOIN address a ON (c.address_id = a.address_id)
    INNER JOIN city cy ON (a.city_id = cy.city_id)
    INNER JOIN country ct ON (cy.country_id = ct.country_id)
WHERE
	ct.country = 'Canada';

    
/* 7d. Sales have been lagging among young families, and you wish to target all family movies 
for a promotion. Identify all movies categorized as family films. */

SELECT 
	f.title
FROM
	film f
    INNER JOIN film_category fc ON (f.film_id = fc.film_id)
    INNER JOIN category c ON (fc.category_id = c.category_id)
WHERE
	c.name = 'Family';


/* 7e. Display the most frequently rented movies in descending order. */

SELECT 
	f.title,
    COUNT(f.film_id) AS NumTimesRented
FROM
	film f
    INNER JOIN inventory i ON (f.film_id = i.film_id)
    INNER JOIN rental r ON (i.inventory_id = r.inventory_id)
GROUP BY
	f.title
ORDER BY
	NumTimesRented DESC;
    

/* 7f. Write a query to display how much business, in dollars, each store brought in */

SELECT
	st.store_id AS Store_ID,
    a.address AS Store_Address,
	SUM(p.amount) AS Revenue

FROM 
	payment p
    INNER JOIN staff s ON (p.staff_id = s.staff_id)
    INNER JOIN store st ON (s.store_id = st.store_id)
    INNER JOIN address a ON (st.address_id = a.address_id)
GROUP BY 
	st.store_id
ORDER BY
	Revenue DESC;
  
  
/* 7g. Write a query to display for each store its store ID, city, and country. */    

SELECT 
	s.store_id AS StoreID,
	c.city As City,
    cy.country As Country
FROM 
	store s
    INNER JOIN address a ON (s.address_id = a.address_id)
    INNER JOIN city c ON (a.city_id = c.city_id)
	INNER JOIN country cy ON (c.country_id = cy.country_id);


/* 7h. List the top five genres in gross revenue in descending order. (Hint: you may need 
to use the following tables: category, film_category, inventory, payment, and rental.) */

SELECT
	c.name AS FilmCategory,
    SUM(p.amount) AS Revenue
FROM
	category c
    INNER JOIN film_category fc ON (c.category_id = fc.category_id)
    INNER JOIN inventory i ON (fc.film_id = i.film_id)
    INNER JOIN rental r ON (i.inventory_id = r.inventory_id)
    INNER JOIN payment p ON (r.rental_id = p.rental_id)
GROUP BY
	FilmCategory
ORDER BY 
	Revenue DESC
LIMIT 5;


/* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres 
by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, 
you can substitute another query to create a view. */

CREATE VIEW 
	TopFiveGenresByRevenue_View AS

	SELECT
		c.name AS FilmCategory,
		SUM(p.amount) AS Revenue
	FROM
		category c
		INNER JOIN film_category fc ON (c.category_id = fc.category_id)
		INNER JOIN inventory i ON (fc.film_id = i.film_id)
		INNER JOIN rental r ON (i.inventory_id = r.inventory_id)
		INNER JOIN payment p ON (r.rental_id = p.rental_id)
	GROUP BY
		FilmCategory
	ORDER BY 
		Revenue DESC
	LIMIT 5;


/* 8b. How would you display the view that you created in 8a? */

SELECT * FROM TopFiveGenresByRevenue_View;


/* 8c. You find that you no longer need the view top_five_genres. Write a query to delete it. */

DROP VIEW TopFiveGenresByRevenue_View;


