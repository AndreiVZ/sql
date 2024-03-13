======================================== 1.1 Отношение (таблица)
CREATE TABLE book(
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    authOR VARCHAR(30),
    price DECIMAL(8, 2),
    amount INT
);
----------------------------------------
INSERT INTO book (title, authOR, price, amount) VALUES ('Мастер и Маргарита', 'Булгаков М.А.', 670.99, 3);
----------------------------------------
INSERT INTO book (title, authOR, price, amount) VALUES ('Белая гвардия', 'Булгаков М.А.', 540.50, 5);
INSERT INTO book (title, authOR, price, amount) VALUES ('Идиот', 'Достоевский Ф.М.', 460.00, 10);
INSERT INTO book (title, authOR, price, amount) VALUES ('Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 2);

INSERT INTO book (title, authOR, price, amount)
VALUES
    ('Белая гвардия', 'Булгаков М.А.', 540.50 , 5),
    ('Идиот', 'Достоевский Ф.М.', 460, 10),
    ('Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 2);
======================================== 1.2 Выборка данных
SELECT * FROM book;
----------------------------------------
SELECT authOR, title, price
FROM book;
----------------------------------------
SELECT title AS Название, authOR AS Автор
FROM book;
----------------------------------------
SELECT title, amount, amount * 1.65 AS pack
FROM book;
----------------------------------------
SELECT title, authOR, amount, ROUND(price * 0.7, 2) AS new_price
FROM book;
----------------------------------------
SELECT authOR, title, ROUND(IF(authOR = 'Булгаков М.А.', price * 1.1, IF(authOR = 'Есенин С.А.', price * 1.05, price)), 2) AS new_price
FROM book;
----------------------------------------
SELECT authOR, title, price
FROM  book
WHERE amount < 10;
----------------------------------------
SELECT title, authOR, price, amount
FROM book
WHERE (600 < price OR price < 500) AND price * amount >= 5000;
----------------------------------------
SELECT title, authOR
FROM book
WHERE price BETWEEN 540.5 AND 800 AND amount IN (2, 3, 5, 7);
----------------------------------------
SELECT authOR, title
FROM book
WHERE amount BETWEEN 2 AND 14
ORDER BY authOR DESC, title ASC;
----------------------------------------
SELECT title, authOR
FROM book
WHERE trim(title) LIKE '% %' AND authOR LIKE '%С.%'
ORDER BY title ASC;


SELECT title FROM book
WHERE title REGEXP '^[^ ]+ [^ ]+$'
======================================== 1.3 Запросы, групповые операции
SELECT DISTINCT amount
FROM book;
----------------------------------------
SELECT authOR AS Автор, COUNT(title) AS Различных_книг, SUM(amount) AS Количество_экземпляров
FROM book
GROUP BY authOR;
----------------------------------------
SELECT authOR, MIN(price) Минимальная_цена, MAX(price) Максимальная_цена, AVG(price) Средняя_цена
FROM book
GROUP BY authOR;
----------------------------------------
SELECT authOR, ROUND(SUM((price * amount)), 2) AS Стоимость, ROUND(SUM((price * amount) * 18 / 118), 2) AS НДС, ROUND(SUM((price * amount) * 100 / 118), 2) AS Стоимость_без_НДС
FROM book
GROUP BY authOR;
----------------------------------------
SELECT MIN(price) Минимальная_цена, MAX(price) Максимальная_цена, ROUND(AVG(price), 2) Средняя_цена
FROM book;
----------------------------------------
SELECT ROUND(AVG(price), 2) AS Средняя_цена, SUM(amount * price) AS Стоимость
FROM book
WHERE amount BETWEEN 5 AND 14;
----------------------------------------
SELECT authOR, sum(amount * price) AS Стоимость
FROM book
WHERE title NOT IN ('Идиот', 'Белая гвардия')
GROUP BY authOR
HAVING Стоимость > 5000
ORDER BY Стоимость DESC;
======================================== 1.4 Вложенные запросы
SELECT authOR, title, price
FROM book
WHERE price <= (SELECT avg(price) FROM book)
ORDER BY price DESC;
----------------------------------------
SELECT authOR, title, price
FROM book
WHERE ABS(price - (SELECT mIN(price) FROM book)) <= 150
ORDER BY price;
----------------------------------------
SELECT authOR, title, amount
FROM book
WHERE amount IN (SELECT amount FROM book GROUP BY amount HAVING count(amount) = 1);
----------------------------------------
SELECT authOR, title, price
FROM book
WHERE price < any (SELECT mIN(price) FROM book GROUP BY authOR);
----------------------------------------
SELECT title, authOR, amount, (SELECT max(amount) FROM book) - amount AS Заказ
FROM book
WHERE amount <> (SELECT max(amount) FROM book);


SELECT title, authOR, amount, (SELECT max(amount) FROM book) - amount AS Заказ
FROM book
HAVING Заказ > 0;
======================================== 1.5 Запросы корректировки данных
CREATE TABLE supply(
    supply_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    authOR VARCHAR(30),
    price DECIMAL(8, 2),
    amount INT
);
----------------------------------------
INSERT INTO supply (title, authOR, price, amount) 
VALUES 
    ('Лирика', 'Пастернак Б.Л.', 518.99, 2),
    ('Черный человек', 'Есенин С.А.', 570.20, 6),
    ('Белая гвардия', 'Булгаков М.А.', 540.50, 7),
    ('Идиот', 'Достоевский Ф.М.', 360.80, 3);
----------------------------------------
INSERT INTO book (title, authOR, price, amount) 
    SELECT title, authOR, price, amount 
    FROM supply
    WHERE authOR NOT IN ('Булгаков М.А.', 'Достоевский Ф.М.');
----------------------------------------
INSERT INTO book (title, authOR, price, amount) 
SELECT title, authOR, price, amount 
FROM supply
WHERE authOR NOT IN (
        SELECT authOR 
        FROM book
      );
----------------------------------------
UPDATE book 
SET price = 0.9 * price 
WHERE amount BETWEEN 5 AND 10;
----------------------------------------
UPDATE book
SET buy = if(buy > amount, amount, buy),
price = if(buy = 0, price * 0.9, price);
----------------------------------------
UPDATE book, supply 
SET book.amount = book.amount + supply.amount,
book.price = (book.price + supply.price) / 2
WHERE book.title = supply.title AND book.authOR = supply.authOR;
----------------------------------------
DELETE FROM supply
WHERE authOR IN (
    SELECT authOR
    FROM book
    GROUP BY authOR
    HAVING sum(amount) > 10);
----------------------------------------
CREATE TABLE ORderINg AS
SELECT authOR, title, (
    SELECT ROUND(AVG(amount)) 
    FROM book
   ) AS amount
FROM book
WHERE amount < (
    SELECT ROUND(AVG(amount)) 
    FROM book
   );
======================================== 1.6 Таблица "Командировки", запросы на выборку
SELECT name, city, per_diem, date_first, date_lASt
FROM trip
WHERE trim(name) LIKE '%а %'
ORDER BY date_lASt DESC;
----------------------------------------
SELECT DISTINCT name
FROM trip
WHERE city = 'Москва'
ORDER BY name;
----------------------------------------
SELECT city, count(*) AS Количество
FROM trip
GROUP BY city
ORDER BY city;
----------------------------------------
SELECT city, count(*) AS Количество
FROM trip
GROUP BY city
ORDER BY Количество DESC
LIMIT 2;
----------------------------------------
SELECT name, city, DATEDIFF(date_lASt, date_first) + 1 AS Длительность
FROM trip
WHERE city NOT IN ('Москва', 'Санкт-Петербург')
ORDER BY Длительность DESC, city DESC;
----------------------------------------
SELECT name, city, date_first, date_lASt
FROM trip
WHERE DATEDIFF(date_lASt, date_first) = (SELECT mIN(DATEDIFF(date_lASt, date_first)) FROM trip);
----------------------------------------
SELECT name, city, date_first, date_lASt
FROM trip
WHERE month(date_lASt) = month(date_first)
ORDER BY city, name;
----------------------------------------
SELECT MONTHNAME(date_first) Месяц, count(*) Количество
FROM trip
GROUP BY MONTHNAME(date_first)
ORDER BY Количество DESC, Месяц ASC;
----------------------------------------
SELECT name, city, date_first, (DATEDIFF(date_lASt, date_first) + 1) * per_diem AS Сумма
FROM trip
WHERE month(date_first) IN (2, 3)
ORDER BY name, Сумма DESC;
----------------------------------------
SELECT name, sum((DATEDIFF(date_lASt, date_first) + 1) * per_diem) AS Сумма
FROM trip
WHERE name IN (SELECT name
    FROM trip
    GROUP BY name
    HAVING count(*) > 3)
GROUP BY name
ORDER BY Сумма DESC;


SELECT name, SUM(per_diem * (DATEDIFF(date_lASt, date_first) + 1)) AS Сумма
FROM trip
GROUP BY name
HAVING COUNT(*) > 3
ORDER BY Сумма DESC;
======================================== 1.7 Таблица "Нарушения ПДД", запросы корректировки
CREATE TABLE fine(
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    number_plate VARCHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8, 2),
    date_violation DATE,
    date_payment DATE
);
----------------------------------------
INSERT INTO fine (name, number_plate, violation, date_violation)
VALUES
    ('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', '2020-02-14'), 
    ('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', '2020-02-23'), 
    ('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', '2020-03-03');
----------------------------------------
UPDATE fine f, traffic_violation tv
SET f.sum_fine = tv.sum_fine 
WHERE f.violation = tv.violation AND f.sum_fine IS NULL;
----------------------------------------
SELECT name, number_plate, violation
FROM fine
GROUP BY name, number_plate, violation
HAVING count(*) >= 2
ORDER BY name, number_plate, violation;
----------------------------------------
UPDATE fine f, (SELECT name, number_plate, violation
    FROM fine
    GROUP BY name, number_plate, violation
    HAVING count(*) >= 2) AS q
SET f.sum_fine = f.sum_fine * 2
WHERE f.name = q.name AND f.number_plate = q.number_plate AND f.violation = q.violation AND f.date_payment IS NULL;
----------------------------------------
UPDATE fine f, payment AS p
SET f.date_payment = p.date_payment,
f.sum_fine = if(abs(DATEDIFF(p.date_payment, p.date_violation)) <= 20, f.sum_fine / 2, f.sum_fine)
WHERE (f.name, f.number_plate, f.violation, f.date_violation) = (p.name, p.number_plate, p.violation, p.date_violation) AND f.date_payment IS NULL;
----------------------------------------
CREATE TABLE back_payment AS
SELECT name, number_plate, violation, sum_fine, date_violation
FROM fine
WHERE date_payment IS NULL;
----------------------------------------
DELETE
FROM fine
WHERE date_violation < '2020-02-01';
======================================== 1.8 Глоссарий и поиск по курсу
SELECT 
   CONCAT(module_id,'.',lesson_position,".",step_position," ",step_name) AS Шаг
FROM step
        INNER JOIN lesson USING (lesson_id)
        INNER JOIN module USING (module_id)
        INNER JOIN step_keywORd USING (step_id)
        INNER JOIN keywORd USING (keywORd_id)
WHERE keywORd_name IN ('MAX', 'AVG', 'MIN')
GROUP BY ШАГ
HAVING COUNT(*) = 3
ORDER BY 1;
======================================== 2.1 Связи между таблицами
CREATE TABLE authOR(
    authOR_id INT PRIMARY KEY AUTO_INCREMENT,
    name_authOR VARCHAR(50)
);
----------------------------------------
INSERT INTO authOR (name_authOR)
VALUES
    ('Булгаков М.А.'),
    ('Достоевский Ф.М.'),
    ('Есенин С.А.'),
    ('Пастернак Б.Л.');
----------------------------------------
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    authOR_id INT NOT NULL, 
    genre_id INT,
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (authOR_id) REFERENCES authOR (authOR_id),
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id) 
);
----------------------------------------
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    authOR_id INT NOT NULL, 
    genre_id INT,
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (authOR_id) REFERENCES authOR (authOR_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE SET NULL
);
----------------------------------------
INSERT INTO book (title, authOR_id, genre_id, price, amount)
VALUES
    ('Стихотворения и поэмы', 3, 2, 650.00, 15),
    ('Черный человек', 3, 2, 570.20, 6),
    ('Лирика', 4, 2, 518.99, 2);
