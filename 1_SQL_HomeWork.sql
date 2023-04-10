
-- 1 Таблица с мобильными телефонами (mobile_phones).

CREATE DATABASE seminars;
USE seminars;
CREATE TABLE mobile_phones
(
	id int PRIMARY KEY auto_increment,
    product_name VARCHAR(20) NOT NULL,
    manufacturer VARCHAR(20) NOT NULL,
    product_count MEDIUMINT unsigned DEFAULT(0),
    price decimal unsigned DEFAULT(0)
);

INSERT INTO seminars.mobile_phones (product_name, manufacturer, product_count, price)
VALUES 
	('iPhone X', 'Apple', 3, 76000),
    ('iPhone 8', 'Apple', 2, 51000),
    ('Galaxy S9', 'Samsung', 2, 56000),
    ('Galaxy S8', 'Samsung', 1, 41000),
    ('P20 Pro', 'Huawei', 5, 36000);

SELECT * FROM seminars.mobile_phones;

-- 2 Название, производитель и цена для товаров, количество которых превышает 2.

SELECT product_name, manufacturer, price
FROM seminars.mobile_phones
WHERE product_count > 2;

-- 3 Весь ассортимент товаров марки “Samsung”.

SELECT * FROM seminars.mobile_phones
WHERE manufacturer = 'Samsung';

-- 4 С помощью регулярных выражений найти:
-- 4.1 Товары, в которых есть упоминание "Iphone".

SELECT * FROM seminars.mobile_phones
WHERE product_name LIKE '%Iphone%';

-- 4.2 Товары, в которых есть упоминание "Samsung".

SELECT * FROM seminars.mobile_phones
WHERE manufacturer LIKE '%Samsung%';
-- WHERE manufacturer RLIKE '\Samsung';

-- 4.3 Товары, в которых есть ЦИФРЫ.

SELECT * FROM seminars.mobile_phones
WHERE product_name RLIKE '\\d';
-- WHERE product_name RLIKE '[0-9]';

-- 4.4  Товары, в которых есть ЦИФРА "8" 

SELECT * FROM seminars.mobile_phones
WHERE product_name LIKE '%8%'
-- WHERE product_name RLIKE '\8';
