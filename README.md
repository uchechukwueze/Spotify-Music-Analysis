# Spotify-Music-Analysis Using SQL
<img width="561" height="314" alt="Spotify" src="https://github.com/user-attachments/assets/e3f25932-0c09-4dd2-bf91-b79b653e72fb" />

### Buesiness Questions

#### Retrive the names of all tracked that have more than 1 billion streams
```sql
SELECT
track
FROM spotify
WHERE stream > 1000000000;
 ```
#### List  all albums along with their respective artists

```sql
SELECT
distinct album,
artist
FROM spotify;
```

#### Get the names of total number of comments for tracks where licensed = True

```sql
SELECT
track,
sum(comments) AS total_number_of_comments
FROM spotify
WHERE licensed = True
GROUP BY track;
```

#### Get the total number of comments for tracks where licensed = True
```sql
SELECT
sum(comments) AS total_number_of_comments
FROM spotify
WHERE licensed = True;
```

#### Find all tracks that belongs to the album type single
```sql
SELECT 
track
FROM spotify
WHERE album_type = 'single';
```

#### count the total number of tracks by each artist
```sql
SELECT 
artist,
count(*) AS total_number_of_tracks
FROM spotify
GROUP BY artist
ORDER BY 2 DESC;
```

#### Calculate the average danceability of tracks in each album

```sql
SELECT 
album,
track,
avg(danceability) AS average
FROM spotify
GROUP BY album, track;

SELECT 
album,
avg(danceability) AS average
FROM spotify
GROUP BY album, track
ORDER by average DESC;
```
```sql
Find the top 5 tracks with the highest energy values
SELECT
track,
MAX(energy)
FROM spotify
GROUP BY 1
ORDER BY 2
LIMIT 5;

```
### List all tracks along with their views and likes where official_video = True
```sql
SELECT
track,
sum(views) as total_views,
sum(likes) as total_likes
FROM spotify
where official_video = 'true'
GROUP BY track;
```

### For each album, calculate the total views of all associated tracks
```sql
SELECT 
distinct album,
track,
sum(views)
FROM spotify
GROUP BY album, track;

SELECT 
album,
track,
sum(views) as total_views
FROM spotify
GROUP BY 1,2
ORDER BY total_views DESC;
```

#### Retrive the track names that have been streamed on Spotify more than YouTube
```sql
SELECT * FROM
(select
	track,
	--most_played_on,
	 COALESCE(SUM(CASE WHEN most_played_on ='Youtube' THEN stream END),0) as steam_on_youtube,
	 COALESCE(SUM(CASE WHEN most_played_on ='Spotify' THEN stream END),0) as steam_on_spotify
from spotify
GROUP BY 1
) as t1
WHERE 
	steam_on_spotify > steam_on_youtube
	AND steam_on_youtube <> 0
```

#### Find the top 3 most_viewed tracks for each artist using windom functions
```sql
WITH rankings_artist
AS
(SELECT 
	artist,
	track,
	sum(views) as total_views,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as RANK
FROM spotify
GROUP BY 1, 2
ORDER BY 1, 3 DESC)
SELECT * FROM rankings_artist
WHERE rank <=3
```

```sql
#### Write a query to find tracks where the liveness score is above the average

SELECT
track,
liveness
FROM spotify
WHERE liveness >(select avg(liveness)from spotify) -- avg liveness = 0.19
```
```sql

#### Use a WITH clause to calculate the difference btw the highest and lowesr energy values for tracks in each album

WITH cte
AS
(SELECT 
album,
MAX(energy) as highest_energy,
MIN(energy) as lowest_energy
FROM spotify
GROUP BY 1)
SELECT
album,
highest_energy - lowest_energy
FROM cte
ORDER BY 2 DESC;
```

#### Find tracks where the energy-to-liveness ratio is greater than 1.2
```sql
SELECT
track,
energy /liveness as energy_to_liveness_ratio
FROM spotify
WHERE energy /liveness > 1.2
ORDER BY 2 DESC;
```


