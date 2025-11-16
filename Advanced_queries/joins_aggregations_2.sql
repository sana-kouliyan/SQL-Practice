
-- Section1

   WITH artist_per_customer AS(
   SELECT DISTINCT artist.Name AS artist,
                   invoice.CustomerId AS customer_id
   FROM artist
       JOIN album ON artist.ArtistId = album.ArtistId
       JOIN track ON album.AlbumId = track.AlbumId
       JOIN invoiceline ON track.TrackId = invoiceline.TrackId
       JOIN invoice ON invoiceline.InvoiceId = invoice.InvoiceId)
   SELECT artist_1.artist AS artist_A,
          artist_2.artist  AS artist_B,
          COUNT(*) AS `num_occurrences`
   FROM artist_per_customer AS artist_1
       JOIN artist_per_customer AS artist_2 ON artist_1.customer_id=artist_2.customer_id
   WHERE artist_1.artist < artist_2.artist
   GROUP BY artist_A, artist_B
   ORDER BY num_occurrences DESC, artist_A, artist_B
   LIMIT 200;

-- Section2

   WITH customers AS(
      SELECT customer.FirstName,
             customer.LastName,
             SUM(Quantity * UnitPrice) AS `total_spent`
      FROM customer
          JOIN invoice ON customer.CustomerId = invoice.CustomerId
          JOIN invoiceline ON invoice.InvoiceId = invoiceline.InvoiceId
      WHERE YEAR(InvoiceDate) >= 2010
      GROUP BY customer.CustomerId)
   SELECT FirstName,
          LastName,
          total_spent,
          CASE
              WHEN CUME_DIST() OVER (ORDER BY total_spent) > 0.7 THEN 'top'
              WHEN CUME_DIST() OVER (ORDER BY total_spent) < 0.31 THEN 'low'
              ELSE 'middle'
              END AS `customer_level`
   FROM customers
   ORDER BY total_spent DESC, LastName;






