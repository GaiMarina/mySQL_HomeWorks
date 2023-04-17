
-- 3_SQL_HomeWork 
-- Выборка данных, сортировка, агрегатные функции.

CREATE TABLE staff
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(100) NOT NULL,
    lastname VARCHAR(100) NOT NULL,
    post VARCHAR(100) NOT NULL,
    seniority TINYINT UNSIGNED NOT NULL,
    salary DECIMAL DEFAULT 0,
    age TINYINT UNSIGNED NOT NULL   
);

INSERT staff (firstname, lastname, post, seniority, salary, age)
VALUES 
	('Вася', 'Петров', 'Начальник', 40, 100000, 60),
    ('Петр', 'Власов', 'Начальник', 8, 70000, 30),
    ('Катя', 'Катина', 'Инженер', 2, 70000, 25),
    ('Саша', 'Сасин', 'Инженер', 12, 50000, 35),
    ('Иван', 'Иванов', 'Рабочий', 40, 30000, 59),
    ('Петр', 'Петров', 'Рабочий', 20, 25000, 40),
    ('Сидр', 'Сидоров', 'Рабочий', 10, 20000, 35),
    ('Антон', 'Антонов', 'Рабочий', 8, 19000, 28),
    ('Юрий', 'Юрков', 'Рабочий', 5, 15000, 25),
    ('Максим', 'Максимов', 'Рабочий', 2, 11000, 22),
    ('Юрий', 'Галкин', 'Рабочий', 3, 12000, 24),
    ('Людмила', 'Маркина', 'Уборщик', 10, 10000, 49);
    
SELECT * FROM staff;

# 1. Отсортируйте данные по полю заработная плата (salary) в порядке: убывания/возрастания

-- убывание
SELECT * FROM staff ORDER BY salary DESC;

-- возрастание
SELECT * FROM staff ORDER BY salary;

# 2. Выведите 5 максимальных заработных плат (salary)

-- сотрудники с максимальным зарплатами - 5 человек.
SELECT * FROM staff 
ORDER BY salary DESC
LIMIT 5;

-- 5 максимальных заработных плат, уникальные значения.
SELECT DISTINCT salary FROM staff 
ORDER BY salary DESC
LIMIT 5;

# 3. Посчитайте суммарную зарплату (salary) по каждой специальности (роst)

SELECT post, SUM(salary) total_post_salary 
FROM staff
GROUP BY post;

# 4. Найдите кол-во сотрудников со специальностью (post) «Рабочий» 
#    в возрасте от 24 до 49 лет включительно.

SELECT COUNT(*) 'Кол-во рабочих 24-49 лет' FROM staff
WHERE post = 'Рабочий' AND age BETWEEN 24 AND 49; 	-- 49 включительно

# 5. Найдите количество специальностей

SELECT COUNT(DISTINCT post) 'Количество специальностей' FROM staff;

# 6. Выведите специальности, у которых средний возраст сотрудников меньше 30 лет

SELECT post 'post_less_30' FROM staff
GROUP BY post
HAVING ROUND(AVG(age) < 30);
