======================================== 1.1 Первые запросы
SELECT *
FROM products;
----------------------------------------
SELECT name, price
FROM products;
----------------------------------------
SELECT *
FROM products
WHERE price < 3000;
----------------------------------------
SELECT name, price
FROM products
WHERE price >= 10000;
----------------------------------------
SELECT name
FROM products
WHERE count = 0;
----------------------------------------
SELECT name, price
FROM products
WHERE price <= 4000;
======================================== 1.2 Составные условия
SELECT *
FROM orders
WHERE status != 'cancelled';
----------------------------------------
SELECT id, sum
FROM orders
WHERE products_count >= 3;
----------------------------------------
SELECT *
FROM orders
WHERE status = 'cancelled';
----------------------------------------
SELECT *
FROM orders
WHERE status IN ('cancelled', 'returned');
----------------------------------------
SELECT *
FROM orders
WHERE sum >= 3000 OR products_count >= 3;
----------------------------------------
SELECT *
FROM orders
WHERE sum >= 3000 AND products_count < 3;
----------------------------------------
SELECT *
FROM orders
WHERE status = 'cancelled' AND sum BETWEEN 3000 AND 10000;
----------------------------------------
SELECT *
FROM orders
WHERE status = 'cancelled' AND NOT sum BETWEEN 3000 AND 10000;
======================================== 1.3 Порядок AND и OR
======================================== 1.4 Сортировка результатов
SELECT *
FROM products
ORDER BY price;
----------------------------------------
SELECT name, price
FROM products
ORDER BY price DESC;
----------------------------------------
SELECT *
FROM products
WHERE price >= 5000
ORDER BY price DESC;
----------------------------------------
SELECT name, count, price
FROM products
WHERE price < 3000
ORDER BY name;
----------------------------------------
SELECT last_name, first_name
FROM users
ORDER BY last_name, first_name;
----------------------------------------
SELECT *
FROM users
WHERE salary >= 40000
ORDER BY salary DESC, first_name;
----------------------------------------
SELECT *
FROM users
WHERE salary < 30000 AND salary != 0
ORDER BY birthday;
======================================== 1.5 Ограничение выборки
SELECT *
FROM orders 
WHERE status != 'cancelled'
ORDER BY sum DESC
LIMIT 5;
----------------------------------------
SELECT name, price
FROM products 
WHERE count > 0
ORDER BY price
LIMIT 3;
----------------------------------------
SELECT *
FROM orders 
WHERE sum >= 3000
ORDER BY date DESC
LIMIT 3;
----------------------------------------
SELECT *
FROM products
ORDER BY price
LIMIT 10, 5;
----------------------------------------
SELECT name, price
FROM products
WHERE count > 0
ORDER BY name
LIMIT 12, 6;
======================================== 2.1 Добавление данных
INSERT INTO orders (id, products, sum)
VALUES (6, 3, 3000);
----------------------------------------
INSERT INTO products (id, name, count, price)
VALUES (7, 'Xbox', 3, 30000);
----------------------------------------
INSERT INTO products (id, name, count, price)
VALUES (8, 'iMac 21', 0, 100100);
----------------------------------------
INSERT INTO users (id, first_name, last_name, birthday)
VALUES (9, 'Антон', 'Пепеляев', '1992-07-12');
----------------------------------------
INSERT INTO users
SET id = 10, first_name = 'Никита', last_name = 'Петров';
----------------------------------------
INSERT INTO products (id, name, count, price)
VALUES
(8, 'iPhone 7', 1, 59990),
(9, 'iPhone 8', 3, 64990),
(10, 'iPhone X', 2, 79900);
======================================== 2.2 Обновление данных
UPDATE products
SET name = 'iMac'
WHERE id = 7;
----------------------------------------
UPDATE users
SET salary = salary * 1.1
WHERE salary < 20000;
----------------------------------------
UPDATE orders
SET status = 'new'
WHERE status IS NULL;
----------------------------------------
UPDATE orders
SET amount = products_count * sum;
----------------------------------------
UPDATE orders
SET status = 'success'
WHERE id = 5;
----------------------------------------
UPDATE products
SET price = price * 1.05
ORDER BY price
LIMIT 5;
----------------------------------------
UPDATE products
SET price = price - 5000
ORDER BY price DESC
LIMIT 5;
----------------------------------------
UPDATE products
SET count = count + 40
WHERE id IN (3, 5);
======================================== 2.3 Удаление данных
DELETE
FROM visits;
----------------------------------------
DELETE
FROM products
WHERE count = 0;
----------------------------------------
DELETE
FROM cars
WHERE year <= 2010;
----------------------------------------
DELETE
FROM cars
WHERE country = 'KR' OR power < 80;
----------------------------------------
DELETE
FROM cars
WHERE (country = 'JP' AND power <= 80) OR (country = 'JP' AND power >= 130);

DELETE
FROM cars
WHERE country = 'JP' AND (power <= 80 OR power >= 130);

DELETE
FROM cars
WHERE country = 'JP' AND power NOT BETWEEN 81 AND 129;
----------------------------------------
TRUNCATE table cars;
======================================== 3.1 Создание простейших таблиц
CREATE TABLE users (
    id INT,
    first_name VARCHAR(50), 
    last_name VARCHAR(50)
);
INSERT INTO users (id, first_name, last_name)
VALUES
    (1, 'Дмитрий', 'Иванов'),
    (2, 'Анатолий', 'Белый'),
    (3, 'Денис', 'Давыдов');
----------------------------------------
CREATE TABLE orders (
    id INT,
    state VARCHAR(10), 
    amount INT
);
INSERT INTO orders (id, state, amount)
VALUES
    (1, 'new', 10000),
    (2, 'new', 3400),
    (3, 'delivery', 7300);
----------------------------------------
CREATE TABLE users (
    id INT,
    first_name VARCHAR(20), 
    last_name VARCHAR(50),
    birthday DATE
);
INSERT INTO users (id, first_name, last_name, birthday)
VALUES
    (1, 'Дмитрий', 'Иванов', '1995-08-12'),
    (2, 'Светлана', 'Демчук', '1993-07-08'),
    (3, 'Денис', 'Антонов', '1996-12-23');
----------------------------------------
CREATE TABLE messages (
    id INT,
    subject VARCHAR(100), 
    message TEXT,
    add_date DATETIME,
    is_public BOOL
);
INSERT INTO messages (id, subject, message, add_date, is_public)
VALUES
    (1, 'Первое сообщение', 'Это мое первое сообщение!', '2016-12-12 14:16:00', 1);
----------------------------------------
CREATE TABLE rating (
    id INT,
    car_id INT, 
    user_id INT,
    rating FLOAT
);
INSERT INTO rating (id, car_id, user_id, rating)
VALUES
    (1, 1, 1, 4.54),
    (2, 1, 2, 3.34),
    (3, 2, 3, 4.19),
    (4, 2, 11, 1.12);
======================================== 3.2 Числовые поля
CREATE TABLE products (
    id INT unsigned,
    name varchar(100), 
    count tINyINt unsigned,
    price MEDIUMINT unsigned
);
INSERT INTO products (id, name, count, price)
VALUES
    (1, 'Холодильник', 10, 50000),
    (2, 'Стиральная машина', 0, 23570),
    (3, 'Утюг', 3, 7300);
----------------------------------------
CREATE TABLE orders (
    id INT unsigned,
    product_id INT unsigned, 
    sale tINyINt unsigned,
    amount decimal(8, 2)
);
INSERT INTO orders (id, product_id, sale, amount)
VALUES
    (1, 245, 0, 230.50),
    (2, 17, 15, 999999.99),
    (3, 145677, 21, 1240.00);
----------------------------------------
CREATE TABLE films (
    id INT unsigned,
    name varchar(100), 
    rating float unsigned,
    country varchar(2)
);
INSERT INTO films (id, name, rating, country)
VALUES
    (1, 'Большая буря', 3.45, 'RU'),
    (2, 'Игра', 7.5714, 'US'),
    (3, 'Война', 10.0, 'RU');
----------------------------------------
CREATE TABLE files (
    id INT unsigned,
    filename varchar(255), 
    size BIGINT unsigned,
    filetype varchar(3)
);
INSERT INTO files (id, filename, size, filetype)
VALUES
    (1, 'big_archive.zip', 81604378624, 'zip'),
    (2, 'movie_37.mp4', 7838315315, 'mp4'),
    (3, 'music007.mp3', 5242880, 'mp3');
