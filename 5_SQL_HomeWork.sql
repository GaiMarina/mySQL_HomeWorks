
-- Урок 5. SQL – оконные функции

-- -------------------------------------------------

USE 4_SQL_HomeWork;

-- ---------------------------------------------------------------------------------------

# 1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия,
# город и пол), которые не старше 20 лет.

-- ---------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW les_20_users_info AS 
SELECT firstname,
	   lastname,
       p.hometown,
       p.gender
FROM users
JOIN `profiles` p
ON users.id = p.user_id
WHERE TIMESTAMPDIFF(YEAR, p.birthday, curdate()) <= 20;

SELECT *  FROM les_20_users_info;

-- ---------------------------------------------------------------------------------------

# 2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите
# ранжированный список пользователей, указав имя и фамилию пользователя, количество
# отправленных сообщений и место в рейтинге (первое место у пользователя с максимальным
# количеством сообщений) .
# (используйте DENSE_RANK)

-- ---------------------------------------------------------------------------------------

-- через VIEW
CREATE OR REPLACE VIEW users_msgs AS
SELECT users.id, 
	   CONCAT(firstname, ' ', lastname) AS 'name_surname',
       COUNT(messages.id) AS sent_msgs
FROM users
JOIN messages
ON users.id = messages.from_user_id
GROUP BY messages.from_user_id
ORDER BY sent_msgs DESC;

SELECT * FROM users_msgs;

SELECT 
	name_surname, sent_msgs,
	DENSE_RANK() OVER W AS `rank` 
FROM users_msgs
WINDOW w AS (ORDER BY sent_msgs DESC)
ORDER BY `rank`;

-- Через вложенные запросы.
SELECT from_user_id AS 'Отправитель',
	   (SELECT CONCAT(firstname, ' ', lastname) FROM users 
       WHERE users.id = from_user_id) AS 'Имя, Фамилия',
       COUNT(*) AS 'Количество сообщений',
       DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS 'Ранг'   
FROM messages
GROUP BY from_user_id
ORDER BY 'Ранг';

-- ---------------------------------------------------------------------------------------

# 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления
# (created_at) и найдите разницу дат отправления между соседними сообщениями,
# получившегося списка. (используйте LEAD или LAG)

-- ---------------------------------------------------------------------------------------

SELECT *,
	DATEDIFF(LEAD(created_at) OVER w, created_at) AS date_diff,
    TIMEDIFF(LEAD(created_at) OVER w, created_at) AS time_diff
FROM messages
WINDOW w AS (ORDER BY created_at)
ORDER BY created_at;

