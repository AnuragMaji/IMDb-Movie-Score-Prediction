
  

 USE [IMDb Movies]

/* For total count of movies */

SELECT count(movie_title) as TOTAL_Movies
 from dbo.movie_metadata;

 /*For charateristics of dataset */


 exec sp_help movie_metadata;
 

 /*For count of distinct genres */
 SELECT  count(DISTINCT genres) as NUM_GENRES
 from dbo.movie_metadata;



/*a. Categorize films by running time into Short, Medium, Long and Very Long durations.*/

SELECT
	movie_title	
	, Duration
	, CASE 
		WHEN Duration <=90 THEN 'Short'
		WHEN Duration<=150 THEN 'Medium'
		WHEN Duration<=180 THEN 'Long'	
		ELSE 'Super Long'
	  END AS movie_Duration
FROM
	dbo.movie_metadata;

/*B. Movies with the same person as actor and director */

SELECT
	actor_1_name, movie_title, director_name
FROM
	dbo.movie_metadata 
WHERE actor_1_name = director_name ;

/*C Movies with greater than 100 million gross earnings and not produced in the US */

SELECT movie_title, gross, country
from dbo.movie_metadata
where gross > 100000000 and country <> 'USA';

/*D. People who have been Actors and directors with the list of films they have acted in */

SELECT actor_1_name, movie_title
FROM
	dbo.movie_metadata 
WHERE actor_1_name in (
	SELECT director_name
	FROM dbo.movie_metadata
	)
;

/*E. Listing directors by the number of movies they have directed.
We can see that 104 movies do not have director names mentioned in the table.
 */

SELECT director_name, count(movie_title) as number_of_movies
from dbo.movie_metadata
group by director_name
order by count(movie_title)  DESC; 

/*F. Top 10 actors with the highest grossof individual movies, number of movies they have worked in,
 and their respective gross of least earning movie */

SELECT top 10 with ties actor_1_name, count(movie_title) as number_of_movies,
 max(gross) as maximum_gross_movie, min(gross) as min_gross
from dbo.movie_metadata
group by actor_1_name
order by max(gross) DESC;












	