======================================== 3.3 Параметр ZEROFILL
======================================== 3.4 Строковые поля
CREATE TABLE users (
    id INT unsigned,
    first_name varchar(50),
    last_name varchar(60),
    bio text
);
INSERT INTO users (id, first_name, last_name, bio)
VALUES
    (1, 'Антон', 'Кулик', 'С отличием окончил 39 лицей.'),
    (2, 'Сергей', 'Давыдов', ''),
    (3, 'Дмитрий', 'Соколов', 'Профессиональный программист.');
----------------------------------------
CREATE TABLE books (
    id INT unsigned,
    name varchar(100),
    DESCriptiON varchar(1000),
    isbn varchar(13)
);
INSERT INTO books (id, name, DESCription, isbn)
VALUES
    (1, 'MySQL 5', 'Хорошая книга.', '5941579284'),
    (2, 'Изучаем SQL', 'Полезная книга.', '5932860510'),
    (3, 'Изучаем Python. 4-е издание', 'Подробная книга о Python.', '9785932861592');
----------------------------------------
SELECT *
FROM cars
WHERE mark = 'Nissan' AND year > 1990 AND power > 120;
----------------------------------------
CREATE TABLE apartments (
    id INT unsigned,
    image varchar(100),
    price INt unsigned,
    square tINyINt unsigned
);
INSERT INTO apartments (id, image, price, square)
VALUES
    (1, '/apartments/1/cover.jpg', 5250000, 90),
    (2, '/apartments/2/cover-3.jpg', 7500000, 103),
    (3, '', 2300000, 56);
----------------------------------------
SELECT mark, model, year
FROM cars
WHERE country = 'JP' OR mark = 'Peugeot'
ORDER BY year DESC;
----------------------------------------
CREATE TABLE files (
    id INT unsigned,
    file_url varchar(500),
    file_path varchar(200),
    size BIGINT unsigned
);
INSERT INTO files (id, file_url, file_path, size)
VALUES
    (1, 'http://archives.com/archives/big_archive.zip', 'files/2018/02/archive.zip', 81604378624),
    (2, 'http://movies.com/movies/movie.mp4', '', 0),
    (3, 'http://movies.com/best-songs/song.mp3', 'files/2018/03/song.mp3', 5242880);
======================================== 3.5 Дата и время
CREATE TABLE users (
    id INT unsigned,
    email varchar(100),
    date_joINed date,
    last_activity datetime
);
INSERT INTO users (id, email, date_joINed, last_activity)
VALUES
    (1, 'user1@domain.com', '2014-12-12', '2016-04-08 12:34:54'),
    (2, 'user2@domain.com', '2014-12-12', '2017-02-13 11:46:53'),
    (3, 'user3@domain.com', '2014-12-13', '2017-04-04 05:12:07');
----------------------------------------
CREATE TABLE calendar (
    id INT unsigned,
    user_id INT unsigned,
    doctOR_id INT unsigned,
    visit_date datetime
);
INSERT INTO calendar (id, user_id, doctOR_id, visit_date)
VALUES
    (1, 1914, 1, '2017-04-08 12:00:00'),
    (2, 12, 1, '2017-04-08 12:30:00'),
    (3, 4641, 2, '2017-04-09 09:00:00'),
    (4, 784, 1, '2017-04-08 13:00:00'),
    (5, 15, 2, '2017-04-09 10:00:00');
----------------------------------------
CREATE TABLE temperature (
    id INT unsigned,
    city_id INT unsigned,
    temperature tINyINT,
    wINd_speed tINyINT unsigned,
    mdate datetime
);
INSERT INTO temperature (id, city_id, temperature, wINd_speed, mdate)
VALUES
    (1, 456, 17, 7, '2017-02-08 12:00:00'),
    (2, 456, 19, 6, '2017-02-08 12:10:00'),
    (3, 456, 20, 6, '2017-02-08 12:20:00'),
    (4, 471, -7, 12, '2017-02-08 12:20:01'),
    (5, 44, -43, 17, '2017-02-08 12:23:12');
----------------------------------------
CREATE TABLE arrival (
    id INT unsigned,
    user_id INT unsigned,
    a_date date,
    a_time time
);
INSERT INTO arrival (id, user_id, a_date, a_time)
VALUES
    (1, 10, '2017-03-09', '08:45:41'),
    (2, 12, '2017-03-09', '08:46:12'),
    (3, 7, '2017-03-09', '08:53:01'),
    (4, 31, '2017-03-09', '09:01:17');
----------------------------------------
CREATE TABLE cars (
    id INT unsigned,
    mark varchar(20),
    model varchar(20),
    year year,
    mileage MEDIUMINT unsigned
);
INSERT INTO cars (id, mark, model, year, mileage)
VALUES
    (1, 'Toyota', 'Camry', '2015', 32000),
    (2, 'Mazda', 'CX-5', '2016', 17000),
    (3, 'Nissan', 'Patrol', '2016', 60000);
----------------------------------------
SELECT *
FROM cars
WHERE year = 2016 AND mileage < 50000
ORDER BY mileage;
======================================== 3.6 NULL
CREATE TABLE users (
    id INt unsigned NOT NULL,
    email varchar(100) NOT NULL
);
INSERT INTO users (id, email)
VALUES
    (1, 'user1@domain.com'),
    (2, 'user2@domain.com'),
    (3, 'user3@domain.com'),
    (4, 'user4@domain.com');
----------------------------------------
CREATE TABLE products (
    id INt unsigned NOT NULL,
    name varchar(120) NOT NULL,
    category_id INt unsigned,
    price decimal(10, 2) NOT NULL
);
INSERT INTO products (id, name, category_id, price)
VALUES
    (1, 'Подгузники (12 шт)', 3, 700.00),
    (2, 'Подгузники (24 шт)', 3, 1250.00),
    (3, 'Спиннер', NULL, 250.40),
    (4, 'Пюре слива', 4, 47.50);
----------------------------------------
SELECT name, count, price
FROM products
WHERE category_id IS NULL
ORDER BY price;
======================================== 3.7 NULL в SELECT запросах
SELECT *
FROM users
WHERE sex != 'm' OR sex IS NULL;
======================================== 3.8 BOOL, ENUM, SET
CREATE TABLE articles (
    id INt unsigned NOT NULL,
    name varchar(80),
    text text,
    state enum('draft', 'cORrection', 'public')
);
INSERT INTO articles (id, name, text, state)
VALUES
    (1, 'Новое в PythON 3.6', '', 'draft'),
    (2, 'Оптимизация SQL запросов', 'При больших объемах данных ...', 'cORrection'),
    (3, 'Транзакции в MySQL', 'По долгу службы мне приходится ...', 'public');
----------------------------------------
CREATE TABLE rooms (
    id INt unsigned NOT NULL,
    number tINyINt unsigned NOT NULL,
    beds enum('1+1', '2+1', '2+2') NOT NULL,
    additional SET('conditioner', 'bar', 'fridge', 'wifi')
);
INSERT INTO rooms (id, number, beds, additional)
VALUES
    (1, 10, '1+1', 'conditioner,bar,wifi'), 
    (2, 12, '2+1', ''), 
    (3, 24, '2+2', 'fridge,bar,wifi');
----------------------------------------
SELECT id, first_name, last_name, birthday
FROM users
WHERE pers_INfo = false OR pers_INfo IS NULL
ORDER BY birthday;
----------------------------------------
SELECT name, price, country
FROM products
WHERE country IN ('RU', 'UA') AND count > 0
ORDER BY country, price;
----------------------------------------
SELECT name, price, country
FROM products
WHERE (fINd_IN_SET('RU', country) OR fINd_IN_SET('BY', country)) AND category_id IS NOT NULL
ORDER BY price DESC;
----------------------------------------
SELECT first_name, last_name, birthday, roles
FROM users
WHERE fINd_IN_SET('manager', roles) AND sex = 'm' AND active = true
ORDER BY last_name, first_name;
----------------------------------------
CREATE TABLE orders (
    id INT unsigned NOT NULL,
    user_id INT unsigned NOT NULL, 
    amount decimal(10, 2),
    created datetime NOT NULL,
    state enum('new', 'cancelled', 'IN_progress', 'delivered', 'completed'),
    options SET('pack', 'fittINg', 'call', 'INtercom')
);
INSERT INTO orders (id, user_id, amount, created, state, options)
VALUES
    (456, 763, 14299.00, '2018-02-01 17:45:59', 'completed', 'pack,call'),
    (457, 1987, 249.50, '2018-02-01 18:23:04', 'delivered', 'pack,INtercom'),
    (459, 78, 2300.12, '2018-02-01 22:12:09', 'IN_progress', '');
