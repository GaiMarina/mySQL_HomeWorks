
# Урок 6. SQL – Транзакции. Временные таблицы, управляющие конструкции, циклы

/*
1. Создайте таблицу users_old, аналогичную таблице users. Создайте
процедуру, с помощью которой можно переместить любого (одного)
пользователя из таблицы users в таблицу users_old.
(использование транзакции с выбором commit или rollback – обязательно).
*/

# CREATE DATABASE 6_HomeWork;
# USE 6_HomeWork;
/*
-- Создаем users
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);

INSERT INTO users (id, firstname, lastname, email) VALUES 
(1, 'Reuben', 'Nienow', 'arlo50@example.org'),
(2, 'Frederik', 'Upton', 'terrence.cartwright@example.org'),
(3, 'Unique', 'Windler', 'rupert55@example.org'),
(4, 'Norene', 'West', 'rebekah29@example.net'),
(5, 'Frederick', 'Effertz', 'von.bridget@example.net'),
(6, 'Victoria', 'Medhurst', 'sstehr@example.net'),
(7, 'Austyn', 'Braun', 'itzel.beahan@example.com'),
(8, 'Jaida', 'Kilback', 'johnathan.wisozk@example.com'),
(9, 'Mireya', 'Orn', 'missouri87@example.org'),
(10, 'Jordyn', 'Jerde', 'edach@example.com');
*/

-- Создали users_old
DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);

DELIMITER //
DROP PROCEDURE IF EXISTS users_move//

CREATE PROCEDURE users_move(IN num INT)
BEGIN
START TRANSACTION;
INSERT INTO users_old SELECT * FROM users WHERE id = num;
DELETE FROM users WHERE id = num;
COMMIT;
END //

-- Вызвали процедуру переноса пользователя по id = 3
CALL users_move(3)//

DELIMITER ;

-- Проверяем изменения в таблицах
SELECT * FROM users_old;
SELECT * FROM users;

/*
2. Создайте хранимую функцию hello(), которая будет возвращать
приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00
функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00
функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 —
"Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
*/

DELIMITER //
DROP FUNCTION IF EXISTS hello//

CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
	DECLARE hour INT;
	SET hour = EXTRACT(HOUR FROM curtime());
	CASE
		WHEN hour BETWEEN 0 AND 5 THEN RETURN "Доброй ночи";
		WHEN hour BETWEEN 6 AND 11 THEN RETURN "Доброе утро";
		WHEN hour BETWEEN 12 AND 17 THEN RETURN "Добрый день";
		WHEN hour BETWEEN 18 AND 23 THEN RETURN "Добрый вечер";
	END CASE;
END//

-- Вызываем функцию, которая выводит приветствие в соответствии с временем суток.
SELECT curtime() AS 'Время', hello() AS 'Приветствие'//
DELIMITER ;
 -- ---------------------------------------------------------------------
/*
3. (по желанию)* Создайте таблицу logs типа Archive. Пусть при каждом
создании записи в таблицах users, communities и messages в таблицу logs
помещается время и дата создания записи, название таблицы,
Для решения задач используйте базу данных lesson_4
(скрипт создания, прикреплен к 4 семинару).
*/

SHOW ENGINES;

-- Таблица с типом archive
DROP TABLE IF EXISTS logs;
CREATE TABLE logs
(
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
    created_at DATETIME,
    table_name VARCHAR(30)
)
ENGINE = ARCHIVE;

-- Триггер для таблицы users
DROP TRIGGER IF EXISTS on_users;
delimiter //
CREATE TRIGGER on_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name)
	VALUES (now(), 'users');
END //
delimiter ;

/*
-- сообщества
DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150),
    INDEX communities_name_idx(name)
);

INSERT INTO `communities` (name) 
VALUES ('atque'), ('beatae'), ('est'), ('eum'), ('hic'), ('nemo'), ('quis'), ('rerum'), ('tempora'), ('voluptas');
*/

-- Триггер для таблицы communities
DROP TRIGGER IF EXISTS on_communities;
delimiter //
CREATE TRIGGER on_communities AFTER INSERT ON communities
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name)
	VALUES (now(), 'communities');
END //
delimiter ;

-- Триггер для таблицы messages
DROP TRIGGER IF EXISTS on_messages;
delimiter //
CREATE TRIGGER on_messages AFTER INSERT ON messages
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name)
	VALUES (now(), 'messages');
END //
delimiter ;

# DELETE FROM users WHERE firstname = 'Marina';

-- Вставляем значение для проверки логирования из users
INSERT INTO users (firstname, lastname, email)
VALUES ('Marina', 'Marinina', 'marinina@mail.ru');

SELECT * FROM users;
SELECT * FROM logs;

-- Добавляем значения для проверки логгирования из communities
INSERT INTO communities (name)
VALUES ('Marinina');

SELECT * FROM communities;
SELECT * FROM logs;

# DELETE FROM communities WHERE name = 'Marinina';
/*
-- Создаем таблицу messages
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (from_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);
*/

-- Добавляем значения для проверки логгирования из messages
INSERT INTO messages  (from_user_id, to_user_id, body, created_at) 
VALUES
(6, 4, 'MusinaMusinaMusina', now());

SELECT * FROM messages;
SELECT * FROM logs;