======================================== 2.2 Запросы на выборку, соединение таблиц
SELECT title, name_genre, price
FROM book INNER JOIN genre
on book.genre_id = genre.genre_id
WHERE book.amount > 8
ORDER BY price DESC;
----------------------------------------
SELECT name_genre
FROM genre LEFT JOIN book
ON genre.genre_id = book.genre_id
WHERE title IS NULL;
----------------------------------------
SELECT name_city, name_authOR, (DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * 365) DAY)) AS Дата
FROM
authOR CROSS JOIN city
ORDER BY name_city, Дата DESC;
----------------------------------------
SELECT name_genre, title, name_authOR
FROM authOR 
INNER JOIN book ON authOR.authOR_id = book.authOR_id
INNER JOIN genre ON genre.genre_id = book.genre_id
WHERE name_genre IN ('Роман')
ORDER BY title;
----------------------------------------
SELECT name_authOR, sum(amount) Количество
FROM authOR LEFT JOIN book
ON authOR.authOR_id = book.authOR_id
GROUP BY name_authOR
HAVING Количество < 10 OR Количество IS NULL
ORDER BY Количество;
----------------------------------------
SELECT name_authOR
FROM book
LEFT JOIN authOR ON book.authOR_id = authOR.authOR_id
GROUP BY name_authOR
HAVING count(DISTINCT genre_id) = 1
ORDER BY name_authOR;
----------------------------------------
SELECT title, name_authOR, name_genre, price, amount
FROM authOR
INNER JOIN book ON authOR.authOR_id = book.authOR_id
INNER JOIN genre ON  book.genre_id = genre.genre_id
WHERE genre.genre_id IN
    (/* выбираем автора, если он пишет книги в самых популярных жанрах*/
    SELECT query_IN_1.genre_id
    FROM 
      ( /* выбираем код жанра и количество произведений, относящихся к нему */
        SELECT genre_id, SUM(amount) AS sum_amount
        FROM book
        GROUP BY genre_id
       )query_IN_1
    INNER JOIN 
      ( /* выбираем запись, в которой указан код жанр с максимальным количеством книг */
        SELECT genre_id, SUM(amount) AS sum_amount
        FROM book
        GROUP BY genre_id
        ORDER BY sum_amount DESC
        LIMIT 1
       ) query_IN_2
    ON query_IN_1.sum_amount= query_IN_2.sum_amount
    )
ORDER BY title;


SELECT title, name_authOR, name_genre, price, amount
FROM authOR
INNER JOIN book ON authOR.authOR_id = book.authOR_id
INNER JOIN genre ON book.genre_id = genre.genre_id
WHERE book.genre_id IN 
    (SELECT genre_id
     FROM book
     GROUP BY genre_id
     HAVING SUM(amount) >= ALL(SELECT SUM(amount) FROM book GROUP BY genre_id)
     )
ORDER BY title;
----------------------------------------
SELECT book.title AS Название, supply.authOR Автор, book.amount + supply.amount AS Количество
FROM book
INNER JOIN supply USING (title, price);
======================================== 2.3 Запросы корректировки, соединение таблиц
UPDATE book
LEFT JOIN supply USING (title)
LEFT JOIN authOR USING (authOR_id)
SET book.price = round((book.price * book.amount + supply.price * supply.amount) / (book.amount + supply.amount), 2),
book.amount = book.amount + supply.amount,
supply.amount = 0
WHERE book.price <> supply.price AND supply.amount IS NOT NULL AND supply.authOR = authOR.name_authOR;