----------------------------------------
SELECT mark, model, year, power
FROM cars
WHERE
    country = 'JP'
    AND mark = 'Nissan'
    AND year BETWEEN 2010 AND 2016
    AND sold = false
    AND dealer_id IS NOT NULL
ORDER BY power;
======================================== 3.9 "TRUE" и "FALSE" в SELECT запросах
======================================== 3.10 Значения по умолчанию
CREATE TABLE orders (
    id INT unsigned NOT NULL,
    user_id INT unsigned NOT NULL, 
    amount MEDIUMINT unsigned NOT NULL DEFAULT 0,
    created datetime NOT NULL,
    state enum('new', 'cancelled', 'IN_progress', 'delivered', 'completed') NOT NULL DEFAULT 'new'
);
INSERT INTO orders (id, user_id, amount, created, state)
VALUES
    (1, 56, 5400, '2018-02-01 17:46:59', 'new'),
    (2, 90, 249, '2018-02-01 19:13:04', 'new'),
    (3, 78, 2200, '2018-02-01 22:43:09', 'new');
----------------------------------------
CREATE TABLE users (
    id INT unsigned NOT NULL,
    first_name varchar(20) NOT NULL, 
    last_name varchar(20) NOT NULL, 
    patronymic varchar(20) NOT NULL DEFAULT '', 
    is_active bool DEFAULT true,
    is_superuser bool DEFAULT false
);
INSERT INTO users (id, first_name, last_name, patronymic, is_active, is_superuser)
VALUES
    (1, 'Дмитрий', 'Иванов', '', true, false),
    (2, 'Анатолий', 'Белый', 'Сергеевич', true, true),
    (3, 'Андрей', 'Крючков', '', false, false);
----------------------------------------
CREATE TABLE products (
    id INt unsigned NOT NULL,
    category_id INt unsigned DEFAULT NULL,
    name varchar(100) NOT NULL,
    count tINyINt unsigned NOT NULL DEFAULT 0,
    price decimal(10, 2) NOT NULL DEFAULT 0.00
);
INSERT INTO products (id, category_id, name, count, price)
VALUES
    (1, 1, 'Кружка', 5, 45.90),
    (2, 17, 'Фломастеры', 0, 78.00),
    (3, NULL, 'Сникерс', 12, 50.80);
----------------------------------------
CREATE TABLE logs (
    date datetime NOT NULL DEFAULT current_timestamp,
    browser varchar(500) NOT NULL DEFAULT '',
    is_bot bool NOT NULL DEFAULT false
);
INSERT INTO logs (date, browser, is_bot)
VALUES
    ('2018-03-19 19:50:01', 'Chrome 64.0.1.417' , false),
    ('2018-03-19 19:55:11', 'Firefox 55 (yANDex bot)' , true),
    ('2018-03-19 19:56:12', 'Chrome 63.0.0.471' , false);
----------------------------------------
CREATE TABLE reviews (
    id INt unsigned NOT NULL,
    user_id INt unsigned NOT NULL,
    date datetime NOT NULL DEFAULT current_timestamp,
    course enum('python', 'sql', 'all') NOT NULL DEFAULT 'all',
    text text NOT NULL,
    public bool NOT NULL DEFAULT false
);
INSERT INTO reviews (id, user_id, date, course, text, public)
VALUES
    (1, 817, '2018-01-11 19:50:01', 'python', 'Это прекрасная возможность получить новые очки в программировании. Доступное объяснение позволяет без проблем изучить желаемый материал', true),
    (2, 1289, '2018-02-16 08:55:11', 'python', 'Проект на мой взгляд отличный: 1. Короткие видеоролики без воды 2. Интересные задачи и практика 3. Очень быстрая обратная связь', true),
    (3, 2914, '2018-03-19 12:56:12', 'all', 'Хорошая затея. Но проект ещё нуждается в развитии.', true);
======================================== 4.1 Первичный ключ
CREATE TABLE users (
    id INt unsigned NOT NULL PRIMARY KEY,
    first_name varchar(50), 
    last_name varchar(50), 
    birthday date DEFAULT NULL
);
INSERT INTO users (id, first_name, last_name, birthday)
VALUES
    (1, 'Дмитрий', 'Иванов', NULL),
    (2, 'Анатолий', 'Белый', NULL),
    (3, 'Денис', 'Давыдов', '1995-09-08');
----------------------------------------
CREATE TABLE orders (
    id INt unsigned NOT NULL PRIMARY KEY auto_INcrement,
    state varchar(8), 
    amount decimal(8, 2)
);
INSERT INTO orders (state, amount)
VALUES
    ('new', 1000.50),
    ('new', 3400.10),
    ('delivery', 7300.00);
----------------------------------------
CREATE TABLE passports (
    series varchar(4) NOT NULL,
    number varchar(6) NOT NULL, 
    user_id INt unsigned NOT NULL,
    date_issue date,
    PRIMARY KEY (series, number)
);
INSERT INTO passports (series, number, user_id, date_issue)
VALUES
    (3206, 147345, 15, '2006-08-12'),
    (3216, 147345, 234, '2016-09-23'),
    (2405, 147345, 1, '2015-01-07'),
    (5411, 147345, 15, '2008-03-03');
----------------------------------------
CREATE TABLE files (
    id INt unsigned NOT NULL PRIMARY KEY auto_INcrement,
    film_id INt unsigned NOT NULL,
    size BIGINT unsigned,
    filename varchar(100)
);
INSERT INTO files (film_id, size, filename)
VALUES
    (356, 28668906700, 'silicon_valley_s02_1080p.zip'),
    (4514, 2684354560, 'dunkirk.mp4'),
    (87145, 734003200, 'milk.mp4');
----------------------------------------
SELECT *
FROM products
WHERE price >= 5000
ORDER BY id DESC;
----------------------------------------
SELECT id, name
FROM products
WHERE id % 2 = 0
ORDER BY price;
----------------------------------------
UPDATE users
SET first_name = 'Дмитрий'
WHERE id = 7;
----------------------------------------
DELETE
FROM orders
WHERE id IN (3, 4, 7);
======================================== 4.2 Уникальный индекс
CREATE TABLE clients (
    id INt unsigned NOT NULL PRIMARY KEY auto_INcrement,
    first_name varchar(50) NOT NULL, 
    last_name varchar(50) NOT NULL, 
    email varchar(100) NOT NULL, 
    passport varchar(10) NOT NULL,
    UNIQUE KEY email (email),
    UNIQUE KEY passport (passport)
);

CREATE TABLE clients (
    id INt unsigned NOT NULL PRIMARY KEY auto_INcrement,
    first_name varchar(50) NOT NULL, 
    last_name varchar(50) NOT NULL, 
    email varchar(100) NOT NULL unique, 
    passport varchar(10) NOT NULL unique
);
----------------------------------------
CREATE TABLE passports (
    id INt unsigned NOT NULL PRIMARY KEY auto_INcrement,
    user_id INt unsigned NOT NULL, 
    series varchar(4) NOT NULL, 
    number varchar(6) NOT NULL, 
    state enum('active', 'expired') NOT NULL DEFAULT 'active',
    UNIQUE KEY passport (series, number)
);
----------------------------------------
CREATE TABLE posts (
    id INt unsigned NOT NULL PRIMARY KEY auto_INcrement,
    user_id INt unsigned NOT NULL, 
    name varchar(100) NOT NULL, 
    pub_date datetime DEFAULT NULL, 
    slug varchar(50) NOT NULL,
    UNIQUE KEY uslug (user_id, slug)
);
----------------------------------------
CREATE TABLE products (
    id INt unsigned NOT NULL PRIMARY KEY auto_INcrement,
    category_id INt unsigned DEFAULT NULL, 
    name varchar(100) NOT NULL, 
    slug varchar(50) NOT NULL, 
    ean13 varchar(13) NOT NULL unique,
    UNIQUE KEY category_slug (category_id, slug)
);
======================================== 4.3 Обычные индексы
CREATE TABLE orders (
    id INt unsigned NOT NULL PRIMARY KEY auto_INcrement,
    user_id INt unsigned NOT NULL, 
    state varchar(8) NOT NULL DEFAULT 'new', 
    amount mediumINt unsigned NOT NULL DEFAULT 0,
    index user_id (user_id),
    index state (state)
);
----------------------------------------
CREATE TABLE products (
    id INt unsigned NOT NULL PRIMARY KEY auto_INcrement,
    category_id INt unsigned DEFAULT NULL, 
    name varchar(100) NOT NULL, 
    count tINyINt unsigned NOT NULL DEFAULT 0, 
    price decimal(10, 2) NOT NULL DEFAULT 0.00,
    index category_id (category_id),
    index price (price)
);
----------------------------------------
CREATE TABLE passports (
    id INt unsigned NOT NULL PRIMARY KEY auto_INcrement,
    user_id INt unsigned NOT NULL, 
    series varchar(4) NOT NULL, 
    number varchar(6) NOT NULL, 
    state enum('active', 'expired') NOT NULL DEFAULT 'active',
    UNIQUE KEY passport (series, number),
    index series (series),
    index number (number)
);
----------------------------------------
CREATE TABLE orders (
    id INt unsigned NOT NULL PRIMARY KEY auto_INcrement,
    user_id INt unsigned NOT NULL, 
    city_id INt unsigned NOT NULL, 
    state enum('new', 'cancelled', 'delivered', 'completed') NOT NULL DEFAULT 'new', 
    amount mediumINt unsigned NOT NULL DEFAULT 0,
    index maIN_search (city_id, state),
    index user_id (user_id)
);
======================================== 4.4 Добавление и удаление индексов
CREATE INDEX category_id ON products (category_id);
----------------------------------------
CREATE INDEX base_query ON calendar (city_id, date);
----------------------------------------
DROP INDEX series ON passports;
DROP INDEX number ON passports;
CREATE UNIQUE INDEX series_number ON passports (series, number);
----------------------------------------
DROP INDEX category_id ON products;
======================================== 5.1 Добавление и удаление столбцов
ALTER TABLE articles
ADD COLUMN state enum('draft', 'cORrection', 'public') NOT NULL DEFAULT 'draft';
----------------------------------------
ALTER TABLE articles
DROP COLUMN state;
----------------------------------------
ALTER TABLE products
ADD COLUMN stock_place varchar(6) NOT NULL DEFAULT '';
----------------------------------------
ALTER TABLE users
ADD COLUMN birthday date DEFAULT NULL,
ADD COLUMN last_visit datetime NOT NULL DEFAULT current_timestamp,
ADD COLUMN is_active bool NOT NULL DEFAULT true,
ADD COLUMN experience mediumINt unsigned NOT NULL DEFAULT 0;
----------------------------------------
ALTER TABLE films
ADD COLUMN rating FLOAT NOT NULL DEFAULT 0;

