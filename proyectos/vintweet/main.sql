-- Hacer un drop del database para reiniciarlo todo de nuevo.
DROP DATABASE IF EXISTS twitter_db;

-- Crear la base de datos
CREATE DATABASE twitter_db;

-- Usar la base de datos
USE twitter_db;

-- Crear la tabla de usuarios
CREATE TABLE users (
    user_id INT AUTO_INCREMENT,
    user_handle VARCHAR(50) NOT NULL UNIQUE,
    email_address VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phonenumber CHAR(10) UNIQUE,
    follower_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id)
);

-- Insertar datos en la tabla de usuarios
INSERT INTO users (user_handle, email_address, first_name, last_name, phonenumber)
VALUES
    ("karlosvas", "carlosvassan@gmail.com", "Carlos", "Vasquez", "000000000"),
    ("pheralb", "pheralb@gmail.com", "Pablo", "G", "675455756"),
    ("anton", "atonito@gmail.com", "Antonio", "Perez", "675499756"),
    ("martasanch", "martaperu@gmail.com", "Marta", "Sanchez", "123499756"),
    ("Pedro", "pedrus@gmail.com", "Pedro", "Cuervo", "234234");

-- Crear la tabla de seguidores
CREATE TABLE followers (
    follower_id INT NOT NULL,
    following_id INT NOT NULL,
    FOREIGN KEY (follower_id) REFERENCES users (user_id),
    FOREIGN KEY (following_id) REFERENCES users (user_id),
    PRIMARY KEY (follower_id, following_id)
);

-- Aplicando restricciones
ALTER TABLE followers
ADD CONSTRAINT check_follower_id
CHECK (follower_id != following_id);

-- Insertar datos en la tabla de seguidores
INSERT INTO followers (follower_id, following_id)
VALUES
    (1, 2),
    (2, 1),
    (3, 1),
    (4, 3),
    (5, 2);

CREATE TABLE tweets(
    tweet_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    tweet_text VARCHAR(500) NOT NULL,
    num_likes INT DEFAULT 0,
    num_retweets INT DEFAULT 0,
    num_coments INT DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT (NOW()),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    PRIMARY KEY (tweet_id)
);

-- Las primary key restringen que se realice 2 veces la mismo operación.

INSERT INTO tweets(user_id, tweet_text)
VALUES
(1, "!Este es el primer tweet de vintweet, soy karlosvas¡"),
(2, "Meet Trilogy, a database adapter to connect #RubyOnRails and Active Record clients to MySQL-compatible database servers.

Trilogy is:
Open source ✅
Designed for performance ✅
Flexible ✅
Easy to embed ✅ 

Try it out and let us know what you think!"),
(3, "Puedes escribir tus propios tweets"),
(5, "I like that"),
(4, "Me too"),
(1, "Start to repository "),
(1, "Esto es una copia de Twitter");

CREATE TABLE tweet_likes(
    user_id INT NOT NULL,
    tweet_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id),
    PRIMARY KEY (user_id, tweet_id)
);

INSERT INTO tweet_likes (user_id, tweet_id)
VALUES (1,3), (3,2), (1,4), (5,1), (1,2), (4,2), (4,1)
