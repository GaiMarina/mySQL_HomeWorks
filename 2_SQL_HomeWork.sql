
-- 2_HomeWork_SQL – создание объектов, простые запросы выборки

USE HomeWorks;

# 1. Используя операторы языка SQL, создайте табличку “sales”. Заполните ее данными.

CREATE TABLE sales
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE NOT NULL,
    count_product INT UNSIGNED DEFAULT 0 NOT NULL 
);

INSERT INTO sales (order_date, count_product)
VALUES
	('2022-01-01', 156),
    ('2022-01-02', 180),
    ('2022-01-03', 21),
    ('2022-01-04', 124),
    ('2022-01-05', 341);

SELECT * FROM sales;


# 2. Для данных таблицы “sales” укажите тип заказа в зависимости от кол-ва:
#	 меньше 100 - Маленький заказ
#	 от 100 до 300 - Средний заказ
#	 больше 300 - Большой заказ

SELECT id 'id заказа', 
CASE
	WHEN count_product < 100
		THEN 'Маленький заказ'
	WHEN count_product BETWEEN 100 AND 300
		THEN 'Средний заказ'
	WHEN count_product > 300
		THEN 'Большой заказ'
	ELSE 'Не определено'
END AS 'Тип заказа'
FROM sales;


# 3. Создайте таблицу “orders”, заполните ее значениями. 
# 	 Покажите “полный” статус заказа, используя оператор CASE

CREATE TABLE orders
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id VARCHAR(40) NOT NULL,
    amount DECIMAL(11, 2) NOT NULL DEFAULT 0,
    order_status ENUM('OPEN', 'CLOSED', 'CANCELLED') NOT NULL
);

INSERT orders (employee_id, amount, order_status)
VALUES
	('e03', 15.00, 'OPEN'),
    ('e01', 25.50, 'OPEN'),
    ('e05', 100.70, 'CLOSED'),
    ('e02', 22.18, 'OPEN'),
    ('e04', 9.50, 'CANCELLED');

SELECT * FROM orders;

SELECT *, 
CASE
	WHEN order_status = 'OPEN'
		THEN 'Order is in open state'
	WHEN order_status = 'CLOSED'
		THEN 'Order is closed'
	WHEN order_status = 'CANCELLED'
		THEN 'Order is cancelled'
	ELSE 'Undefined'
END AS full_order_status
FROM orders;

# 4. Чем NULL отличается от 0?

/*
Значение NULL отличается от нуля (0), пустой строки или поля, содержащего пробелы.

В MySQL значение NULL означает неизвестное. 
"0", пустая строка, строка, содержащая пробелы и т.д. - это указанные значения.

Для числового поля разница в том, что 0 может быть результатом арифметической операции, 
в то время как NULL говорит о том, что значение просто не было указано.

Значение NULL не равно ни чему, даже само себе.

NULL как свойство поля читается как NULLABLE - 
т.е. значение для данного столбца необязательного для указания.
 
Выражение, содержащее NULL, всегда дает значение NULL, 
за исключением случаев, специально оговоренных в документации по операторам и функциям, 
присутствующим в выражении.
*/