UPDATE films
SET rating = (imdb + kINopoisk) / 2;
======================================== 5.2 Изменение столбцов
ALTER TABLE products
MODIFY price MEDIUMINT UNSIGNED NOT NULL DEFAULT 0;
----------------------------------------
ALTER TABLE twitts
MODIFY message VARCHAR(280) NOT NULL;
----------------------------------------
ALTER TABLE orders
MODIFY state ENUM('new', 'delivery', 'completed', 'cancelled', 'awaitINg_payment') NOT NULL DEFAULT 'new';
----------------------------------------
ALTER TABLE users
CHANGE name first_name VARCHAR(20) NOT NULL DEFAULT '',
ADD COLUMN last_name VARCHAR(20) NOT NULL DEFAULT '';
----------------------------------------
ALTER TABLE passports
MODIFY series VARCHAR(4) NOT NULL,
MODIFY number VARCHAR(6) NOT NULL;
CREATE UNIQUE INDEX passport ON passports (series, number);


ALTER TABLE passports
MODIFY series VARCHAR(4) NOT NULL,
MODIFY number VARCHAR(6) NOT NULL,
ADD UNIQUE INDEX passport (series, number)
----------------------------------------
ALTER TABLE logs
MODIFY date DATETIME(3) NOT NULL;
======================================== 5.3 Изменение таблицы
RENAME TABLE category TO categories;
----------------------------------------
RENAME TABLE
    wp_users TO blog_users,
    wp_posts TO blog_posts,
    wp_comments TO blog_comments;
======================================== 6.1 Поиск с помощью LIKE
SELECT *
FROM users
WHERE last_name LIKE 'а%'
ORDER BY last_name, first_name;
----------------------------------------
SELECT domain
FROM domains
WHERE domain LIKE '%.ru'
ORDER BY created;
----------------------------------------
SELECT domain
FROM domains
WHERE domain LIKE '%.___'
ORDER BY domain;
----------------------------------------
SELECT *
FROM cars
WHERE number LIKE '_1__ор%' AND mark = 'FORd' AND color IN ('зеленый', 'желтый');
----------------------------------------
UPDATE wINes
SET price = price - 1
WHERE price LIKE '%00';
----------------------------------------
SELECT *
FROM cars
WHERE mark LIKE 'BMW' AND mark NOT LIKE bINary 'BMW';
======================================== 6.2 Полнотекстовый поиск
CREATE TABLE products (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    count SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    price INTEGER UNSIGNED NOT NULL DEFAULT 0,
    sizes SET('32','34','36','38','40','42','44','46','48','50','52','M','L','S','XL','XS','2XL','4XL') NULL,
    FULLTEXT index name(name)
);

SELECT id, name, price
FROM products
WHERE
    match (name) agaINst ('+джинсы +mango' IN boolean mode)
    AND (fINd_IN_SET('36', sizes) OR fINd_IN_SET('38', sizes))
    AND count > 0;
----------------------------------------
CREATE TABLE fORum (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    subject VARCHAR(255) NULL,
    authOR_id INTEGER NULL,
    post TEXT NULL,
    FULLTEXT index fORum_text(subject, post)
);

SELECT id, subject
FROM fORum 
WHERE MATCH (subject, post) AGAINST ('ошибка проблема');
----------------------------------------
SELECT id, subject
FROM fORum 
WHERE MATCH (subject, post) AGAINST ('ошибк* проблем*' IN boolean mode);
----------------------------------------
SELECT *
FROM products
WHERE match (name) agaINst ('джинсы жилет -mango' IN boolean mode);
----------------------------------------
SELECT id, name, price
FROM products
WHERE match (name) agaINst ('"Джинсы Mango"' IN boolean mode)
ORDER BY price;
----------------------------------------
SELECT id, name, price
FROM products
WHERE
    (match (name) agaINst ('+джинсы +mango' IN boolean mode)
     OR match (name) agaINst ('+юбка +mango' IN boolean mode))    
    AND count > 0
ORDER BY price;
======================================== 7.1 Математические функции
SELECT id, abs(temperature) AS temperature
FROM experiments
WHERE temperature < -10 OR temperature > 10;
----------------------------------------
SELECT name, round(rating, 2) AS rating
FROM films
ORDER BY rating DESC
LIMIT 5;
----------------------------------------
SELECT id, floOR(amount * (100 - personal_sale) / 100) AS final_amount
FROM bills;
----------------------------------------
SELECT *, round(INitial_sum * POW((1 + percent / 100), years), 2) AS final_sum
FROM deposits;
----------------------------------------
SELECT id, first_name, email
FROM users
WHERE id % 3 = 0;
----------------------------------------
SELECT id, comments, ceil(comments / 10) AS pages
FROM posts;
======================================== 7.2 Строковые функции
SELECT name, price
FROM products
WHERE char_length(name) BETWEEN 5 AND 10
ORDER BY name;
----------------------------------------
SELECT user_id, concat(series, number) AS passport
FROM passports
ORDER BY user_id;
----------------------------------------
SELECT user_id, CONCAT_WS(' ', lpad(series, 4, 0), lpad(number, 6, 0)) AS passport
FROM passports
ORDER BY series, number;
----------------------------------------
SELECT id, CONCAT_WS(' ', last_name, first_name, patronymic) AS name
FROM users
WHERE patronymic != ''
ORDER BY last_name, first_name, patronymic;
----------------------------------------
SELECT *
FROM users
WHERE age >= 18 AND last_name LIKE ('%ова')
ORDER BY age, last_name;
----------------------------------------
SELECT id, left(passport, 4) AS series, right(passport, 6) AS number
FROM users
WHERE passport IS NOT NULL;
----------------------------------------
UPDATE products
SET name = trim(name);
----------------------------------------
UPDATE domains
SET domain = substr(domain, 1, char_length(domain) - 1)
WHERE domain LIKE ('%.');

UPDATE domains
SET domain = TRIM(TRAILING '.' FROM domain);
----------------------------------------
ALTER TABLE users
ADD COLUMN first_name varchar(50) NOT NULL DEFAULT '',
ADD COLUMN last_name varchar(50) NOT NULL DEFAULT '';

UPDATE users
SET
    first_name = trim(substrINg_index(name, ' ', 1)),
    last_name = trim(substrINg_index(name, ' ', -1));    
--  first_name = trim(substr(name, 1, locate(' ', trim(name)))),
--  last_name = trim(substr(name, locate(' ', trim(name)) + 1, char_length(name)));