UPDATE book b
JOIN authOR a on a.authOR_id=b.authOR_id
JOIN supply s on b.title=s.title AND a.name_authOR=s.authOR AND b.price<>s.price
SET b.amount=b.amount+s.amount,
s.amount=0,
b.price=(b.amount*b.price+s.amount*s.price)/(b.amount+s.amount);
----------------------------------------
INSERT INTO authOR (name_authOR)
SELECT DISTINCT authOR FROM supply
WHERE authOR NOT IN (SELECT name_authOR FROM authOR);
----------------------------------------
INSERT INTO book (title, authOR_id, price, amount)
SELECT title, authOR_id, price, amount
FROM authOR 
INNER JOIN supply ON authOR.name_authOR = supply.authOR
WHERE amount <> 0 AND (supply.title, authOR.authOR_id) NOT IN (SELECT DISTINCT title, authOR_id FROM book);

SELECT * FROM book;
----------------------------------------
UPDATE book
SET genre_id = 
      (
       SELECT genre_id 
       FROM genre 
       WHERE name_genre = 'Поэзия'
      )
WHERE book_id = 10;


UPDATE book
SET genre_id = 
      (
       SELECT genre_id 
       FROM genre 
       WHERE name_genre = 'Приключения'
      )
WHERE book_id = 11;
----------------------------------------
DELETE FROM authOR
WHERE authOR_id IN 
    (SELECT authOR_id
    FROM book
    GROUP BY authOR_id
    HAVING sum(amount) < 20);


(!) Все решают через IN (SELECT ...), но оператор IN считается очень не эффективным на больших выборках, и всегда можно обойтись без него.
DELETE a FROM authOR a
INNER JOIN (
    SELECT authOR_id FROM book
    GROUP BY authOR_id
    HAVING SUM(amount) < 20
    ) b
ON a.authOR_id = b.authOR_id;    
----------------------------------------
DELETE FROM genre
WHERE genre_id IN
    (SELECT genre_id
    FROM book
    GROUP BY genre_id
    HAVING count(book_id) < 4);


DELETE g FROM genre g
INNER JOIN (
    SELECT genre_id
    FROM book
    GROUP BY genre_id
    HAVING COUNT(title) < 3
 ) b
ON g.genre_id = b.genre_id;
----------------------------------------
DELETE FROM authOR
WHERE authOR_id IN
    (SELECT DISTINCT authOR_id
    FROM book
    INNER JOIN genre USING (genre_id)
    WHERE genre.name_genre = 'Поэзия')


DELETE FROM authOR
USING authOR INNER JOIN book ON book.authOR_id = authOR.authOR_id
                        INNER JOIN genre ON book.genre_id = genre.genre_id
WHERE name_genre = "Поэзия";


DELETE FROM authOR 
USING authOR JOIN book USING (authOR_id)
             JOIN genre USING (genre_id)
WHERE name_genre='Поэзия'   
======================================== 2.4 База данных «Интернет-магазин книг», запросы на выборку
SELECT buy_book.buy_id, book.title, book.price, buy_book.amount
FROM client
INNER JOIN buy USING (client_id)
INNER JOIN buy_book USING (buy_id)
INNER JOIN book USING (book_id)
WHERE client.name_client = 'Баранов Павел'
ORDER BY buy_book.buy_id, book.title;
----------------------------------------
SELECT authOR.name_authOR, book.title, count(buy_book.buy_id) AS Количество
FROM book
LEFT JOIN buy_book USING (book_id)
INNER JOIN authOR USING (authOR_id)
GROUP BY authOR.name_authOR, book.title
ORDER BY authOR.name_authOR, book.title;
----------------------------------------
SELECT city.name_city, count(DISTINCT buy.buy_id) AS Количество
FROM city
LEFT JOIN client USING (city_id)
LEFT JOIN buy USING (client_id)
GROUP BY city.name_city
ORDER BY Количество DESC, name_city;
----------------------------------------
SELECT buy_step.buy_id, buy_step.date_step_end
FROM step
LEFT JOIN buy_step USING (step_id)
WHERE step.name_step = 'Оплата' AND buy_step.date_step_end IS NOT NULL;
----------------------------------------
SELECT buy_book.buy_id, client.name_client, sum(buy_book.amount * book.price) AS Стоимость
FROM buy_book
LEFT JOIN buy USING (buy_id)
LEFT JOIN client USING (client_id)
LEFT JOIN book USING (book_id)
GROUP BY buy_book.buy_id, client.name_client
ORDER BY buy_book.buy_id;
----------------------------------------
SELECT buy_step.buy_id, step.name_step
FROM buy_step
LEFT JOIN step USING (step_id)
WHERE date_step_beg AND date_step_end IS NULL
ORDER BY buy_step.buy_id;
----------------------------------------
SELECT client.name_client
FROM buy_step
INNER JOIN book USING (book_id)
INNER JOIN authOR USING (authOR_id)
INNER JOIN buy USING (buy_id)
INNER JOIN client USING (client_id)
WHERE authOR.name_authOR = 'Достоевский Ф.М.';
----------------------------------------
SELECT DISTINCT client.name_client
FROM buy_book
INNER JOIN book USING (book_id)
INNER JOIN authOR USING (authOR_id)
INNER JOIN buy USING (buy_id)
INNER JOIN client USING (client_id)
WHERE authOR.name_authOR = 'Достоевский Ф.М.'
ORDER BY client.name_client;


SELECT DISTINCT name_client FROM authOR
    JOIN book ON (authOR.authOR_id=book.authOR_id) AND (authOR.name_authOR="Достоевский Ф.М.")
    JOIN buy_book USING(book_id)
    JOIN buy USING(buy_id)
    JOIN client USING(client_id)
ORDER BY name_client;
----------------------------------------
SELECT genre.name_genre, sum(buy_book.amount) AS Количество
FROM buy_book
INNER JOIN book USING (book_id)
INNER JOIN genre USING (genre_id)
GROUP BY genre.name_genre
HAVING Количество = 7
ORDER BY Количество DESC;


WITH qq AS (SELECT name_genre, sum(bb.amount) AS Количество
                FROM genre g
                         JOIN book b
                         USING (genre_id)
                         JOIN buy_book bb
                         USING (book_id)
               GROUP BY name_genre)
SELECT name_genre, Количество
  FROM qq
HAVING количество = (SELECT max(Количество) FROM qq);
----------------------------------------
WITH t AS (SELECT buy_id, client_id, book_id, date_payment, amount, price
FROM 
    buy_archive
UNION ALL
SELECT buy.buy_id, client_id, book_id, date_step_end, buy_book.amount, price
FROM 
    book 
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy USING(buy_id) 
    INNER JOIN buy_step USING(buy_id)
    INNER JOIN step USING(step_id)                  
WHERE  date_step_end IS NOT NULL AND name_step = "Оплата")

SELECT year(date_payment) AS Год, MONTHNAME(date_payment) AS Месяц, sum(amount * price) AS Сумма
FROM t
GROUP BY Год, Месяц
ORDER BY Месяц, Год;
----------------------------------------
WITH t AS (SELECT book.title, buy_archive.amount AS Количество, buy_archive.price * buy_archive.amount AS Сумма
FROM buy_archive
INNER JOIN book USING (book_id)
UNION ALL
SELECT book.title, buy_book.amount AS Количество, book.price * buy_book.amount AS Сумма
FROM buy_book
INNER JOIN book USING (book_id)
INNER JOIN buy_step USING (buy_id)
INNER JOIN step USING (step_id)
WHERE step.name_step = 'Оплата' AND buy_step.date_step_end)

