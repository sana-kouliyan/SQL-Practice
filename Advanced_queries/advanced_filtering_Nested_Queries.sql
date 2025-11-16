
-- Section1

   SELECT DISTINCT
       platform.platform_name AS platform_name,
       AVG(rs.num_sales) AS Average
   FROM platform
       JOIN game_platform gp ON platform.id = gp.platform_id
       JOIN region_sales rs ON rs.game_platform_id = gp.id
   GROUP BY platform.platform_name
   ORDER BY Average DESC;

-- Section2

   SELECT game.game_name,
          platform.platform_name,
          game_platform.release_year,
          publisher.publisher_name,
          SUM(region_sales.num_sales) AS global_sales
   FROM game
       JOIN game_publisher ON game.id = game_publisher.game_id
       JOIN game_platform ON game_platform.game_publisher_id = game_publisher.id
       JOIN platform ON platform.id = game_platform.platform_id
       JOIN publisher ON publisher.id = game_publisher.publisher_id
       JOIN region_sales ON game_platform.id = region_sales.game_platform_id
   GROUP BY game.game_name,
            platform.platform_name,
            game_platform.release_year,
            publisher.publisher_name
   ORDER BY global_sales DESC
   LIMIT 20;

-- Section3

   SELECT
       game.game_name,
       COUNT(DISTINCT game_platform.platform_id) AS platform_count
   FROM game
       JOIN game_publisher ON game.id = game_publisher.game_id
       JOIN game_platform ON game_platform.game_publisher_id = game_publisher.id
   GROUP BY game.game_name
   HAVING platform_count > 5
   ORDER BY platform_count DESC, game.game_name;

-- Section4

   WITH genre_platform_sale AS (
       SELECT
       platform.platform_name AS platform_name,
       genre.genre_name AS genre,
       SUM(region_sales.num_sales) AS genre_sale
   FROM region_sales
       JOIN game_platform ON game_platform.id = region_sales.game_platform_id
       JOIN platform ON game_platform.platform_id = platform.id
       JOIN game_publisher ON game_platform.game_publisher_id = game_publisher.id
       JOIN game ON game_publisher.game_id = game.id
       JOIN genre ON game.genre_id = genre.id
   GROUP BY platform.platform_name, genre.genre_name)
SELECT
    gps.platform_name AS platform,
    gps.genre,
    DENSE_RANK() OVER (PARTITION BY gps.platform_name
        ORDER BY gps.genre_sale DESC ) AS genre_in_platform_rank,
    gps.genre_sale,
    DENSE_RANK() over (ORDER BY gps.genre_sale DESC ) AS total_rank
   FROM genre_platform_sale AS gps
   ORDER BY gps.genre_sale DESC, gps.platform_name, gps.genre;

-- Section5

   WITH sum_per_game AS (
       SELECT game.game_name,
              region.region_name,
              SUM(rs.num_sales) AS total_sales
       FROM game
           JOIN game_publisher  gp on game.id = gp.game_id
           JOIN game_platform gpl on gp.id = gpl.game_publisher_id
           JOIN region_sales rs on gpl.id = rs.game_platform_id
           JOIN region on rs.region_id = region.id
       GROUP BY game.game_name, region.region_name
   ),
       top10_per_region AS (
           SELECT *,
                  DENSE_RANK() over (PARTITION BY region_name
                      ORDER BY total_sales DESC) AS rank_in_region
           FROM sum_per_game
       )
   SELECT
       game_name,
       region_name,
       total_sales,
       rank_in_region
   FROM top10_per_region
   WHERE rank_in_region <= 10
   ORDER BY region_name, total_sales DESC , game_name;

-- Section6

   WITH game_per_publisher AS (
       SELECT
           game.game_name,
           publisher.publisher_name AS publishers,
           COUNT(*) OVER (PARTITION BY game_name) AS no_publisher
   FROM game
   JOIN game_publisher gp on game.id = gp.game_id
   JOIN publisher on gp.publisher_id = publisher.id
   )
   SELECT
       game_name,
       GROUP_CONCAT(publishers
                    ORDER BY game_per_publisher.publishers SEPARATOR ',') AS publishers
   FROM game_per_publisher
   WHERE no_publisher>1
   GROUP BY game_name
   ORDER BY game_name;