ALTER TABLE users
DROP COLUMN name;
======================================== 7.3 Функции даты
SELECT *
FROM tasks
WHERE planned_date > now()
ORDER BY planned_date;
----------------------------------------
SELECT first_name, last_name, date_format(birthday, '%d.%m.%Y') AS user_birthday
FROM users
WHERE year(birthday) = 1994
ORDER BY birthday;
----------------------------------------
SELECT *
FROM visits
WHERE date BETWEEN '2017-06-22 12:00:00' AND '2017-06-22 12:59:59'
ORDER BY date DESC;

SELECT *
FROM visits 
WHERE DATE(date) = '2017-06-22' AND HOUR(date) = 12
ORDER BY date DESC;
----------------------------------------
UPDATE calendar
SET visit_date = DATE_ADD(visit_date, INterval 90 mINute)
WHERE visit_date >= '2017-05-14 13:00:00' AND date(visit_date) = '2017-05-14';
----------------------------------------
SELECT user_id, date_format(DATE_ADD(date, INterval 3 hour), '%d.%m.%Y %H:%i') AS visit_date
FROM visits
ORDER BY date;
----------------------------------------
SELECT last_name, first_name, birthday
FROM drivers
WHERE sex = 'm' AND birthday + INterval 18 year < '2018-08-08'
ORDER BY last_name, first_name;
----------------------------------------
SELECT id, user_id, amount, date_format(date, '%d.%m.%Y %H:%i') AS date
FROM payments
WHERE year(date) = 2017 AND month(date) = 3
ORDER BY date DESC
LIMIT 5;

SELECT id, user_id, amount, date_format(date, '%d.%m.%Y %H:%i') AS date
FROM payments
WHERE EXTRACT(YEAR_MONTH FROM date) = 201703
ORDER BY date DESC
LIMIT 5;
----------------------------------------
SELECT *
FROM users
WHERE dayname(birthday) IN ('saturday', 'sunday')
ORDER BY birthday DESC;
======================================== 7.4 Сортировка по дате (в исходной таблице)
SELECT id, date_format(date, '%d.%m.%Y') AS date
FROM table
ORDER BY table.date;
-- (NOT) ORDER BY table.date
======================================== 8.1 COUNT, MIN, MAX, AVG
SELECT count(*) AS women
FROM users
WHERE sex = 'w' AND age < 30;
----------------------------------------
SELECT sum(amount) AS INcome
FROM orders
WHERE EXTRACT(YEAR_MONTH FROM date) = 201501 AND status = 'success';
----------------------------------------
SELECT max(amount) AS max_losses
FROM orders
WHERE status = 'cancelled';
----------------------------------------
SELECT round(avg(amount), 2) AS avg_check
FROM orders
WHERE status = 'success' AND year(date) = 2015;
----------------------------------------
SELECT floOR(avg(age)) AS age, count(*) AS count
FROM clients
WHERE sex = 'm';
----------------------------------------
SELECT date_format(mIN(date), '%d.%m.%Y') AS date
FROM orders
WHERE status = 'cancelled';
----------------------------------------
SELECT count(*) AS users
FROM users
WHERE activity_date BETWEEN '2018-04-08 12:36:17' - INterval 5 mINute AND '2018-04-08 12:36:17';

SELECT COUNT(*) AS users
FROM users
WHERE activity_date >= "2018-04-08 12:36:17" - INTERVAL 5 MINUTE;
----------------------------------------
SELECT ceil(sum(amount * 0.06)) AS tax
FROM transactions
WHERE no_tax = false AND directiON = 'IN' AND EXTRACT(YEAR_MONTH FROM date) IN (201701, 201702, 201703);
======================================== 8.2 GROUP BY
SELECT sex, count(*) AS members
FROM users
GROUP BY sex;
----------------------------------------
SELECT age, count(*) AS clients
FROM users
GROUP BY age
ORDER BY age DESC;
----------------------------------------
SELECT category_id, round(avg(price), 2) AS avg_price
FROM products
WHERE count > 0
GROUP BY category_id
ORDER BY avg_price;
----------------------------------------
SELECT year(date) AS year, round(sum(amount), 2) AS INcome
FROM orders
WHERE status = 'success'
GROUP BY year(date)
ORDER BY year;
----------------------------------------
SELECT year(date) AS year, month(date) AS month, round(sum(amount), 2) AS INcome, count(*) AS orders
FROM orders
WHERE status = 'success'
GROUP BY year(date), month(date)
ORDER BY year, month;
======================================== 8.3 HAVING и WHERE
SELECT category_id, sum(count) AS products
FROM products
GROUP BY category_id
HAVING products > 0
ORDER BY products;
----------------------------------------
SELECT year(date) AS year, month(date) AS month, sum(amount) AS amount
FROM deals
GROUP BY year(date), month(date)
HAVING amount < 300000;
----------------------------------------
SELECT driver_id, round(avg(abs(diff))) AS avg_diff 
FROM bus_logs
GROUP BY driver_id
HAVING avg_diff >= 30;
----------------------------------------
SELECT user_id, count(*) AS deals, sum(amount) AS sum_amount, max(amount) AS max_amount
FROM deals
WHERE status = 'closed'
GROUP BY user_id
HAVING deals >= 3;
======================================== 9.1 Объединение с помощью UNION
SELECT *
FROM bank_transactions
UNION
SELECT *
FROM cashbox_transactions;
----------------------------------------
SELECT date_format(date, '%d.%m.%y') AS date, amount, 'bank' AS payment_type
FROM bank_transactions
WHERE client_id = 56
UNION
SELECT date_format(date, '%d.%m.%y') AS date, amount, 'cash' AS payment_type
FROM cashbox_transactions
WHERE client_id = 56;
----------------------------------------
SELECT id * 10 + 1 AS id, first_name, last_name, age, NULL AS birthday, sex
FROM users
UNION
SELECT id * 10 + 2 AS id, substrINg_index(name, ' ', 1) AS first_name, substrINg_index(name, ' ', -1) AS last_name, NULL AS age, birthday, sex
FROM members; 
----------------------------------------
SELECT lower(left(number, 6)) AS number, cast(right(number, 2) AS unsigned) AS region, mark, model
FROM cars
UNION
SELECT lower(number) AS number, 39 AS region, mark, model
FROM region39
UNION
SELECT lower(left(number, 6)) AS number, cast(regiON AS unsigned) AS region, mark, model
FROM avto
UNION
SELECT lower(left(number, 6)) AS number, cast(right(number, 2) AS unsigned) AS region, substrINg_index(car, ' ', 1) AS mark, 
substrINg_index(car, ' ', -1) AS model
FROM autos;
======================================== 9.2 Объединение с помощью UNION: сортировка
SELECT id, category_id, date, text, 'opened' AS status
FROM advs
WHERE user_id = 45
UNION
SELECT id, category_id, date, text, 'closed' AS status
FROM closed_advs
WHERE user_id = 45
ORDER BY date, id;
----------------------------------------
SELECT date, amount, 'bank' AS pt
FROM bank_transactions
UNION
SELECT date, amount, 'cash' AS pt
FROM cashbox_transactions
UNION
SELECT date, amount, 'paypal' AS pt
FROM paypal_transactions
ORDER BY date DESC;
----------------------------------------
(SELECT id, name, rating, 'Action' AS genre 
FROM games g1
WHERE category_id = 1
ORDER BY rating DESC
LIMIT 2)
UNION
(SELECT id, name, rating, 'RPG' AS genre
FROM games g2
WHERE category_id = 2
ORDER BY rating DESC
LIMIT 2)
UNION
(SELECT id, name, rating, 'Adventure' AS genre
FROM games
WHERE category_id = 3
ORDER BY rating DESC
LIMIT 2)
UNION
(SELECT id, name, rating, 'Strategy' AS genre
FROM games
WHERE category_id = 4
ORDER BY rating DESC
LIMIT 2)
UNION
(SELECT id, name, rating, 'Shooter' AS gere
FROM games
WHERE category_id = 5
ORDER BY rating DESC
LIMIT 2)
ORDER BY rating DESC, id;


SELECT 
    id, name, rating, 
    CASE
        WHEN category_id=1 THEN 'Action'
        WHEN category_id=2 THEN 'RPG'
        WHEN category_id=3 THEN 'Adventure'
        WHEN category_id=4 THEN 'Strategy'
        WHEN category_id=5 THEN 'Shooter'
    END AS genre
 FROM (
    SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY category_id 
           ORDER BY rating DESC, id) AS place
    FROM games
) p
WHERE place < 3 AND category_id BETWEEN 1 AND 5
ORDER BY rating DESC, id;
======================================== 9.3 Объединение с помощью UNION: группировка
SELECT type, sum(amount) AS sum_amount
FROM (SELECT amount, 'bank' AS type
    FROM bank_transactions
    UNION
    SELECT amount, 'cash' AS type
    FROM cashbox_transactions
    UNION
    SELECT amount, 'paypal' AS type
    FROM paypal_transactions) t