SELECT title, sum(Количество) AS Количество, sum(Сумма) AS Сумма
FROM t
GROUP BY title
ORDER BY Сумма DESC;
======================================== 2.5 База данных «Интернет-магазин книг», запросы корректировки
INSERT INTO client (name_client, city_id, email) VALUES ('Попов Илья', 1, 'popov@test');
----------------------------------------
INSERT INTO buy (buy_DESCription, client_id)
    SELECT 'Связаться со мной по вопросу доставки' AS buy_DESCription, client_id
    FROM client
    WHERE name_client = 'Попов Илья';
----------------------------------------
INSERT INTO buy_book (buy_id, book_id, amount)
VALUES
    (5, 8, 2),
    (5, 2, 1);

INSERT INTO buy_book (buy_id, book_id, amount)
SELECT 5, book_id, 2
FROM book 
WHERE title = 'Лирика' 
    AND authOR_id = (SELECT authOR_id FROM authOR WHERE name_authOR = 'Пастернак Б.Л.')
UNION 
SELECT 5, book_id, 1
FROM book 
WHERE title = 'Белая гвардия' 
    AND authOR_id = (SELECT authOR_id FROM authOR WHERE name_authOR = 'Булгаков М.А.');
----------------------------------------
UPDATE book
SET amount = amount - 2
WHERE book_id = 8;
UPDATE book
SET amount = amount - 1
WHERE book_id = 2;


UPDATE book b, buy_book bb
SET b.amount = b.amount - bb.amount
WHERE (b.book_id = bb.book_id) AND (bb.buy_id = 5);


UPDATE book b INNER JOIN buy_book bb ON b.book_id=bb.book_id AND buy_id=5
SET b.amount=b.amount-bb.amount;
----------------------------------------
CREATE TABLE buy_pay AS
SELECT book.title, authOR.name_authOR, book.price, buy_book.amount, book.price * buy_book.amount AS Стоимость
FROM buy_book
INNER JOIN book USING (book_id)
INNER JOIN authOR USING (authOR_id)
WHERE buy_book.buy_id = 5
ORDER BY book.title;
----------------------------------------
CREATE TABLE buy_pay AS
SELECT buy_book.buy_id, sum(buy_book.amount) AS Количество, sum(buy_book.amount * book.price) AS Итого
FROM buy_book
INNER JOIN book USING (book_id)
WHERE buy_book.buy_id = 5
GROUP BY buy_book.buy_id;
----------------------------------------
INSERT INTO buy_step (buy_id, step_id)
SELECT 5, step.step_id
FROM step;


INSERT INTO buy_step (buy_id, step_id, date_step_beg, date_step_end)
SELECT buy.buy_id, step_id, NULL, NULL
FROM buy, step
WHERE buy.buy_id = 5;
---------------------------------------- (!)
UPDATE buy_step, step
SET date_step_beg = '2020-04-12'
WHERE buy_step.step_id = step.step_id AND buy_step.buy_id = 5 AND step.name_step = 'Оплата';


UPDATE buy_step
JOIN step USING(step_id)
SET date_step_beg = '2020-04-12'
WHERE buy_id = 5 AND name_step = 'Оплата';


UPDATE buy_step
SET date_step_beg = '2020-04-12'
WHERE buy_id = 5 AND step_id = (SELECT step_id FROM step WHERE name_step = 'Оплата');
----------------------------------------
UPDATE buy_step, step
SET date_step_end = '2020-04-13'
WHERE buy_step.step_id = step.step_id AND buy_step.buy_id = 5 AND step.name_step = 'Оплата';
UPDATE buy_step, step
SET date_step_beg = '2020-04-13'
WHERE buy_step.step_id = step.step_id AND buy_step.buy_id = 5 AND step.name_step = 'Упаковка';


UPDATE buy_step 
      INNER JOIN step
      ON buy_step.step_id = step.step_id
SET date_step_end = '2020-04-13'
WHERE name_step ='Оплата' AND buy_id = 5;
UPDATE buy_step 
      INNER JOIN step
      ON buy_step.step_id = step.step_id
SET date_step_beg = '2020-04-13'
WHERE buy_step.step_id = (SELECT step_id + 1 FROM step WHERE name_step='Оплата') AND buy_id = 5;


UPDATE buy_step bs1,
       buy_step bs2
SET bs1.date_step_end = '2020-04-13',
    bs2.date_step_beg = '2020-04-13'
WHERE bs1.buy_id = 5
      AND bs2.buy_id = bs1.buy_id
      AND bs1.step_id = (SELECT step_id FROM step WHERE name_step = 'Оплата')
      AND bs2.step_id = bs1.step_id + 1;
======================================== 3.1 База данных «Тестирование», запросы на выборку
SELECT student.name_student, attempt.date_attempt, attempt.result
FROM attempt
INNER JOIN student USING (student_id)
INNER JOIN subject USING (subject_id)
WHERE subject.name_subject = 'Основы баз данных'
ORDER BY result DESC;


SELECT name_student, date_attempt, result
FROM subject s JOIN attempt a ON s.subject_id = a.subject_id AND s.name_subject = 'Основы баз данных'
               JOIN student st ON a.student_id = st.student_id
ORDER BY result DESC


SELECT st.name_student, a.date_attempt, a.result
FROM subject s, student st, attempt a
WHERE st.student_id = a.student_id 
    AND a.subject_id = s.subject_id 
    AND s.name_subject = 'Основы баз данных'
ORDER BY a.result DESC;
----------------------------------------
SELECT subject.name_subject, sum(if(attempt.result IS NOT NULL, 1, 0)) AS Количество, round(sum(attempt.result) / count(*), 2) AS Среднее
FROM subject
LEFT JOIN attempt USING (subject_id)
GROUP BY subject.name_subject
ORDER BY Среднее DESC;
----------------------------------------
SELECT student.name_student, attempt.result
FROM attempt
INNER JOIN student USING (student_id)
WHERE attempt.result = (SELECT max(result) FROM attempt)
ORDER BY student.name_student;
----------------------------------------
SELECT student.name_student, subject.name_subject, abs(datediff(mIN(attempt.date_attempt) , max(attempt.date_attempt))) AS Интервал
FROM attempt
INNER JOIN student USING (student_id)
INNER JOIN subject USING (subject_id)
GROUP BY student.name_student, subject.name_subject
HAVING Интервал > 0
ORDER BY Интервал;
----------------------------------------
SELECT name_subject, sum(if(student_id IS NOT NULL, 1, 0)) AS Количество
FROM 
    (SELECT DISTINCT subject.name_subject, attempt.student_id
    FROM subject
    LEFT JOIN attempt USING (subject_id)) AS t
GROUP BY name_subject
ORDER BY Количество DESC, name_subject;


SELECT DISTINCT subject.name_subject, count(DISTINCT attempt.student_id) AS Количество
FROM subject
LEFT JOIN attempt USING (subject_id)
GROUP BY name_subject
ORDER BY Количество DESC, subject.name_subject;
----------------------------------------
SELECT question.question_id, question.name_question
FROM question
LEFT JOIN subject USING (subject_id)
WHERE name_subject = 'Основы баз данных'
ORDER BY RAND()
LIMIT 3;
----------------------------------------
SELECT question.name_question, answer.name_answer, if(answer.IS_cORrect, 'Верно', 'Неверно') AS Результат
FROM testINg
LEFT JOIN question USING (question_id)
LEFT JOIN answer USING (answer_id)
WHERE testINg.attempt_id = 7;
----------------------------------------
SELECT student.name_student, subject.name_subject, attempt.date_attempt, round(sum(answer.IS_cORrect) / 3 * 100, 2) AS Результат
FROM testINg
LEFT JOIN question USING (question_id)
LEFT JOIN answer USING (answer_id)
LEFT JOIN attempt USING (attempt_id)
LEFT JOIN student USING (student_id)
LEFT JOIN subject on subject.subject_id = attempt.subject_id
GROUP BY student.name_student, subject.name_subject, attempt.date_attempt
ORDER BY student.name_student, attempt.date_attempt DESC;
----------------------------------------
SELECT subject.name_subject, concat(left(question.name_question, 30), '...') AS Вопрос, count(testINg.answer_id) AS Всего_ответов, round(avg(answer.IS_cORrect) * 100, 2) AS Успешность
FROM testINg
LEFT JOIN question USING (question_id)
LEFT JOIN answer USING (answer_id)
LEFT JOIN attempt USING (attempt_id)
LEFT JOIN student USING (student_id)
LEFT JOIN subject on subject.subject_id = attempt.subject_id
GROUP BY subject.name_subject, question.name_question
ORDER BY name_subject, Успешность DESC, Вопрос;
======================================== 3.2 База данных «Тестирование», запросы корректировки
INSERT INTO attempt (student_id, subject_id, date_attempt) VALUES (1, 2, now());


