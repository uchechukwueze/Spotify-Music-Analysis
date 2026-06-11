-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- Exploratory Data Analysis(EDA)
SELECT count(*) 
FROM spotify;

SELECT count(distinct artist) FROM spotify;

SELECT count(distinct album) FROM spotify;

SELECT distinct album_type FROM spotify;

SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;


SELECT *
FROM spotify
WHERE duration_min =0;


DELETE FROM spotify
WHERE duration_min =0;

SELECT *FROM spotify
WHERE duration_min =0;

-- Spotify is the most streams that songs are played on, followed by YouTube
SELECT 
distinct most_played_on,
count(most_played_on)
FROM spotify
GROUP BY distinct most_played_on;

-- Top 20 Artist on the spotify
SELECT 
distinct(artist),
count(artist)
FROM spotify
GROUP BY distinct(artist)
ORDER BY count(artist) DESC
LIMIT 20;

-- Track Analysis - Top 20 Track most played/visited
SELECT
distinct track,
count(track) 
FROM spotify
GROUP BY distinct track
ORDER BY count(track) DESC 
LIMIT 20;

-- --------------------------------
/*
(a) Data Analysis - Easy Category
1 Retrive the names of all tracked that have more than 1 billion streams
2 List  all albums along with their respective artists
3 Get the total number of comments for tracks where licensed = True
4 Find all tracks that belongs to the album type single
5 count the total number of tracks by each artist
*/

-- 1. Retrive the names of all tracked that have more than 1 billion streams
SELECT
track
FROM spotify
WHERE stream > 1000000000;

-- 2. List  all albums along with their respective artists

SELECT
distinct album,
artist
FROM spotify;

-- 3 Get the names of total number of comments for tracks where licensed = True
SELECT
track,
sum(comments) AS total_number_of_comments
FROM spotify
WHERE licensed = True
GROUP BY track;

-- 3.1 Get the total number of comments for tracks where licensed = True
SELECT
sum(comments) AS total_number_of_comments
FROM spotify
WHERE licensed = True;

-- 4. Find all tracks that belongs to the album type single
SELECT 
track
FROM spotify
WHERE album_type = 'single';

-- 5. count the total number of tracks by each artist
SELECT 
artist,
count(*) AS total_number_of_tracks
FROM spotify
GROUP BY artist
ORDER BY 2 DESC;

/*
(b) Data Analysis - Medium Level
1. Calculate the average danceability of tracks in each album
2. Find the top 5 tracks with the highest energy values
3. List all tracks along with their views and likes where official_video = True
4. For each album, calculate the total views of all associated tracks
5. Retrive the track names that have been streamed on Spotifty more than YouTube
*/

--  1. Calculate the average danceability of tracks in each album
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

--  2. Find the top 5 tracks with the highest energy values
SELECT
track,
MAX(energy)
FROM spotify
GROUP BY 1
ORDER BY 2
LIMIT 5;

--  3. List all tracks along with their views and likes where official_video = True
SELECT
track,
sum(views) as total_views,
sum(likes) as total_likes
FROM spotify
where official_video = 'true'
GROUP BY track;

--  4. For each album, calculate the total views of all associated tracks
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

--  5. Retrive the track names that have been streamed on Spotify more than YouTube
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

-- -------------------------------------------
-- Data Analysis - Advanced Level
-- ------------------------------------------
/*
1. Find the top 3 most_viewed tracks for each artist using windom functions
2. Write a query to find tracks where the liveness score is above the average
3. Use a WITH clause to calculate the difference btw the highest and lowesr energy values for tracks in each album
4. Find tracks where the energy-to-liveness ratio is greater than 1.2
5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using windon functions
*/

-- 1. Find the top 3 most_viewed tracks for each artist using windom functions
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

--2. Write a query to find tracks where the liveness score is above the average

SELECT
track,
liveness
FROM spotify
WHERE liveness >(select avg(liveness)from spotify) -- avg liveness = 0.19

-- 3. Use a WITH clause to calculate the difference btw the highest and lowesr energy values for tracks in each album

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

-- 4. Find tracks where the energy-to-liveness ratio is greater than 1.2
SELECT
track,
energy /liveness as energy_to_liveness_ratio
FROM spotify
WHERE energy /liveness > 1.2
ORDER BY 2 DESC;



