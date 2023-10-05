-- Desde la version 8 de MySQL
use twitter_db;
-- Muestra toda la tabla de usuarios
select * from twitter_db.users;
-- muestra todos los folowers y los folows de cada id.
select follower_id, following_id from twitter_db.followers;
-- muestra los folowers_id de los que tengan el sigan al usuario con id 1.
select follower_id from followers where following_id = 1;

-- Top 3 usuarios con mayor número de seguidores.
select following_id, count(follower_id) as followers
from followers
group by following_id
order by followers desc
limit 3;

-- Top 3 usuarios con mayor número de seguidores + join
select users.user_id, users.user_handle, users.first_name, following_id, count(follower_id) as followers
from followers
join users on users.user_id = followers.following_id
group by following_id
order by followers desc
limit 3;