INSERT INTO attempt (student_id, subject_id, date_attempt)
SELECT student_id, subject_id, NOW()
FROM  student, subject
WHERE name_student = 'Баранов Павел' AND name_subject = 'Основы баз данных';


INSERT INTO attempt (student_id,subject_id, date_attempt)
VALUES (
    (SELECT student_id FROM student WHERE name_student = 'Баранов Павел'),
    (SELECT subject_id FROM subject WHERE name_subject = 'Основы баз данных'),
    NOW());
----------------------------------------
INSERT INTO testINg (attempt_id, question_id)
SELECT (SELECT attempt.attempt_id FROM attempt ORDER BY attempt_id DESC LIMIT 1) AS attempt_id, question.question_id
FROM testINg
LEFT JOIN attempt USING (attempt_id)
LEFT JOIN subject USING (subject_id)
LEFT JOIN question USING (question_id)
WHERE student_id = (SELECT attempt.student_id FROM attempt ORDER BY attempt_id DESC LIMIT 1)
ORDER BY RAND()
LIMIT 3;


INSERT INTO testINg (attempt_id, question_id)
SELECT attempt_id, question_id
FROM question
JOIN attempt USING (subject_id)
ORDER BY attempt_id DESC, rAND()
LIMIT 3;


SET @attempt_id = (SELECT MAX(attempt_id) FROM attempt);
SET @subject_id = (SELECT subject_id FROM attempt WHERE attempt_id = @attempt_id);
INSERT INTO testINg (attempt_id, question_id)
SELECT
    @attempt_id,
    question_id
FROM
    question
WHERE
    subject_id = @subject_id
ORDER BY
    RAND()
LIMIT
    3;
----------------------------------------
-- not my code
UPDATE attempt
SET result = (SELECT ROUND(SUM(IS_cORrect)/3*100, 0)
FROM answer INNER JOIN testINg ON answer.answer_id = testINg.answer_id
WHERE attempt_id = 8)
WHERE attempt_id = 8;
----------------------------------------
DELETE FROM attempt
WHERE date_attempt < '2020-05-01';
======================================== 3.3 База данных «Абитуриент», запросы на выборку
SELECT enrollee.name_enrollee
FROM program_enrollee
INNER JOIN enrollee USING (enrollee_id)
INNER JOIN program USING (program_id)
WHERE program.name_program = 'Мехатроника и робототехника'
ORDER BY enrollee.name_enrollee;
----------------------------------------
SELECT program.name_program
FROM program_subject
INNER JOIN program USING (program_id)
INNER JOIN subject USING (subject_id)
WHERE name_subject = 'Информатика'
ORDER BY program.name_program DESC;
----------------------------------------
SELECT subject.name_subject, count(enrollee_subject.enrollee_id) AS Количество, max(enrollee_subject.result) AS Максимум, mIN(enrollee_subject.result) AS Минимум, round(avg(enrollee_subject.result), 1) AS Среднее
FROM enrollee_subject
INNER JOIN subject USING (subject_id)
GROUP BY subject.name_subject
ORDER BY subject.name_subject;
----------------------------------------
SELECT program.name_program
FROM program_subject
INNER JOIN program USING (program_id)
GROUP BY program.name_program
HAVING mIN(program_subject.mIN_result) >= 40
ORDER BY program.name_program;
----------------------------------------
SELECT program.name_program, program.plan
FROM program
WHERE program.plan = (SELECT max(plan) FROM program);
----------------------------------------
--SELECT enrollee.name_enrollee, if(sum(achievement.bonus), sum(achievement.bonus), 0) AS Бонус
SELECT enrollee.name_enrollee, IFNULL(sum(achievement.bonus), 0) AS Бонус
FROM enrollee
LEFT JOIN enrollee_achievement USING (enrollee_id)
LEFT JOIN achievement USING (achievement_id)
GROUP BY enrollee.name_enrollee
ORDER BY enrollee.name_enrollee;
----------------------------------------
SELECT department.name_department, program.name_program, program.plan, count(program_enrollee.enrollee_id) AS Количество, round(count(program_enrollee.enrollee_id) / program.plan, 2) AS Конкурс
FROM program_enrollee
INNER JOIN program USING (program_id)
INNER JOIN department USING (department_id)
GROUP BY department.name_department, program.name_program, program.plan
ORDER BY Конкурс DESC;
----------------------------------------
SELECT program.name_program
FROM program_subject
INNER JOIN program USING (program_id)
INNER JOIN subject USING (subject_id)
WHERE subject.name_subject IN ('Математика', 'Информатика')
GROUP BY program.name_program
HAVING count(subject.name_subject) = 2
ORDER BY program.name_program;


SELECT program.name_program
FROM program_subject
INNER JOIN program USING (program_id)
INNER JOIN subject USING (subject_id)
GROUP BY program.name_program
HAVING sum(subject.name_subject IN ('Математика', 'Информатика')) = 2
ORDER BY program.name_program;
----------------------------------------
SELECT DISTINCT program.name_program, enrollee.name_enrollee, sum(enrollee_subject.result) AS itog
FROM enrollee
INNER JOIN program_enrollee on enrollee.enrollee_id = program_enrollee.enrollee_id
INNER JOIN program on program_enrollee.program_id = program.program_id
INNER JOIN program_subject on program.program_id = program_subject.program_id
INNER JOIN subject on program_subject.subject_id = subject.subject_id
INNER JOIN enrollee_subject on subject.subject_id = enrollee_subject.subject_id  AND enrollee_subject.enrollee_id = enrollee.enrollee_id
GROUP BY program.name_program, enrollee.name_enrollee
ORDER BY program.name_program, itog DESC;


SELECT 
    name_program,
    name_enrollee,
    SUM(result) AS itog
FROM enrollee JOIN program_enrollee USING(enrollee_id)
              JOIN program USING(program_id)
              JOIN program_subject USING(program_id)
              JOIN subject USING(subject_id)
              JOIN enrollee_subject USING(subject_id, enrollee_id)
GROUP BY 1, 2
ORDER BY 1, 3 DESC;
----------------------------------------
SELECT DISTINCT program.name_program, enrollee.name_enrollee
FROM enrollee
INNER JOIN program_enrollee on enrollee.enrollee_id = program_enrollee.enrollee_id
INNER JOIN program on program_enrollee.program_id = program.program_id
INNER JOIN program_subject on program.program_id = program_subject.program_id
INNER JOIN subject on program_subject.subject_id = subject.subject_id
INNER JOIN enrollee_subject on subject.subject_id = enrollee_subject.subject_id  AND enrollee_subject.enrollee_id = enrollee.enrollee_id
WHERE enrollee_subject.result < program_subject.mIN_result
ORDER BY program.name_program, enrollee.name_enrollee;
======================================== 3.4 База данных «Абитуриент», запросы корректировки
CREATE TABLE applicant AS
SELECT program_subject.program_id, enrollee.enrollee_id, sum(enrollee_subject.result) AS itog
FROM enrollee
JOIN program_enrollee USING(enrollee_id)
JOIN program USING(program_id)
JOIN program_subject USING(program_id)
JOIN subject USING(subject_id)
JOIN enrollee_subject USING(subject_id, enrollee_id)
GROUP BY program_subject.program_id, enrollee.enrollee_id
ORDER BY program_subject.program_id, itog DESC


