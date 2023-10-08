-- Desde la version 8 de MySQL
USE twitter_db;
-- Muestra toda la tabla de usuarios
SELECT * FROM twitter_db.users;
-- muestra todos los folowers y los folows de cada id.
SELECT follower_id, following_id FROM twitter_db.followers;
-- muestra los folowers_id de los que tengan el sigan al usuario con id 1.
SELECT follower_id FROM followers WHERE following_id = 1;

-- Top 3 usuarios con mayor número de seguidores.
SELECT following_id, count(follower_id) AS followers
FROM followers
group by following_id
order by followers desc
limit 3;

-- Top 3 usuarios con mayor número de seguidores + join
SELECT users.user_id, users.user_handle, users.first_name, following_id, count(follower_id) as followers
FROM followers
JOIN users on users.user_id = followers.following_id
GROUP BY following_id
ORDER BY followers desc
LIMIT 3;

-- Obtener el número de likes para cada tuit.
SELECT tweet_id, COUNT(*) as like_count
FROM tweet_likes
GROUP BY tweet_id;

-- Mostrar la tabla de tweets.
SELECT * FROM twitter_db.tweets;

-- ¿Cuantos tweets ha hecho un usuario?
SELECT user_id, COUNT(*) as tweet_count
FROM tweets
GROUP BY user_id;
    
-- Subconsultas
-- Obtener los tweets de los usuarios que tienen 2 seguidores.
SELECT tweet_id, tweet_text, user_id
FROM tweets
WHERE user_id IN (
    SELECT following_id
    FROM followers
    GROUP BY following_id
    HAVING COUNT(*) = 2
);

-- Delete
SET SQL_SAFE_UPDATES = 0;
DELETE FROM tweets;
DELETE FROM tweets WHERE tweet_id = 1;
DELETE FROM tweets WHERE user_id = 1;
DELETE FROM tweets WHERE LIKE '%example%';

-- UPDATE
UPDATE tweets SET num_coments = num_coments + 1 WHERE tweet_id = 4;

-- Remplzar texto
UPDATE tweets SET tweet_text = REPLACE(tweet_text, 'Twitter', 'X')
WHERE tweet_text LIKE '%Twitter%';

-- Relacion de likes.
SELECT * from tweet_likes;

-- Obetener el número de likes por tweet.
SELECT tweet_id, COUNT(*) AS like_count
FROM tweet_likes
GROUP BY tweet_id;

DROP TRIGGER IF EXISTS increase_follower_count;

-- TRIGGERS
-- Nuevo segidor
DELIMITER $$
CREATE TRIGGER increase_follower_count
AFTER INSERT ON followers
FOR EACH ROW
BEGIN
    UPDATE users SET follower_count = follower_count + 1
    WHERE user_id = NEW.following_id;
END $$
DELIMITER ;

-- Dejar de seguir
DELIMITER $$
CREATE TRIGGER decrese_follower_count
AFTER INSERT ON followers
FOR EACH ROW
BEGIN
    UPDATE users SET follower_count = follower_count - 1
    WHERE user_id = NEW.following_id;
END $$
DELIMITER ;
