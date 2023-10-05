-- create database twitter_db;

use twitter_db;

-- MYSQL Monty(Creador) SQL(Structured Query lenguage)
drop table if exists users;
create table users (
user_id INT AUTO_INCREMENT,
user_handle VARCHAR(50) NOT NULL UNIQUE,
email_adress VARCHAR(50) NOT NULL UNIQUE,
first_name VARCHAR (100) NOT NULL,
last_name VARCHAR (100) NOT NULL,
phonenumber CHAR(10) UNIQUE,
created_at TIMESTAMP NOT NULL DEFAULT (NOW()),
primary key(user_id)
);

insert into users(user_handle, email_adress, first_name, last_name, phonenumber)
values
("karlosvas","carlosvassan@gmail.com","Carlos","Vasquez","000000000"),
("pheralb","pheralb@gmail.com","Pablo","G","675455756"),
("anton","atonito@gmail.com","Antonio","Perez","675499756"),
("martasanch","martaperu@gmail.com","Marta","Sanchez","123499756"),
("Pedro","pedrus@gmail.com","Pedro","Cuervo","234234");

drop table if exists followers;
create table followers(
follower_id INT NOT NULL,
following_id INT NOT NULL,
foreign key(follower_id) references users(user_id),
foreign key(follower_id) references users(user_id),
primary key(follower_id, following_id)
);

alter table followers
add constraint check_folower_id
check(follower_id != following_id);

insert into followers(follower_id, following_id)
values
(1,2),
(2,1),
(3,1),
(4,3);

-- Las primary key restringen que se realice 2 veces la mismo operación