CREATE TABLE applicant
SELECT program_id, enrollee_id, SUM(result) itog
FROM program_enrollee JOIN program_subject USING (program_id)
                      JOIN enrollee_subject USING (subject_id, enrollee_id)
GROUP BY  2, 1
ORDER BY 1, 3 DESC;
----------------------------------------
WITH t AS (
SELECT DISTINCT program.program_id, enrollee.enrollee_id
FROM enrollee
INNER JOIN program_enrollee on enrollee.enrollee_id = program_enrollee.enrollee_id
INNER JOIN program on program_enrollee.program_id = program.program_id
INNER JOIN program_subject on program.program_id = program_subject.program_id
INNER JOIN subject on program_subject.subject_id = subject.subject_id
INNER JOIN enrollee_subject on subject.subject_id = enrollee_subject.subject_id  AND enrollee_subject.enrollee_id = enrollee.enrollee_id
WHERE enrollee_subject.result < program_subject.mIN_result
ORDER BY program.program_id, enrollee.enrollee_id)

DELETE FROM applicant
WHERE applicant.program_id IN (SELECT t.program_id FROM t) AND applicant.enrollee_id IN (SELECT t.enrollee_id FROM t);


DELETE applicant
FROM applicant
JOIN program_subject USING(program_id)
JOIN enrollee_subject USING(enrollee_id, subject_id)
WHERE result < mIN_result;
----------------------------------------
WITH t AS (
SELECT applicant.program_id, applicant.enrollee_id, sum(achievement.bonus) AS bonus
FROM applicant
JOIN enrollee_achievement USING (enrollee_id)
JOIN achievement USING (achievement_id)
GROUP BY applicant.program_id, applicant.enrollee_id)

UPDATE applicant, t
SET applicant.itog = applicant.itog + t.bonus
WHERE applicant.program_id = t.program_id AND applicant.enrollee_id = t.enrollee_id;


UPDATE applicant
AS applicant INNER JOIN 
             (SELECT enrollee_id, SUM(add_ball) AS ball
              FROM enrollee_achievement INNER JOIN achievement
              ON enrollee_achievement.achievement_id = achievement.achievement_id
              GROUP BY enrollee_id
              )query_IN
ON applicant.enrollee_id = query_IN.enrollee_id
SET itog = itog + query_IN.ball;
----------------------------------------
CREATE TABLE applicant_ORder AS
SELECT *
FROM applicant
ORDER BY program_id, itog DESC;
DROP TABLE applicant;


CREATE TABLE applicant_ORder
(
    SELECT * FROM applicant
    ORDER BY program_id, itog DESC
);
DROP TABLE applicant;
----------------------------------------
ALTER TABLE applicant_ORder ADD str_id INt FIRST;
----------------------------------------
SET @str_id := 0;
SET @row_num := 1;
UPDATE applicant_ORder
SET str_id = if(program_id = @str_id, @row_num := @row_num + 1, @row_num := 1 AND @str_id := program_id);
----------------------------------------
CREATE TABLE student AS
SELECT program.name_program, enrollee.name_enrollee, applicant_ORder.itog
FROM applicant_ORder
JOIN program USING (program_id)
JOIN enrollee USING (enrollee_id)
WHERE applicant_ORder.str_id <= program.plan
ORDER BY program.name_program, applicant_ORder.itog DESC;
======================================== 3.5 База данных "Учебная аналитика по курсу"
SELECT concat(left(concat(module_id, ' ', module_name), 16), '...') AS Модуль,
concat(left(concat(module_id, '.', lesson_position, ' ', lesson_name), 16), '...') AS Урок,
concat(module_id, '.', lesson_position, '.', step_position, ' ', step_name) AS Шаг
FROM step
JOIN lesson USING (lesson_id)
JOIN module USING (module_id)
WHERE step_name LIKE '%влож%'
ORDER BY Модуль, Урок, Шаг;
----------------------------------------
INSERT INTO step_keywORd (step_id, keywORd_id)
SELECT DISTINCT step_id, keywORd_id -- step_name, keywORd_name
FROM keywORd, step
WHERE regexp_INSTR(step_name, concat('\\b', keywORd_name, '\\b'));
----------------------------------------
WITH t AS (
SELECT module_id, lesson_position, step_position, step_name
FROM step
JOIN lesson USING (lesson_id)
JOIN module USING (module_id)
JOIN step_keywORd USING (step_id)
JOIN keywORd USING (keywORd_id)
WHERE keywORd_name IN ('MAX', 'AVG')
GROUP BY module_id, lesson_position, step_position, step_name
HAVING count(*) = 2)

SELECT concat(module_id, '.', lesson_position, '.', LPAD(step_position, 2, '0'), ' ', step_name) AS Шаг
FROM t
ORDER BY Шаг;


SELECT concat(module_id, '.', lesson_position, '.', LPAD(step_position, 2, '0'), ' ', step_name) AS Шаг
FROM step
JOIN lesson USING (lesson_id)
JOIN module USING (module_id)
JOIN step_keywORd USING (step_id)
JOIN keywORd USING (keywORd_id)
WHERE keywORd_name IN ('MAX', 'AVG')
GROUP BY Шаг
HAVING count(*) = 2
ORDER BY Шаг;
----------------------------------------
WITH t2 AS (
    SELECT student_name, rate, 
    CASE
        WHEN rate <= 10 THEN "I"
        WHEN rate <= 15 THEN "II"
        WHEN rate <= 27 THEN "III"
        ELSE "IV"
    END AS Группа
FROM      
    (
     SELECT student_name, count(*) AS rate
     FROM 
         (
          SELECT student_name, step_id
          FROM 
              student 
              INNER JOIN step_student USING(student_id)
          WHERE result = "cORrect"
          GROUP BY student_name, step_id
         ) query_IN
     GROUP BY student_name 
     ORDER BY 2
    ) t1
)
SELECT Группа,
    CASE
        WHEN Группа = "I" THEN concat('от 0 до ', max(rate))
        WHEN Группа = "II" THEN concat('от ', mIN(rate), ' до ', max(rate))
        WHEN Группа = "III" THEN concat('от ', mIN(rate), ' до ', max(rate))
        ELSE concat('больше ', mIN(rate) - 1)
    END AS Интервал,
    count(*) AS Количество
FROM t2
GROUP BY Группа
ORDER BY Группа;


SELECT Группа,
    CASE
        WHEN Группа = "I" THEN concat('от 0 до ', max(rate))
        WHEN Группа = "II" THEN concat('от ', mIN(rate), ' до ', max(rate))
        WHEN Группа = "III" THEN concat('от ', mIN(rate), ' до ', max(rate))
        ELSE concat('больше ', mIN(rate) - 1)
    END AS Интервал,
    count(*) AS Количество
FROM (
    SELECT student_name, rate, 
    CASE
        WHEN rate <= 10 THEN "I"
        WHEN rate <= 15 THEN "II"
        WHEN rate <= 27 THEN "III"
        ELSE "IV"
    END AS Группа
    FROM      
        (
         SELECT student_name, count(*) AS rate
         FROM 
             (
              SELECT student_name, step_id
              FROM 
                  student 
                  INNER JOIN step_student USING(student_id)
              WHERE result = "cORrect"
              GROUP BY student_name, step_id
             ) query_IN
         GROUP BY student_name 
         ORDER BY 2
        ) t1
    ) t2
