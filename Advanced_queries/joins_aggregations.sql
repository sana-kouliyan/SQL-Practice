
-- Section1

   SELECT movie.title AS title
   FROM movie
       LEFT JOIN movie_genres ON movie.movie_id = movie_genres.movie_id
   WHERE movie_genres.genre_id IS NULL;

-- Section2

   SELECT movie.title AS 'Title', person.person_name AS 'Director/Leading actor'
   FROM movie
       JOIN movie_cast ON movie.movie_id = movie_cast.movie_id
       JOIN movie_crew ON movie.movie_id = movie_crew.movie_id
       JOIN person ON movie_cast.person_id = person.person_id
                          AND movie_crew.person_id = person.person_id
   WHERE movie_cast.person_id = movie_crew.person_id
     AND movie_crew.job = 'Director' AND movie_cast.cast_order = 0
   ORDER BY Title;

-- Section3

   SELECT person.person_name AS Name , COUNT(movie_cast.person_id) AS count_of_movies
   FROM person
       JOIN movie_cast ON person.person_id = movie_cast.person_id
   WHERE movie_cast.cast_order = 0
   GROUP BY person.person_id
   ORDER BY count_of_movies DESC, `Name`;

-- Section4

   SELECT genre.genre_name AS genre,
          AVG(movie.vote_average) AS avg_rating,
          MAX(movie.vote_average) AS max_rating,
          MIN(movie.vote_average) AS min_rating
   FROM movie
       JOIN movie_genres ON movie.movie_id = movie_genres.movie_id
       JOIN genre ON movie_genres.genre_id = genre.genre_id
   GROUP BY genre.genre_name
   ORDER BY avg_rating DESC;

-- Section5

   SELECT p1.person_name AS `person #1`,
          p2.person_name AS `person #2`,
          COUNT(*) AS movies_played_together
   FROM movie_cast cast1
       JOIN movie_cast cast2 ON cast1.movie_id = cast2.movie_id
                                    AND cast1.person_id < cast2.person_id
       JOIN person p1 ON cast1.person_id = p1.person_id
       JOIN person p2 ON cast2.person_id = p2.person_id
   GROUP BY cast1.person_id, cast2.person_id
   ORDER BY movies_played_together DESC, `person #1`, `person #2`
   LIMIT 10;