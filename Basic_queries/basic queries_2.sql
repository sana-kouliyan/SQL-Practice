
-- Section1

   SELECT family_name, given_name AS name
   FROM players
   WHERE given_name LIKE '%pir%' or family_name LIKE '%pir%'
   ORDER BY family_name;

-- Section2

   SELECT shirt_number, COUNT(shirt_number) AS count_shirt_number
   FROM player_appearances
   GROUP BY shirt_number
   HAVING COUNT(shirt_number) > 1000
   ORDER BY COUNT(shirt_number) DESC;

-- Section3

   SELECT DISTINCT players.family_name, players.given_name AS name
   FROM award_winners AS award1
       JOIN award_winners AS award2
           ON award1.player_id = award2.player_id
       JOIN players
           ON players.player_id = award1.player_id
   WHERE award1.award_id = 'A-8'
     AND award2.award_id IN ('A-1','A-2','A-3','A-4','A-5','A-6','A-7')
   ORDER BY family_name;