GROUP BY type
ORDER BY sum_amount;
----------------------------------------
SELECT year(date) AS year, month(date) AS month, sum(amount) AS month_amount
FROM (SELECT date, amount
    FROM bank_transactions
    UNION
    SELECT date, amount
    FROM cashbox_transactions
    UNION
    SELECT date, amount
    FROM paypal_transactions) t
GROUP BY year(date), month(date)
ORDER BY year, month;
----------------------------------------
SELECT sum(amount) AS all_money
FROM (SELECT amount
    FROM bank_transactions
    UNION
    SELECT amount
    FROM cashbox_transactions
    UNION
    SELECT amount
    FROM paypal_transactions) t;
======================================== 9.4 Отношение один к одному
SELECT u.id, u.first_name, u.last_name, ud.bio
FROM users AS u, users_details AS ud
WHERE u.id = ud.id;
----------------------------------------
SELECT p.id, p.name, pd.DESCription
FROM products AS p, products_details AS pd
WHERE p.id = pd.product_id
ORDER BY p.price;
----------------------------------------
SELECT u.id, u.first_name, u.last_name
FROM users AS u, users_p AS up
WHERE u.id = up.id AND u.date_joINed >= '2016-01-02 00:00:00' AND left(up.series, 2) = '32'
ORDER BY u.last_name;
----------------------------------------
UPDATE users AS u, users_details AS ud
SET
    u.email = 'karINa.n@domain.com',
    ud.last_name = 'Некифорова'
WHERE u.id = ud.id AND u.id = 8;
----------------------------------------
UPDATE products AS p, products_details AS pd
SET pd.DESCriptiON = ''
WHERE p.id = pd.product_id AND p.active = false;
----------------------------------------
DELETE FROM products AS p
WHERE p.active = false OR count = 0;
----------------------------------------
-- Иногда нужно удалить данные из одной таблицы, основываясь на условиях другой.
-- Для этого в конструкции DELETE предусмотрен специальный оператор USING.
DELETE FROM users_details
    USING users JOIN users_details
    WHERE 
    users_details.id = users.id AND 
    users.active = false;
======================================== 9.5 Внешний ключ
CREATE TABLE users_data (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    bio text,
    FOREIGN KEY (id)  REFERENCES users(id)
)
----------------------------------------
CREATE TABLE products_details (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    product_id INT UNSIGNED NOT NULL UNIQUE KEY,
    DESCriptiON text,
    FOREIGN KEY (product_id)  REFERENCES products(id)
)
----------------------------------------
INSERT INTO users (first_name, last_name)
VALUES ('Антон', 'Дмитриев');
INSERT INTO users_details (id, bio)
VALUES (last_INsert_id(), 'Антон родился в 1993 году.');
----------------------------------------
INSERT INTO users_details (id, bio)
VALUES (15,  'Антон родился в 1993 году.');

UPDATE users_details
SET bio = 'Василиса Кац родилась в 1995 году.'
WHERE id = 4;
======================================== 9.6 Отношения один-ко-многим
SELECT p.name, p.price, c.name category
FROM products AS p, categories AS c
WHERE p.category_id = c.id
ORDER BY p.name;
----------------------------------------
SELECT u.last_name, u.first_name, sum(d.amount) AS total
FROM users AS u, deals AS d
WHERE u.id = d.user_id
GROUP BY u.last_name, u.first_name
ORDER BY total DESC;
----------------------------------------
SELECT date_format(o.date, '%d.%m.%Y') AS date, o.amount, u.last_name, u.first_name
FROM orders AS o, users AS u
WHERE o.user_id = u.id AND status = 'completed'
ORDER BY o.date;
----------------------------------------
SELECT c.name category, count(*) products
FROM products AS p, categories AS c
WHERE p.category_id = c.id
GROUP BY c.name
ORDER BY category;
----------------------------------------
SELECT u.last_name, u.first_name, date_format(visit_date, '%H:%i') AS visit_time
FROM users AS u, calendar AS c
WHERE u.id = c.client_id AND c.doctOR_id = 9 AND date(visit_date) = '2017-04-17'
ORDER BY visit_time;
----------------------------------------
SELECT o.*
FROM orders AS o, users AS u
WHERE o.user_id = u.id AND u.sex = 'w' AND age >= 18 AND EXTRACT(YEAR_MONTH FROM date) = 201702
ORDER BY o.amount;
----------------------------------------
SELECT u.id, u.last_name, u.first_name
FROM arrival AS a, users AS u
WHERE a.user_id = u.id AND EXTRACT(YEAR_MONTH FROM a_date) = 201703 AND a_time > '09:00:00'
GROUP BY u.id, u.last_name, u.first_name;
----------------------------------------
SELECT id, name
FROM categories
WHERE parent_id = (SELECT id FROM categories WHERE name = 'Напитки' AND parent_id IS NULL)
ORDER BY name;
----------------------------------------
SELECT p.id, p.name, c.name AS category, b.name AS brAND
FROM products AS p, brANDs AS b, categories AS c
WHERE p.brAND = b.id AND p.category = c.id AND p.count > 0
ORDER BY p.price, p.id;
----------------------------------------
SELECT p.id, p.name, p.price
FROM products AS p, brANDs AS b, categories AS c
WHERE p.brAND = b.id AND p.category = c.id
    AND p.count > 0
    AND b.name LIKE 'mango'
    AND c.name IN ('Джинсы', 'Юбки')
ORDER BY p.price, p.id;
----------------------------------------
SELECT p.id, p.name, p.price, c.name AS category
FROM categories AS c , products AS p
WHERE c.id = p.category_id
    AND (c.parent_id = (SELECT id FROM categories WHERE name = 'Напитки') OR c.id = 5)
ORDER BY category, p.name;
----------------------------------------
SELECT b.id, b.name, b.price, concat(a.first_name, ' ', a.last_name) AS authOR
FROM books AS b, authORs AS a
WHERE b.authOR_id = a.id AND b.name LIKE '%MySQL%'
ORDER BY b.name;
======================================== 9.7 Создание связей один-ко-многим
ALTER TABLE artists
ADD COLUMN genre_id INT UNSIGNED,
ADD FOREIGN KEY (genre_id) REFERENCES genres (id);
----------------------------------------
ALTER TABLE products
ADD FOREIGN KEY (category_id) REFERENCES categories (id);
----------------------------------------
CREATE TABLE calendar (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    doctOR_id INT UNSIGNED NOT NULL,
    client_id INT UNSIGNED NOT NULL,
    visit_date datetime NOT NULL,
    FOREIGN KEY (doctOR_id) REFERENCES users(id),
    FOREIGN KEY (client_id) REFERENCES users(id)
);
----------------------------------------
INSERT INTO calendar (doctOR_id, client_id, visit_date)
VALUES 
    (7, 2, '2017-05-20 12:30:00'),
    (7, 2, '2017-05-21 12:30:00'),
    (7, 2, '2017-05-22 12:30:00'),
    (7, 2, '2017-05-23 12:30:00'),
    (7, 2, '2017-05-24 12:30:00');
