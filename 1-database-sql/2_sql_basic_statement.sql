USE albums_db;
SHOW tables;
SELECT *
FROM albums
LIMIT 5;
SELECT COUNT(*)
FROM albums;
-- All albums by Pink Floyd:
SELECT artist,name album_name
FROM albums
WHERE artist = 'Pink Floyd';-- Pink Floyd
-- Year of Sgt Pepper's:
SELECT albums.name,release_date
FROM albums
WHERE albums.name LIKE '%Pepp%';
-- Genre for 'Nevermind'
SELECT albums.name,genre
FROM albums
WHERE albums.name LIKE '%Never%';
-- Released in 1990s:
DESCRIBE albums;
SELECT albums.name,release_date
FROM albums
WHERE release_date BETWEEN 1990 AND 1999;
-- Less than 20M certified sales?
SELECT albums.name,sales
FROM albums
WHERE sales BETWEEN 0 AND 20.0
ORDER BY sales DESC;