GROUP BY Группа
ORDER BY Группа;
----------------------------------------
WITH get_count_cORrect (st_n_c, count_cORrect) 
  AS (
    SELECT step_name, count(*)
    FROM 
        step 
        INNER JOIN step_student USING (step_id)
    WHERE result = "cORrect"
    GROUP BY step_name
   ),
  get_count_wrong (st_n_w, count_wrong) 
  AS (
    SELECT step_name, count(*)
    FROM 
        step 
        INNER JOIN step_student USING (step_id)
    WHERE result = "wrong"
    GROUP BY step_name
   )  
   
SELECT st_n_c AS Шаг,
    IFNULL(ROUND(count_cORrect / (count_cORrect + count_wrong) * 100), 100) AS Успешность
FROM  
    get_count_cORrect 
    LEFT JOIN get_count_wrong ON st_n_c = st_n_w
UNION
SELECT st_n_w AS Шаг,
    IFNULL(ROUND(count_cORrect / (count_cORrect + count_wrong) * 100), 0) AS Успешность
FROM  
    get_count_cORrect 
    RIGHT JOIN get_count_wrong ON st_n_c = st_n_w
ORDER BY Успешность, Шаг;
----------------------------------------
SET @max_progress = (SELECT COUNT(DISTINCT step_id) FROM step_student);
SELECT student.student_name AS Студент, round(count(DISTINCT step_id) * 100 / @max_progress) AS Прогресс,
    CASE
        WHEN round(count(DISTINCT step_id) * 100 / @max_progress) = 100 THEN 'Сертификат с отличием'
        WHEN round(count(DISTINCT step_id) * 100 / @max_progress) >= 80 THEN 'Сертификат'
        ELSE ''
    END AS Результат
FROM step_student
JOIN student USING (student_id)
WHERE result = 'cORrect'
GROUP BY Студент
ORDER BY Прогресс DESC, Студент;


SET @all_step = (SELECT COUNT(DISTINCT step_id) FROM step_student);
WITH student_result
AS (
    SELECT
        student_id,
        ROUND(COUNT(DISTINCT step_id) / @all_step * 100) AS Прогресс
    FROM step_student
    WHERE result = 'cORrect'
    GROUP BY student_id
)
SELECT
    student_name AS Студент,
    Прогресс,
    CASE
        WHEN Прогресс = 100 THEN 'Сертификат с отличием'
        WHEN Прогресс >= 80 THEN 'Сертификат'
        ELSE ''
    END AS Результат
FROM student JOIN student_result USING(student_id)
ORDER BY Прогресс DESC, Студент;


SELECT Студент, Прогресс,
       IF(Прогресс = 100, 'Сертификат с отличием', IF(Прогресс >= 80, 'Сертификат', '')) AS Результат
FROM
    (SELECT student_name AS Студент,
           ROUND(COUNT(DISTINCT step_id) * 100 / (SELECT COUNT(DISTINCT step_id) FROM step_student)) AS Прогресс
    FROM student JOIN step_student USING(student_id)
    WHERE result = 'cORrect'
    GROUP BY student_name
    ORDER BY 2 DESC, 1) q;
----------------------------------------
-- ORDER BY submISsion_time DESC (LEAD, IFNULL)
SELECT student_name AS Студент,
    concat(left(step_name, 20), '...') AS Шаг,
    result AS Результат,
    FROM_UNIXTIME(submISsion_time) AS Дата_отправки,
    SEC_TO_TIME(IFNULL(submISsion_time - LEAD(submISsion_time) OVER (ORDER BY submISsion_time DESC), 0)) AS Разница
FROM step_student
JOIN student USING (student_id)
JOIN step USING (step_id)
WHERE student_name = 'student_61'
ORDER BY Дата_отправки;


-- ORDER BY submISsion_time DESC (LEAD)
SELECT student_name AS Студент,
    concat(left(step_name, 20), '...') AS Шаг,
    result AS Результат,
    FROM_UNIXTIME(submISsion_time) AS Дата_отправки,
    SEC_TO_TIME(submISsion_time - LEAD(submISsion_time, 1, submISsion_time) OVER (ORDER BY submISsion_time DESC)) AS Разница
FROM step_student
JOIN student USING (student_id)
JOIN step USING (step_id)
WHERE student_name = 'student_61'
ORDER BY Дата_отправки;


-- ORDER BY submISsion_time (LAG)
SELECT student_name AS Студент,
    concat(left(step_name, 20), '...') AS Шаг,
    result AS Результат,
    FROM_UNIXTIME(submISsion_time) AS Дата_отправки,
    SEC_TO_TIME(submISsion_time - LAG(submISsion_time, 1, submISsion_time) OVER (ORDER BY submISsion_time)) AS Разница
FROM step_student
JOIN student USING (student_id)
JOIN step USING (step_id)
WHERE student_name = 'student_61'
ORDER BY Дата_отправки;
/* 
LAG(submISsion_time, 1, submISsion_time) 
первый аргумент - LAG(submISsion_time) - предыдущий сабмишн
второй аргумент - 1 - через сколько строк брать предыдущее значение
третий аргумент - submISsion_time - Если вычисленное значение NULL, то взять текущее значение сабмишн
*/   
----------------------------------------
SELECT ROW_NUMBER() OVER(ORDER BY avg(sum_dif_time)) AS Номер, lesson AS Урок, round(avg(sum_dif_time) / 3600, 2) AS Среднее_время
FROM (
    SELECT concat(module_id, '.', lesson_position, ' ', lesson_name) AS lesson, sum(submISsion_time - attempt_time) AS sum_dif_time
    FROM step_student
    JOIN step USING (step_id)
    JOIN lesson USING (lesson_id)
    JOIN module USING (module_id)
    WHERE submISsion_time - attempt_time <= 60 * 60 * 4
    GROUP BY student_id, lesson_id
    ORDER BY student_id, lesson_id
) AS t
GROUP BY lesson;


SELECT ROW_NUMBER()
       OVER (ORDER BY SUM(submISsion_time - attempt_time) / COUNT(DISTINCT student_id)) AS Номер,
       CONCAT(module_id, ".", lesson_position, " ", lesson_name) AS Урок,
       ROUND(SUM(submISsion_time - attempt_time) / COUNT(DISTINCT student_id) / 3600, 2) AS Среднее_время
FROM step_student
     JOIN step USING(step_id)
     JOIN lesson USING(lesson_id)
WHERE submISsion_time - attempt_time <= 4 * 3600
GROUP BY Урок
----------------------------------------
SELECT module_id AS Модуль,
    student_name AS Студент,
    count(DISTINCT step_id) AS Пройдено_шагов,
    round(count(DISTINCT step_id) / MAX(count(DISTINCT step_id)) OVER (PARTITION BY module_id) * 100, 1) AS Относительный_рейтинг
FROM step_student
JOIN step USING (step_id)
JOIN lesson USING (lesson_id)
JOIN module USING (module_id)
JOIN student USING (student_id)
WHERE result = 'cORrect'
GROUP BY module_id, student_name
ORDER BY Модуль, Относительный_рейтинг DESC, Студент;
----------------------------------------
WITH t AS (
    SELECT student_name AS Студент,
        CONCAT(module_id, ".", lesson_position) AS Урок,
        count(*) over (PARTITION BY student_name) AS Количество_уроков,
        max(submISsion_time) AS Макс_время_отправки
    FROM step_student
    JOIN step USING (step_id)
    JOIN lesson USING (lesson_id)
    JOIN student USING (student_id)
    WHERE result = 'cORrect'
    GROUP BY Студент, Урок
    ORDER BY Студент, Макс_время_отправки
    )
   
SELECT Студент,
    Урок,
    FROM_UNIXTIME(Макс_время_отправки) AS Макс_время_отправки,    
    IFNULL(CEILING((Макс_время_отправки - LAG(Макс_время_отправки) OVER (PARTITION BY Студент ORDER BY Студент, Макс_время_отправки)) / (24 * 60 * 60)), '-') AS Интервал