======================================== 9.8 JOIN
SELECT p.id, p.name, p.price, cats.name AS category
FROM products AS p
JOIN categories AS cats ON p.category_id = cats.id
WHERE cats.parent_id IS NULL;
----------------------------------------
SELECT a.name, g.name AS genre
FROM artists AS a
JOIN genres AS g ON g.id = a.genre_id
WHERE a.is_group = true
ORDER BY genre, a.name;
----------------------------------------
SELECT g.id, g.name, count(*) AS artists
FROM artists AS a
JOIN genres AS g ON g.id = a.genre_id
GROUP BY g.id, g.name
ORDER BY artists DESC, g.name;
----------------------------------------
SELECT ci.name, c.name AS country, ci.population
FROM countries AS c
JOIN cities AS ci ON ci.country = c.id
WHERE ci.populatiON >= 1000000 AND fINd_IN_SET('Europe', c.pw)
ORDER BY ci.populatiON DESC;
----------------------------------------
SELECT c.name AS category, sum(count) AS products
FROM categories AS c
JOIN products AS p ON p.category = c.id
GROUP BY category
HAVING products > 0
ORDER BY category;
----------------------------------------
INSERT INTO genres (id, name)
VALUES (6, 'Rap');
INSERT INTO artists (id, name, genre_id, is_group)
VALUES (11, 'EmINem', 6, false);
======================================== 9.9 Понимание JOIN
SELECT e.first_name, e.last_name, r.name AS role
FROM employees AS e
LEFT JOIN roles AS r ON r.id = e.role_id
WHERE e.active = true
ORDER BY e.last_name, e.first_name;
----------------------------------------
SELECT g.name AS genres, count(a.id) AS artists
FROM genres AS g
LEFT JOIN artists AS a ON a.genre_id = g.id
GROUP BY genres
ORDER BY g.name;
----------------------------------------
SELECT c.name AS category, ifNULL(sum(p.count), 0) AS products
FROM categories AS c
LEFT JOIN products AS p ON p.category = c.id
GROUP BY c.name
ORDER BY c.name;
----------------------------------------
SELECT p.name, p.price, c.name AS category
FROM products AS p
LEFT JOIN categories AS c ON c.id = p.category_id
ORDER BY p.name;
----------------------------------------
SELECT r.name, count(e.active) AS employees
FROM roles AS r
LEFT JOIN employees AS e ON e.role_id = r.id
WHERE e.active = true OR e.active IS NULL
GROUP BY r.name
ORDER BY employees DESC, r.name;
======================================== 9.10 Понимание JOIN, часть 2
SELECT a.id AS authOR_id, b.id AS book_id, a.last_name, a.first_name, b.name
FROM books AS b
LEFT JOIN authORs AS a ON a.id = b.authOR_id
UNION
SELECT a.id AS authOR_id, b.id AS book_id, a.last_name, a.first_name, b.name
FROM books AS b
RIGHT JOIN authORs AS a ON a.id = b.authOR_id
ORDER BY authOR_id, book_id;
----------------------------------------
SELECT countries.name AS country, cities.name AS city
FROM countries
LEFT JOIN cities ON cities.country = countries.id
UNION
SELECT countries.name AS country, cities.name AS city
FROM countries
RIGHT JOIN cities ON cities.country = countries.id
ORDER BY country, city;
======================================== 9.11 Выборка из трех и более таблиц
SELECT u.last_name, u.first_name, r.name AS role, d.name AS department
FROM users AS u
LEFT JOIN roles AS r ON r.id = u.role_id
LEFT JOIN departments AS d ON d.id = u.department_id
ORDER BY u.last_name, u.first_name;
----------------------------------------
SELECT c.id, ma.name AS mark, mo.name AS model, c.price
FROM cars AS c
LEFT JOIN models AS mo ON mo.id = c.model_id
LEFT JOIN marks AS ma ON ma.id = mo.mark_id
ORDER BY c.price DESC;
----------------------------------------
SELECT ma.name AS mark, sum(c.price) AS sum
FROM cars AS c
LEFT JOIN models AS mo ON mo.id = c.model_id
LEFT JOIN marks AS ma ON ma.id = mo.mark_id
GROUP BY mark
ORDER BY mark;
----------------------------------------
SELECT s.id, s.name, al.name AS album, ar.name AS artist
FROM songs AS s
LEFT JOIN albums AS al ON al.id = s.album_id
LEFT JOIN artists AS ar ON ar.id = al.artist_id
LEFT JOIN genres AS g ON g.id = ar.genre_id
WHERE al.year BETWEEN 2008 AND 2010 AND g.name IN ('Rock', 'Metal')
ORDER BY s.name;
----------------------------------------
SELECT g.name, count(*) AS songs
FROM songs AS s
LEFT JOIN albums AS al ON al.id = s.album_id
LEFT JOIN artists AS ar ON ar.id = al.artist_id
LEFT JOIN genres AS g ON g.id = ar.genre_id
GROUP BY g.name
ORDER BY g.name;
----------------------------------------
SELECT date_format(ca.date, '%H:%i') AS time, concat(m.first_name, ' ', m.last_name) AS manager, concat(cl.first_name, ' ', cl.last_name) AS client, co.name AS company, SEC_TO_TIME(ca.duration_sec) AS duration
FROM calls AS ca
LEFT JOIN managers AS m ON m.id = ca.manager_id
LEFT JOIN clients AS cl ON cl.id = ca.client_id
LEFT JOIN companies AS co ON co.id = cl.company_id
WHERE date(ca.date) = '2018-04-05'
ORDER BY ca.date, duration;
----------------------------------------
SELECT co.name AS company, SEC_TO_TIME(ifNULL(sum(ca.duration_sec), 0)) AS duration
FROM companies AS co
LEFT JOIN clients AS cl ON cl.company_id = co.id
LEFT JOIN calls AS ca ON ca.client_id = cl.id
LEFT JOIN managers AS m ON m.id = ca.manager_id
GROUP BY company
ORDER BY duration;
----------------------------------------
SELECT m.first_name, m.last_name, time_format(SEC_TO_TIME(avg(duration_sec)), '%H:%i:%s') AS avg_duration
FROM calls AS ca
LEFT JOIN managers AS m ON m.id = ca.manager_id
LEFT JOIN clients AS cl ON cl.id = ca.client_id
LEFT JOIN companies AS co ON co.id = cl.company_id
WHERE co.name = 'Cloud ComputINg'
GROUP BY m.id
ORDER BY avg_duratiON DESC;
======================================== 9.12 Ссылочная целостность
-- ON DELETE RESTRICT
-- Удалите категории «Молочные продукты» и «Мясо» вместе с товарами.
DELETE FROM products
WHERE category_id IN (2, 17);
DELETE FROM categories
WHERE id IN (2, 17);
----------------------------------------
-- ON DELETE SET NULL
-- Удалите категории «Молочные продукты» и «Мясо» без удаления товаров.
DELETE FROM categories
WHERE id IN (2, 17);
----------------------------------------
-- ON DELETE CASCADE
-- Удалите категории «Молочные продукты» и «Мясо» вместе с товарами.
DELETE FROM categories
WHERE id IN (2, 17);
----------------------------------------
UPDATE products
SET category_id = 19 WHERE id = 19;
UPDATE products
SET category_id = 18 WHERE id IN (3, 4, 9);

DELETE FROM categories
WHERE id = 3;
DELETE FROM products
WHERE category_id = 2;
DELETE FROM categories
WHERE id = 2;
======================================== 9.13 Отношения многие ко многим
SELECT u.id, u.first_name, u.last_name
FROM users AS u
LEFT JOIN users_roles AS ur ON ur.user_id = u.id
LEFT JOIN roles AS r ON r.id = ur.role_id
WHERE r.name = 'Программист'
ORDER BY u.last_name;
----------------------------------------
SELECT r.name AS role, count(*) AS members
FROM users AS u
LEFT JOIN users_roles AS ur ON ur.user_id = u.id
LEFT JOIN roles AS r ON r.id = ur.role_id
WHERE r.name IS NOT NULL
GROUP BY r.name
ORDER BY r.name;
----------------------------------------
SELECT u.id, u.first_name, u.last_name
FROM users AS u
LEFT JOIN users_roles AS ur ON ur.user_id = u.id
LEFT JOIN roles AS r ON r.id = ur.role_id
WHERE r.name IS NOT NULL
GROUP BY u.id
HAVING count(r.name) > 1
ORDER BY u.id;
----------------------------------------
SELECT u.id, u.first_name, u.last_name
FROM users AS u
LEFT JOIN users_roles AS ur ON ur.user_id = u.id
LEFT JOIN roles AS r ON r.id = ur.role_id
WHERE r.name IS NULL
ORDER BY u.id;
----------------------------------------
DELETE FROM users_roles
WHERE user_id = 2 AND role_id = 1;
INSERT INTO users_roles (user_id, role_id)
VALUES
    (9, 1),
    (10, 3);
