use music_database;
select * from album2;

## Question set 1- Easy
## Q1.1 Who is the senior most employee besed on the job title?
     
select * from employee
order by levels desc
limit 1;

## Q1.2 Which countries have the most invioces?

select count(*) as count, billing_country
 from invoice
 group by billing_country
 order by count desc;
 
 ## Q1.3 What are top 3 values of total invoice?
 
 Select total
 from invoice
 order by total desc
 limit 3;
 ## Q1.4 Which city has the best customer? 
 ## We would like to throw a pramotional music festival in the city we made the most money.
 ## Write a query that returns one city that has highest sum of invoice totals. 
 ## Return the both the city name and sum of inoice totals.
 
 select  sum(total) as invoice_total, billing_city
 from invoice
 group by billing_city
 order by 1 desc
 limit 1;
 
 ## Q1.5 Who is the best customer? 
 ## The customer who has spent the most money we be decleared as the best customer.
 ## Write a query that return who has spent the most money.
 
  select c.customer_id, c.first_name, c.last_name, sum(i.total) as total
  from customer c 
  inner join invoice i 
  on c.customer_id = i.customer_id
  group by 1, 2, 3
  order by total desc
  limit 1;
  
  ## Question set 2 moderate
  
  ## Q2.1 Write query to return email, 
  .. first name , last name, & Genre of all rock music listeners.
  .. Return your list ordered alphabetically by email starting with A.
 with cte as 
 ( select distinct c.email, 
		 c.first_name , c.last_name, g.name
  from genre g 
  left join track t on g.genre_id = t.genre_id
  left join invoice_line il on t.track_id = il.track_id
  left join invoice i on il.invoice_id = i.invoice_id
  left join customer c on i.customer_id = c.customer_id
  where g.name = 'Rock' and c.email is not null 
  order by email)
  select email, first_name, last_name
  from cte
  
## Q2.2 Let's invite the artist who have written the most rock music in our dataset.
...Write query that returns the artist name and total count of top 10 rock bands.

select a.artist_id ,a.name, count(a.artist_id) as no_of_song
from artist a 
join album2 al on a.artist_id = al.artist_id
join track t on al.album_id = t.album_id
join genre g on t.genre_id = g.genre_id
where g.name like 'Rock' 
  group by 1, 2
  order by 3 desc
  limit 10;
  
  ## Q2.3 Return all the track names that have a song length longer than the avg. song length.
  .. Return the name and milliseconds for each track .
  ..Order by the song length with longest listed first.
  
 
  select name, milliseconds
  from track
  where milliseconds > (select avg(milliseconds) as avg_length from track)
  order by 2 desc;
  
  ## Question set 3 - Advance
  
  ## Q3.1 Found how munch amount spent by each customer on artist?
  ..Write a query to return customer name, artist name and total spent.
  
  with cte1 as
  (select a.artist_id, ar.name,
         sum(il.unit_price * il.quantity) as total
  from customer c 
  join invoice i on c.customer_id = i.customer_id
  join invoice_line il on i.invoice_id = il.invoice_id
  join track t on il.track_id = t.track_id
  join album2 a on t.album_id = a.album_id
  join artist ar on a.artist_id = ar.artist_id
  group by 1, 2
  order by 3 desc limit 1)
  
  select c.customer_id, c.first_name, c.last_name, ct.name,
         sum(il.unit_price * il.quantity) as total_spent
  from customer c 
  join invoice i on c.customer_id = i.customer_id
  join invoice_line il on i.invoice_id = il.invoice_id
  join track t on il.track_id = t.track_id
  join album2 a on t.album_id = a.album_id
  join cte1 ct on a.artist_id = ct.artist_id
  group by 1, 2, 3, 4
  order by 5 desc
  
  ## Q3.2 We want to find out most popular music genre for each country.
  ..We determine the most popular genre as the genre as highest amount of purchase.
  ..Write a query that returns each country along with the top genre .For countries where the maximum
  ..number of purchases is shared return all genre.
  
  with cte as
  (select count(il.quantity) as purchases, c.country, g.name, g.genre_id,
  row_number() over(partition by c.country order by count(il.quantity) desc) as rnk
  from customer c 
  join invoice i on c.customer_id = i.customer_id
  join invoice_line il on i.invoice_id = il.invoice_id
  join track t on il.track_id = t.track_id
  join genre g on t.genre_id = g.genre_id 
  group by 2,3,4
  order by 2 asc, 1 desc)
  select * from cte 
  where rnk = 1
  
 ## Q3.3 Write a query that determines the customer that has spent most on music 
 ..for each country.
 ..Write a query that returns the country along with the top customer and how much they spent
 ..For the countries where the top amount spent is shared, provide all customer who spent this amount.
with cte as 
( select sum(i.total) as total, c.country, c.first_name, c.last_name, 
 row_number() over(partition by c.country order by sum(i.total) desc) as rnk
 from customer c 
 left join invoice i on c.customer_id = i.customer_id
  group by 2,3,4
  order by 2,3 asc , 1 desc)
  select * from cte
  where rnk = 1
  

 