FROM t
WHERE Количество_уроков >= 3
ORDER BY Студент, Макс_время_отправки;
----------------------------------------
WITH t AS (
    SELECT student_id, avg(submISsion_time - attempt_time) AS Время_попытки_сред
    FROM step_student
    JOIN student USING (student_id)
    WHERE student_name = 'student_59' AND (submISsion_time - attempt_time) <= 3600
    GROUP BY student_id)

SELECT student_name AS Студент,
    concat(module_id, '.', lesson_position, '.', step_position) AS Шаг,
    ROW_NUMBER() over (PARTITION BY student_name, concat(module_id, '.', lesson_position, '.', step_position) ORDER BY submISsion_time) AS Номер_попытки,
    result AS Результат, 
    if(submISsion_time - attempt_time <= 3600, SEC_TO_TIME(submISsion_time - attempt_time), SEC_TO_TIME(ceilINg(t.Время_попытки_сред))) AS Время_попытки,
    round(if(submISsion_time - attempt_time <= 3600, submISsion_time - attempt_time, ceilINg(t.Время_попытки_сред)) * 100 / sum(if(submISsion_time - attempt_time <= 3600, submISsion_time - attempt_time, (ceilINg(t.Время_попытки_сред)))) over (PARTITION BY student_name, concat(module_id, '.', lesson_position, '.', step_position)), 2) AS Относительное_время
    
FROM step_student
JOIN step USING (step_id)
JOIN lesson USING (lesson_id)
JOIN student USING (student_id)
JOIN t USING (student_id)
WHERE student_name = 'student_59'
ORDER BY step_id, submISsion_time;
----------------------------------------
WITH t1 AS (
        SELECT student_name, step_id, mIN(submISsion_time) AS mIN_cORrect
        FROM step_student
        JOIN student USING (student_id)
        WHERE result = 'cORrect'
        GROUP BY student_name, step_id
        ORDER BY  student_name, step_id
    ),
    t2 AS (
        SELECT student_name, step_id, max(submISsion_time) AS max_wrong
        FROM step_student
        JOIN student USING (student_id)
        WHERE result = 'wrong'
        GROUP BY student_name, step_id
        ORDER BY  student_name, step_id
    ),
    t3 AS (
        SELECT student_name, step_id, count(*) AS count_cORrect
        FROM step_student
        JOIN student USING (student_id)
        WHERE result = 'cORrect'
        GROUP BY student_name, step_id
        ORDER BY student_name, step_id 
    ),
    t4 AS (
        SELECT student_name, step_id, count(*) AS count
        FROM step_student
        JOIN student USING (student_id)
        WHERE result = 'wrong'
        GROUP BY student_name, step_id
        ORDER BY student_name, step_id 
    ),
    t5 AS (
        SELECT student_name, step_id, count(*) AS count
        FROM step_student
        JOIN student USING (student_id)
        GROUP BY student_name, step_id
        ORDER BY student_name, step_id
    )
    
SELECT 'I' AS Группа, t1.student_name AS Студент, count(t1.step_id) AS Количество_шагов
FROM t1
JOIN t2 USING (student_name, step_id)
WHERE max_wrong > mIN_cORrect
GROUP BY student_name
    UNION
SELECT 'II' AS Группа, student_name AS Студент, count(*) AS Количество_шагов
FROM t3
WHERE count_cORrect >= 2
GROUP BY student_name
    UNION
SELECT 'III' AS Группа, student_name AS Студент, count(*) AS Количество_шагов
FROM t4
JOIN t5 USING (student_name, step_id, count)
GROUP BY student_name
    
ORDER BY Группа, Количество_шагов DESC, Студент;

--------------------

WITH q1 AS
(
SELECT student_name, step_id, 
       SUM(CASE WHEN result = 'cORrect'
           THEN 1
           ELSE 0
           END) OVER(PARTITION BY student_name, step_id) AS count_cOR,
        (LAG(result) OVER(PARTITION BY student_name, step_id ORDER BY submISsion_time)) = 'cORrect' 
                AND result = 'wrong' AS IS_first
FROM student 
    INNER JOIN step_student USING(student_id)
)

SELECT CASE
            WHEN IS_first = 1 THEN 'I'
            WHEN count_cOR >= 2 THEN 'II'
            WHEN count_cOR = 0 THEN 'III'
        END AS 'Группа',
        student_name AS 'Студент',
        COUNT(DISTINCT step_id) AS Количество_шагов
FROM q1
GROUP BY 1, 2
HAVING Группа IS NOT NULL
ORDER BY 1, 3 DESC, 2;

--------------------

WITH table_1 (stud, step, res, sub_t, gr)
AS(
    SELECT  student_name, step_id, result, FROM_UNIXTIME(submISsion_time),
            CASE
                WHEN result="wrong" AND
                     LAG(result) OVER(PARTITION BY student_id, step_id
                                      ORDER BY submISsion_time) ="cORrect"
                THEN "I"
                WHEN SUM(IF(result="cORrect",1,0))
                     OVER(PARTITION BY student_id, step_id, result) > 1
                THEN "II"
                WHEN result="wrong" AND
                     SUM(IF(result="cORrect",1,0))
                     OVER(PARTITION BY student_id, step_id) = 0
                THEN "III"
            END AS gr
    FROM student INNER JOIN step_student USING (student_id)
   )
SELECT  gr AS Группа,
        stud AS Студент,
        COUNT(DISTINCT(step)) AS Количество_шагов
FROM table_1
WHERE gr = "I" OR gr = "II" OR gr = "III"
GROUP BY 1,2
ORDER BY 1,3 DESC, 2;

--------------------

WITH 
/* выделяем группу, в которой пользователи после верной попыткиделали неверную*/
get_attempt(stud, st,res_succ, res_pred)
AS(
  /* отбираем студентов, шаг, результат текущей попытки и предыдущей */  
  select student_id,  step_id, result,
  LAG(result) over (partition by student_id, step_id order by submission_time)
  FROM step_student 
),
get_student(stud_id,  st_id)
AS(
  /* выбираем различных студентов и шаги, в которых текущая попытка неверная, а предыдущая - верная*/  
  select DISTINCT stud, st
  FROM get_attempt
  WHERE res_succ = "wrong" and res_pred = "correct" 
),
/* выделяем группу, в которой пользователи совершали несколько верных попыток*/
get_student1(stud_id, st_id)
AS( 
   /* это те  шаги пользователей, в которых правильных попыток больше 1 */
  select student_id, step_id
  FROM step_student
  WHERE result = "correct" 
  GROUP BY student_id, step_id
  HAVING count(*) > 1
),
/* выделяем группу, в которой пользователи оставили нерешенными шаги */
get_step_result( stud, st, result)
AS(
  /* отбираем различные результаты студентов по каждому шагу */  
  SELECT DISTINCT student_id, step_id, result
  FROM step_student
),
get_step_count_result(stud, st, result, count_result)
AS(
  /* вычисляем количество результатов по каждому шагу*/  
  select stud, st, result, 
  count(result) over (partition by stud, st)
  from get_step_result
),
get_student2(stud_id, st_id)
AS(
  /* отбираем те шаги, в которых только неверные ответы*/   
  select stud, st
  FROM get_step_count_result
  WHERE result = "wrong" and count_result = 1
),
get_stud_group(student_id, count_step, gr)
AS(
  /* объединяем все группы */
  SELECT  stud_id, COUNT(st_id), "I"
  FROM get_student
  GROUP BY stud_id  
  UNION  ALL
  SELECT stud_id, COUNT(st_id), "II"
  FROM get_student1
  GROUP BY stud_id   
  UNION  ALL
  SELECT stud_id, COUNT(st_id), "III"
  FROM get_student2
  GROUP BY stud_id  
)
SELECT gr AS Группа, student_name AS Студент, count_step AS Количество_шагов
FROM get_stud_group INNER JOIN student USING(student_id)
ORDER BY 1, 3 DESC, 2;
========================================