----------------------------------------
SELECT u.id, u.first_name, u.last_name, r.name AS role
FROM users AS u
LEFT JOIN users_rp AS urp ON urp.user_id = u.id
LEFT JOIN roles AS r ON r.id = urp.role_id
LEFT JOIN projects AS p ON p.id = urp.project_id
WHERE p.name = 'Сайт оконный'
ORDER BY u.last_name;
----------------------------------------
SELECT o.id, count(p.count) AS products, sum(p.price) AS amount
FROM orders AS o
LEFT JOIN orders_details AS od ON o.id = od.order_id
LEFT JOIN products AS p ON p.id = od.product_id
LEFT JOIN users AS u ON u.id = o.user_id
WHERE o.status = 'success'
GROUP BY o.id
ORDER BY amount;
----------------------------------------
SELECT o.id, o.status, count(p.name) AS products
FROM orders AS o
LEFT JOIN orders_details AS od ON o.id = od.order_id
LEFT JOIN products AS p ON p.id = od.product_id
LEFT JOIN users AS u ON u.id = o.user_id
WHERE o.status = 'success'
GROUP BY o.id, o.status
HAVING products = 0
ORDER BY o.id;
----------------------------------------
SELECT distINct s.id, s.name, al.name AS album, ar.name AS artist, al.year
FROM songs AS s
LEFT JOIN albums AS al ON al.id = s.album_id
LEFT JOIN artists AS ar ON ar.id = al.artist_id
LEFT JOIN artists_genres AS ag ON ag.artist_id = ar.id
LEFT JOIN genres AS g ON g.id = ag.genre_id
WHERE al.year >= 2008 AND g.name IN ('Rock', 'Metal')
ORDER BY al.year, s.id;
----------------------------------------
SELECT p.id, p.name, count(p.name) AS sold, sum(p.price) AS total
FROM orders AS o
LEFT JOIN orders_details AS od ON o.id = od.order_id
LEFT JOIN products AS p ON p.id = od.product_id
LEFT JOIN users AS u ON u.id = o.user_id
WHERE o.status = 'success'
GROUP BY p.id, p.name
ORDER BY sold DESC, total DESC
LIMIT 5;
----------------------------------------
SELECT p.id, p.name, p.price
FROM orders AS o
LEFT JOIN orders_details AS od ON o.id = od.order_id
LEFT JOIN products AS p ON p.id = od.product_id
LEFT JOIN users AS u ON u.id = o.user_id
WHERE o.status = 'new' AND u.id = 10
ORDER BY p.id;
----------------------------------------
SELECT u.id, u.last_name, u.first_name, sum(p.price) AS value
FROM orders AS o
LEFT JOIN orders_details AS od ON o.id = od.order_id
LEFT JOIN products AS p ON p.id = od.product_id
LEFT JOIN users AS u ON u.id = o.user_id
WHERE o.status = 'success'
GROUP BY u.id
ORDER BY value DESC
LIMIT 5;
----------------------------------------
DELETE FROM orders_details
WHERE order_id = 13 AND product_id = 4;
INSERT INTO orders_details (order_id, product_id)
VALUES (13, 2);
----------------------------------------
SELECT shops.name AS shop, s.quantity
FROM stock AS s
LEFT JOIN shops ON shops.id = s.shop_id
LEFT JOIN models AS m ON m.id = s.model_id
LEFT JOIN colors AS c ON c.id = s.color_id
WHERE m.vendOR_code = 'EN1345' AND c.name = 'розовый' AND s.size = 39 AND s.quantity > 0
ORDER BY s.quantity;
======================================== 10.1 Простые вложенные запросы
SELECT id, name
FROM categories
WHERE id IN (
    SELECT distINct category
    FROM products
    WHERE count > 0
)
ORDER BY name;
----------------------------------------
SELECT *
FROM users
WHERE id IN (
    SELECT user_id
    FROM orders
    WHERE amount = (SELECT max(amount) FROM orders WHERE status = 'completed') AND status = 'completed'
    )
ORDER BY id;
----------------------------------------
SELECT p.id, p.name, p.price
FROM products AS p
LEFT JOIN categories AS c ON c.id = p.category
WHERE c.name = 'Джинсы' AND p.price > (
    SELECT avg(price)
    FROM products AS p
    LEFT JOIN categories AS c ON c.id = p.category
    WHERE c.name = 'Джинсы'
    )
ORDER BY p.price, p.id;
======================================== 10.2 IN, ANY, ALL
SELECT p.name, p.price
FROM products AS p
LEFT JOIN categories AS c ON c.id = p.category_id
WHERE c.name = 'Овощи' AND p.price > any (
    SELECT p.price
    FROM products AS p
    LEFT JOIN categories AS c ON c.id = p.category_id
    WHERE c.name = 'Фрукты'    
)
ORDER BY p.name;
----------------------------------------
SELECT p.name, p.count
FROM products AS p
LEFT JOIN categories AS c ON c.id = p.category_id
WHERE c.name = 'Фрукты' AND p.count < all (
    SELECT p.count
    FROM products AS p
    LEFT JOIN categories AS c ON c.id = p.category_id
    WHERE c.name = 'Овощи'    
)
ORDER BY p.name;
======================================== 10.3 Ключевое слово EXISTS
SELECT c.id, c.name
FROM categories AS c
WHERE exists (SELECT * FROM products AS p WHERE p.category = c.id AND p.count > 0)
ORDER BY c.name;
----------------------------------------
SELECT * FROM users WHERE NOT EXISTS (
    SELECT user_id FROM users_roles WHERE users.id=users_roles.user_id
);


SELECT u.id, u.first_name, u.last_name
FROM users AS u
LEFT JOIN users_roles AS ur ON ur.user_id = u.id
LEFT JOIN roles AS r ON ur.user_id = r.id
WHERE ur.user_id IS NULL
ORDER BY u.id;
----------------------------------------
SELECT name, album_id
FROM songs
WHERE exists (SELECT * FROM albums WHERE songs.album_id = albums.id AND year = 2008)
ORDER BY name;
======================================== 10.4 Запросы, возвращающие несколько столбцов
SELECT p.id, p.name, p.price
FROM products AS p
LEFT JOIN old_prices AS op ON op.product_id = p.id
WHERE (p.id, p.price) != (op.product_id, op.price)
ORDER BY p.id;
----------------------------------------
SELECT *
FROM people AS p
WHERE (p.first_name, p.last_name, p.age) IN (SELECT * FROM suspects);
----------------------------------------
SELECT id, first_name, last_name
FROM people
WHERE first_name NOT IN (SELECT first_name FROM first_names)
    OR last_name NOT IN (SELECT last_name FROM last_names)
ORDER BY last_name;
======================================== 10.5 Подзапросы в конструкции FROM
SELECT id, name, rating,
    CASE
        WHEN category_id=1 THEN 'Action'
        WHEN category_id=2 THEN 'RPG'
        WHEN category_id=3 THEN 'Adventure'
        WHEN category_id=4 THEN 'Strategy'
        WHEN category_id=5 THEN 'Shooter'
    END AS genre
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY rating DESC, id) AS place
    FROM games) AS t
WHERE category_id <= 5 AND place <= 2
ORDER BY rating, id
LIMIT 5, 5;


SELECT * FROM (
    (SELECT id, name, rating, 'Action' AS genre FROM games
    WHERE category_id = 1
    ORDER BY rating DESC LIMIT 2)
    UNION
    (SELECT id, name, rating, 'RPG' AS genre FROM games
    WHERE category_id = 2
    ORDER BY rating DESC LIMIT 2)
    UNION
    (SELECT id, name, rating, 'Adventure' AS genre FROM games
    WHERE category_id = 3
    ORDER BY rating DESC LIMIT 2)
    UNION
    (SELECT id, name, rating, 'Strategy' AS genre FROM games
    WHERE category_id = 4
    ORDER BY rating DESC LIMIT 2)
    UNION
    (SELECT id, name, rating, 'Shooter' AS genre FROM games
    WHERE category_id = 5
    ORDER BY rating DESC LIMIT 2)
) AS top_games
ORDER BY rating, id
LIMIT 5, 5;
----------------------------------------
SELECT *
FROM
(SELECT date, amount, 'bank' AS payment_type
    FROM bank_transactions
    UNION
    SELECT date, amount, 'cash' AS payment_type
    FROM cashbox_transactions
    UNION
    SELECT date, amount, 'paypal' AS payment_type
    FROM paypal_transactions
    ORDER BY date DESC
    LIMIT 3) AS t
ORDER BY date;
----------------------------------------
SELECT distINct last_name, first_name, fn.sex
FROM first_names AS fn, last_names AS ln
WHERE fn.sex = ln.sex
ORDER BY fn.sex, last_name, first_name;
======================================== 10.6 Подзапросы в конструкции INSERT
INSERT IGNORE INTO closed_advs
(SELECT id, user_id, category_id, text, date FROM advs WHERE closed = true)
----------------------------------------
REPLACE INTO cached_cars (
    SELECT c.id, concat(ma.name, ' ', mo.name, ', ', c.color) AS car, c.price
    FROM cars AS c
    LEFT JOIN models AS mo ON mo.id = c.model_id
    LEFT JOIN marks AS ma ON ma.id = mo.mark_id
    ORDER BY c.id)
----------------------------------------
SELECT *
FROM products;
========================================
