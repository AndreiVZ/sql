======================================== 1.1 Введение в транзакции
START TRANSACTION;
    UPDATE ...;
    SELECT ...;
    INSERT ...;
COMMIT;
----------------------------------------
START TRANSACTION;
    UPDATE ...;
    SELECT ...;
    INSERT ...;
ROLLBACK;
----------------------------------------
"""
Библиотека для демонстрации расширенных возможностей SQL в рамках курса по SQL.
Автор: Никита Шультайс
Сайт: https://shultais.education/
Лицензия: BSD
"""

import MySQLdb
import time
FROM texttable import Texttable
FROM pygments import highlight
FROM pygments.lexers import SqlLexer
FROM pygments.formatters import TerminalFormatter


class BColors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


class ExecuteError(Exception):
    pass


class MySQL:
    """
    Основной класс для работы с MySQL.
    """

    def __init__(self, echo=True, show_errors=False, auto_commit=False):
        """
        :param echo: печатает SQL запросы. 
        :param show_errors: печатает ошибки.
        """
        
        self.echo = echo
        self.show_errors = show_errors
        self.auto_commit = auto_commit

        self.db = MySQLdb.connect(host="127.0.0.1", user="", passwd="", db="", charset='utf8')
        self.cursor = self.db.cursor()

    def execute(self, sql):
        """
        Выполняет SQL запрос.
        """
        execute_error = False

        try:
            self.cursor.execute(sql)
        except Exception AS e:
            execute_error = True
            if self.show_errors:
                print(e)

        if self.echo:
            self.print_sql(self.cursor._last_executed.decode(), error=execute_error)

        if execute_error:
            raise ExecuteError

    def get_value(self, sql):
        self.cursor.execute(sql)
        if self.echo:
            self.print_sql(self.cursor._last_executed.decode())
        return self.cursor.fetchone()[0]

    def print_table(self, sql):
        self.cursor.execute(sql)
        if self.echo:
            self.print_sql(self.cursor._last_executed.decode())

        table = Texttable()
        table.add_rows(self.cursor.fetchall())
        print(table.draw())

    def print_sql(self, sql, error=False):
        """
        Выводит SQL запрос.
        """
        result = highlight(sql, SqlLexer(), TerminalFormatter())
        if error:
            result = "\033[91mERROR:\033[0m {}".format(result)
        print(result, end="")

    def call(self, name, args):
        """
        Вызов хранимой процедуры.
        """
        execute_error = False
        self.cursor.callproc(name, args)

        try:
            self.cursor.callproc(name, args)
        except Exception AS e:
            execute_error = True
            if self.show_errors:
                print(e)

        if self.echo:
            self.print_sql(self.cursor._last_executed.decode(), error=execute_error)

    def __del__(self):
        self.close()

    def close(self):
        if self.auto_commit:
            self.db.commit()
        self.cursor.close()

    def sleep(self, seconds):
        if self.echo:
            print("\033[92msleep {} second{}\033[0m".format(seconds, "s" if seconds > 1 else ""))
        time.sleep(seconds)
======================================== 1.2 ACID
Atomicity
Consistency
Isolation:
1. Read Uncommited
2. Read Commited
3. Repeatable Read
4. Serializable
Durability
======================================== 1.3 Потерянное обновление
Потерянное обновление возникает, когда последняя транзакция перезаписывает данные первых транзакций.

На уровне изоляции READ UNCOMMITED потерянные обновления, как правило, не возникают.
При использовании чистых UPDATE-запросов на уровне READ UNCOMMITED потерянные обновления возникать не будут.
На уровне изоляции READ UNCOMMITED потерянные обновления возникают, только если использовать промежуточные переменные.
----------------------------------------
SET TRANSACTION USOLATION LEVEL [READ UNCOMMITED]
----------------------------------------
SELECT @revenue := 100000;
======================================== 1.4 Грязное чтение
Одна из транзакций читает незафиксированные данные, которые будут отменены (ROLLBACK) другой транзакцией.

Если какая-то из транзакций уже изменила часть данных, но еще не завершила работу.
То на уровне READ COMMITTED другая транзакция видит данные, до того как первая транзакция начала выполнение.
При изоляции READ COMMITTED транзакция может прочитать только те данные, которые были зафиксированы с помощью COMMIT.
----------------------------------------
SET TRANSACTION USOLATION LEVEL [READ COMMITED]
======================================== 1.5 Неповторяющееся чтение
Неповторяющееся чтение возникает, когда два одинаковых или почти одинаковых SQL запроса получают разные данные в рамках одной транзакции.
----------------------------------------
SET TRANSACTION USOLATION LEVEL [REPEATABLE READ]
======================================== 1.6 Фантомное чтение
На четвертом уровне изоляции транзакции выполняются последовательно.
На четвертом уровне изоляции исключаются любые проблемы параллельного выполнения транзакций.
Четвертый уровень самый ресурсоемкий, его нужно использовать только в критических местах программ.
----------------------------------------
SET TRANSACTION USOLATION LEVEL [SERIALIZABLE]
======================================== 2.1 Хранимые процедуры
Хранимые процедуры позволяют объединить несколько SQL запросов в один блок.
Тело хранимой процедуры начинается с BEGIN и заканчивается END.
Хранимые процедуры вызываются с помощью команды CALL.
Хранимые процедуры хранятся на сервере баз данных.
----------------------------------------
Измененная хранимая процедура будет доступа для всех клиентов, которые подключены к базе данных.
Хранимые процедуры позволяют экономить трафик между клиентом и сервером.
Хранимую процедуру можно использовать многократно.
----------------------------------------
CREATE PROCEDURE order_payment(order_id INT, amount INT, payment_date DATETIME)
BEGIN
UPDATE orders SET status = 'paid' WHERE id = order_id;
INSERT INTO transactions (order_id, amount, date) VALUES (order_id, amount, payment_date);
END
----------------------------------------
CREATE PROCEDURE active_products()
BEGIN
SELECT id, name, count, price
FROM products
WHERE active = true AND count > 0
ORDER BY price;
END
----------------------------------------
CREATE PROCEDURE create_user(first_name VARCHAR(50), last_name VARCHAR(50), password VARCHAR(50))
BEGIN
INSERT INTO users (first_name, last_name, password) VALUES (first_name, last_name, SHA1(password));
END
----------------------------------------
CREATE PROCEDURE create_user(first_name VARCHAR(50), last_name VARCHAR(50), password VARCHAR(50))
BEGIN
INSERT INTO users (first_name, last_name, password) VALUES (trim(first_name), trim(last_name), SHA1(password));
END
======================================== 2.2 Транзакции в хранимых процедурах
Внутри хранимой процедуры можно объявлять транзакции.
Внутри хранимой процедуры можно использовать конструкции управления потоком выполнения: циклы, условия и тд.
======================================== 2.3 Хранимые функции
Хранимые функции вызываются без использования дополнительных команд.
Хранимые функции, в отличии от процедур, возвращают чистое значение.
Хранимые функции можно использовать в блоке WHERE наравне со встроенными функциями.
В базе данных может быть и хранимая процедура, и хранимая функция с одним именем.
======================================== 2.4 Переменные
Команда SET @client_id := 2; только присваивает переменной client_id двойку. Без вывода данных.
Команда SELECT @client_id := 2; присваивает переменной client_id двойку и сразу выводит значение.
Конструкция SET @client_id := 2, @last := CURDATE() - INTERVAL 7 DAY; присваивает значения сразу двум переменным.
При создании переменных можно использовать формулы, функции и операторы.
----------------------------------------
SELECT AVG(amount) INTO @avg_order FROM orders;
Сохраняет среднюю стоимость заказов в переменную avg_order.
======================================== 2.5 Переменные в хранимых процедурах
Переменные объявленные с помощью SELECT, будут доступны за пределами хранимой процедуры.
Переменные объявленные с помощью DECLARE доступны только внутри хранимой процедуры.
DECLARE позволяет задавать не только имя, но и тип переменной.
Объявлять переменные в хранимых процедурах нужно с помощью конструкции DECLARE.
----------------------------------------
DELIMITER $$
CREATE PROCEDURE get_sum(year INT, month INT)
BEGIN
    DECLARE lsum INT DEFAULT 0;
    DECLARE all_sum INT DEFAULT 0;
    
    SELECT SUM(amount) INTO @sum FROM orders 
    WHERE status = 'success' AND 
    YEAR(date) = year AND 
    MONTH(date) = month;
    
    SET lsum := @sum;
END $$
DELIMITER ;

SELECT @sum := 1000;
CALL get_sum(2015, 1);
SELECT @sum, @lsum, @all_sum;

# sum = 2450; lsum = NULL; all_sum = NULL
======================================== 2.6 Триггеры
Триггеры — это хранимые процедуры, которые выполняются автоматически при вставке, изменении и удалении данных в таблице.
Префикс OLD позволяет получить данные записи до её изменения.
Триггер AFTER DELETE будет выполняться после удаления записи в таблице.
Для одной таблицы можно создать до шести вариантов триггеров.
======================================== 2.7 Представления
Представление — это запрос на выборку, у которого есть имя и к которому можно обращаться как к отдельной таблице.
При SELECT-запросе к представлению сперва делается SELECT запрос к реальным таблицам.
Выборка из представлений обычно медленней, чем выборка из реальных таблиц.
Представления — это отличный способ скрыть от определенных пользователей часть данных.
----------------------------------------
Смешанные представления ограничивают таблицу и по вертикали, и по горизонтали.
Вертикальные представления возвращают только определенные столбцы таблицы.
Горизонтальные представления ограничивают доступ к определенным строкам таблицы.
======================================== 2.8 Ограничения и проверки
Примеры из урока
----------------------------------------
Создание таблицы:

CREATE TABLE products (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    ean13 VARCHAR(13) NOT NULL DEFAULT '',
    price INT UNSIGNED,
    sale INT UNSIGNED DEFAULT 0
)
----------------------------------------
Хранимая процедура:

DELIMITER $$
CREATE PROCEDURE check_product(ean13 VARCHAR(13), price INT, sale int)
BEGIN
    DECLARE i INT DEFAULT 1;
    IF LENGTH(ean13) NOT IN(0, 13) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Неверная длина ean13';
    ELSE
        WHILE i <= LENGTH(ean13) DO
            IF SUBSTRING(ean13, i, 1) NOT IN ('0','1','2','3','4','5','6','7','8','9') THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Неверный формат ean13';
            END IF;
            SET i = i + 1;
        END WHILE;
    END IF;
    
    IF sale > price THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'Значение скидки больше значения цены';
    END IF;
END$$
DELIMITER ;
----------------------------------------
Триггер:

DELIMITER $$
CREATE TRIGGER check_product_before_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
   CALL check_product(NEW.ean13, NEW.price, NEW.sale);
END$$
DELIMITER ;
----------------------------------------
С помощью хранимых процедур и триггеров можно делать не только проверки, но и преобразование данных перед добавлением, например удалять лишние пробелы.
Дополнительные проверки (с помощью триггеров и хранимых процедур) вводимых данных происходят на стороне сервера.
Чтобы сообщить внешней программе об ошибке используются сигналы.
======================================== 2.9 Блокировка таблиц
LOCK TABLES products [WRITE/READ];
...
UNLOCK TABLES;
----------------------------------------
Блокировки часто используются при массовом изменении таблиц.
В стандартном режиме работы базы данных, вместо блокировок лучше использовать транзакции.
Блокировка на чтение запрещает другим клиентами записывать данные в таблицу, но разрешает читать их.
Блокировка на запись запрещает другим клиентами и читать данные из таблицы, и записывать их.
======================================== 2.10 Анализ и оптимизация запросов
EXPLAIN SELECT ...
======================================== 3.1 Введение в оконные функции
Таблица orders

SET foreign_key_checks = 0;
DROP TABLE IF EXISTS orders;
SET foreign_key_checks = 1;
CREATE TABLE orders (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    user_id INTEGER NULL,
    date DATE NOT NULL,
    amount INTEGER NULL
);

INSERT INTO orders (id, user_id, date, amount)
VALUES
    (1, 138, '2021-01-01', 4500),
    (2, 491, '2021-01-02', 700),
    (3, 9841, '2021-01-04', 1200),
    (4, 174, '2021-01-04', 500),
    (5, 19, '2021-01-04', 8700),
    (6, 792, '2021-01-12', 1350),
    (7, 145, '2021-01-14', 600),
    (8, 491, '2021-02-01', 600),
    (9, 145, '2021-02-16', 1400),
    (10, 95, '2021-02-28', 4300),
    (11, 481, '2021-03-12', 8000),
    (12, 491, '2021-04-01', 980),
    (13, 45, '2021-04-14', 1600),
    (14, 671, '2020-12-30', 1500),
    (15, 145, '2020-12-31', 2500),
    (16, 891, '2020-12-29', 3500);
DELETE FROM orders WHERE id = 5;
----------------------------------------
SQL-запросы из урока

SELECT 
    *,
    SUM(amount) OVER() AS total,
    SUM(amount) OVER(PARTITION BY MONTH(date)) AS month_total,
    amount * 100 / SUM(amount) OVER(PARTITION BY MONTH(date)) AS percent
FROM orders
WHERE YEAR(date) = 2021;
----------------------------------------
SELECT month, year, sum(revenue) over() AS total_revenue
FROM revenues
ORDER BY year, month;
----------------------------------------
SELECT month, year, sum(revenue) over(PARTITION BY year) AS year_revenue
FROM revenues
ORDER BY year, month;
----------------------------------------
SELECT month, year, round(sum(revenue) over(PARTITION BY year, month) * 100 / sum(revenue) over(PARTITION BY year), 1) AS month_percent 
FROM revenues
ORDER BY year, month;
----------------------------------------
SELECT *, sum(population) over(PARTITION BY country) AS country_population
FROM cities
ORDER BY country_population, population;
----------------------------------------
SELECT *, sum(count * price) over() AS total
FROM products;
----------------------------------------
SELECT *, round(sum(count * price) over(PARTITION BY name) * 100 /  sum(count * price) over(), 1) AS percent
FROM products
ORDER BY percent DESC, id;
----------------------------------------
SELECT *, sum(population) over(PARTITION BY country) AS country_population, round(population * 100 / sum(population) over(PARTITION BY country), 2) AS percent
FROM cities
ORDER BY country_population, population;
----------------------------------------
SELECT *, round(population * 100 / sum(population) over(), 2) AS world_percent
FROM cities
ORDER BY world_percent DESC, id;
======================================== 3.2 Знакомство с неагрегирующими функциями
SELECT row_number() over() AS place, name, rating
FROM films
ORDER BY rating DESC;
----------------------------------------
SELECT row_number() over() AS line_num, order_id, product_id
FROM orders_products
ORDER BY order_id, product_id;
----------------------------------------
SELECT row_number() over() AS num, name, count, price
FROM products
ORDER BY price
LIMIT 10, 5;
======================================== 3.3 Сортировка в оконных функциях
SELECT genre, row_number() over(PARTITION BY genre ORDER BY rating DESC) AS genre_place, rating, name
FROM films
ORDER BY genre, genre_place;
----------------------------------------
SELECT *, row_number() over(ORDER BY points DESC) AS place
FROM results
ORDER BY id;
----------------------------------------
SELECT *, row_number() over(ORDER BY points DESC, time) AS place
FROM results
ORDER BY place;
----------------------------------------
SELECT name, rating, genre
FROM (
    SELECT name, rating, genre, row_number() over(PARTITION BY genre ORDER BY rating DESC) AS place
    FROM films
) AS t
WHERE place <= 2
ORDER BY rating DESC;
----------------------------------------
SELECT 
    floor(year / 10) * 10 AS decade,
    -- TRUNCATE(year, -1) AS decade,
    row_number() over(PARTITION BY floor(year / 10) * 10 ORDER BY rating DESC) AS place,
    name
FROM films;
======================================== 3.4 Фильтрация в оконных функциях
SELECT user_id AS id, first_name, last_name, date_format(date, '%d.%m.%Y') AS vip_date
FROM (
    SELECT s.user_id, s.date, u.first_name, u.last_name,
        row_number() over(PARTITION BY s.user_id ORDER BY s.date) AS order_num
    FROM sales AS s
    LEFT JOIN users AS u ON u.id = s.user_id
    WHERE s.status = 'success'
) AS t
WHERE order_num = 2
ORDER BY id;
======================================== 3.5 Понимание окон
SELECT row_number() over(ORDER BY subs DESC, avg_likes DESC, avg_comments DESC) AS num, blogger, subs, avg_likes, avg_comments
FROM bloggers
ORDER BY num;
----------------------------------------
SELECT row_number() over(PARTITION BY blogger ORDER BY likes DESC) AS post_popularity, blogger, post, likes
FROM bloggers_posts
ORDER BY blogger, post_popularity;
----------------------------------------
SELECT blogger, post, likes, sum(likes) over() AS total_likes, round(likes * 100 / sum(likes) over(), 2) AS percent
FROM (
    SELECT row_number() over(PARTITION BY blogger ORDER BY likes DESC) AS post_popularity, blogger, post, likes
    FROM bloggers_posts
) AS t
WHERE post_popularity = 1
ORDER BY likes DESC;
----------------------------------------
SELECT blogger, post, likes, (SELECT sum(likes) FROM bloggers_posts) AS total_likes, round(likes * 100 / (SELECT sum(likes) FROM bloggers_posts), 2) AS percent
FROM (
    SELECT row_number() over(PARTITION BY blogger ORDER BY likes DESC) AS post_popularity, blogger, post, likes
    FROM bloggers_posts
) AS t
WHERE post_popularity = 1
ORDER BY likes DESC;


SET @total_likes = (SELECT sum(likes) FROM bloggers_posts);
SELECT blogger, post, likes, @total_likes AS total_likes, round(likes * 100 / @total_likes, 2) AS percent
FROM (
    SELECT row_number() over(PARTITION BY blogger ORDER BY likes DESC) AS post_popularity, blogger, post, likes
    FROM bloggers_posts
) AS t
WHERE post_popularity = 1
ORDER BY likes DESC;
======================================== 3.6 Сортировка для агрегирующих функций
Аггрегирующие функции (SUM, MAX, MIN, AVG, COUNT) + ORDER BY = данные нарастающим итогом
с ORDER BY - построчная обработка
без ORDER BY - весь сегмент целиком
----------------------------------------
SELECT *, sum(money) over(ORDER BY date, id) AS balance
FROM transactions
ORDER BY date, id;
----------------------------------------
SELECT *, sum(money) over(ORDER BY date, id) AS balance
FROM (
    SELECT id, date, item, money
    FROM transactions
    UNION
    SELECT 0 AS id, '2022-01-01' AS date, 'Начальный баланс' AS item, 10000 AS money
) AS t
ORDER BY date, id;
----------------------------------------
SELECT *, sum(income - outcome) over (ORDER BY year, month) AS ror
FROM revenues;
----------------------------------------
SELECT min(ror) AS investment
FROM (SELECT *, sum(income - outcome) over (ORDER BY year, month) AS ror
    FROM revenues
) AS t;
----------------------------------------
SELECT count(ror) + 1 AS months
FROM (SELECT *, sum(income - outcome) over (ORDER BY year, month) AS ror
    FROM revenues
) AS t
WHERE ror < 0;
======================================== 3.7 Группировка и оконные функции
Сначала данные (JOIN, агрегация, подзапросы)
Потом оконная аналитика
----------------------------------------
SELECT quarter, sum(income) AS income, sum(sum(income)) over(ORDER BY quarter) AS income_acc, round(sum(sum(income)) over(ORDER BY quarter) * 0.06, 2) AS usn6
FROM (
    SELECT *,
        CASE
            WHEN month(date) in (1, 2, 3) THEN 1
            WHEN month(date) in (4, 5, 6) THEN 2
            WHEN month(date) in (7, 8, 9) THEN 3
            WHEN month(date) in (10, 11, 12) THEN 4
        END AS quarter
    FROM transactions
    ORDER BY quarter, id
) AS t
GROUP BY quarter
ORDER BY quarter;
----------------------------------------
SELECT
    sex,
    count(*) AS members,
    count(*) * 100 / sum(count(*)) over () AS percent
    # count(*) * 100 / (SELECT count(*) FROM users) AS percent
FROM users
GROUP BY sex
ORDER BY percent;


(!) SELECT count(*) FROM users = sum(count(*)) over ()
----------------------------------------
SELECT
    row_number() over(ORDER BY age) AS age_num,
    age,
    count(*) AS clients,
    count(*) * 100 / sum(count(*)) over () AS percent
FROM users
GROUP BY age
ORDER BY age;
----------------------------------------
SELECT year(date) AS year, status, count(status) AS orders, count(status) * 100 / sum(count(status)) over(PARTITION BY year(date)) AS percent
FROM orders
GROUP BY year(date), status
ORDER BY year, status;
----------------------------------------
SELECT year(date) AS year, user_id, sum(amount) AS amount, sum(amount) * 100 / sum(sum(amount)) over(PARTITION BY year(date)) AS percent
FROM orders
WHERE status = 'success'
GROUP BY year(date), user_id
ORDER BY year, percent;
======================================== 3.8 Ранжирование с помощью RANK и DENSE_RANK
SELECT street, house, price, rooms
FROM (
    SELECT *, rank() over(ORDER BY price) AS rank_num
    FROM flats
    WHERE rooms > 1
) AS t
WHERE rank_num <= 3
ORDER BY rooms DESC, price;
----------------------------------------
SELECT rooms, street, house, price
FROM (
    SELECT *, rank() over(PARTITION BY rooms ORDER BY price) AS rank_num
    FROM flats
    WHERE rooms > 1
) AS t
WHERE rank_num <= 3
ORDER BY rooms, price;
----------------------------------------
SELECT street, house, price, rooms
FROM (
    SELECT *, dense_rank() over(ORDER BY price) AS rank_num
    FROM flats
    WHERE rooms > 1
) AS t
WHERE rank_num <= 3
ORDER BY price, rooms DESC;
----------------------------------------
SELECT dense_rank() over(ORDER BY sum(cr.kills - 3 * cr.deaths) DESC) AS place, ct.team, sum(cr.kills - 3 * cr.deaths) AS points
FROM cyber_results AS cr
LEFT JOIN cyber_teams AS ct ON ct.id = cr.team_id
LEFT JOIN cyber_games AS cg ON cg.id = cr.game_id
GROUP BY ct.team
ORDER BY place, ct.team;
======================================== 3.9 Именованные окна
1. Именованное окно с сегментами и сортировкой

SELECT
    ROW_NUMBER() OVER (by_month) AS order_num,
    RANK() OVER (by_month) AS rank_num,
    DENSE_RANK() OVER (by_month) AS dense_num,
    user_id, amount, date
FROM orders
WHERE YEAR(date) = 2021
WINDOW by_month AS (
    PARTITION BY YEAR(date), MONTH(date)
    ORDER BY date)
ORDER BY date, id;
----------------------------------------
2. Именованное окно только с сегментами. 
Сортировка происходит в окнах в блоке SELECT

SELECT
    ROW_NUMBER() OVER (
        by_month ORDER BY date) AS order_num,
    RANK() OVER (
        by_month ORDER BY amount) AS rank_num,
    DENSE_RANK() OVER (
        by_month ORDER BY user_id) AS dense_num,
    user_id, amount, date
FROM orders
WHERE YEAR(date) = 2021
WINDOW by_month AS (
    PARTITION BY YEAR(date), MONTH(date)
)
ORDER BY date, id;
======================================== 3.10 Ранжирование с помощью NTILE
SELECT ntile(3) over(ORDER BY id) AS mail_variant, id, email, first_name
FROM users
ORDER BY id;
----------------------------------------
SELECT ntile(4) over(ORDER BY MD5(email)) AS mail_variant, id, email, first_name
FROM users
ORDER BY id;
----------------------------------------
SELECT s.name AS name, u.first_name, u.last_name, sum(o.amount) AS amount, ntile(4) over(PARTITION BY s.name ORDER BY sum(o.amount) DESC) AS c_level
FROM orders AS o
LEFT JOIN users AS u ON u.id = o.user_id
LEFT JOIN shops AS s ON s.id = o.shop_id
WHERE o.status = 'success'
GROUP BY s.name, u.first_name, u.last_name
ORDER BY name, c_level;
----------------------------------------
SELECT month, first_name, last_name, amount
FROM (
    SELECT month(o.date) AS month, u.first_name, u.last_name, sum(o.amount) AS amount, ntile(4) over(PARTITION BY month(o.date) ORDER BY sum(o.amount) DESC) AS c_level
    FROM orders AS o
    LEFT JOIN users AS u ON u.id = o.user_id
    WHERE o.status = 'success'
    GROUP BY month(o.date), u.first_name, u.last_name
) AS t
WHERE c_level = 1
ORDER BY month, amount;
======================================== 3.11 Статистическое ранжирование
PERCENT_RANK() OVER() ...
CUME_DIST() OVER() ...
======================================== 3.12 Опережение и отставание
SELECT month, income AS in2020, lead(income, 12) over() AS in2021, lead(income, 12) over() - income AS diff
FROM revenues
ORDER BY year, month
LIMIT 12;
----------------------------------------
SELECT quarter, sum(in2020) AS in2020, sum(in2021) AS in2021, sum(diff) AS diff
FROM (
    SELECT 
        CASE
            WHEN month in (1, 2, 3) THEN 1
            WHEN month in (4, 5, 6) THEN 2
            WHEN month in (7, 8, 9) THEN 3
            WHEN month in (10, 11, 12) THEN 4
        END AS quarter,
        income AS in2020, lead(income, 12) over() AS in2021, lead(income, 12) over() - income AS diff
    FROM revenues
    ORDER BY year, month
    LIMIT 12
) AS t
GROUP BY quarter
ORDER BY quarter;
----------------------------------------
SELECT month, round(lead(income, 12) over() * (lead(income, 12) over() / income)) AS plan
FROM revenues
ORDER BY year, month
LIMIT 12;
======================================== 3.13 Сравнение с первым и последним (FIRST_VALUE, LAST_VALUE)
SELECT
    dense_rank() over(ORDER BY end_time - start_time) AS place,
    last_name,
    first_name,
    time_format(TIMEDIFF(end_time, start_time), '%H:%i:%s') AS time,
    time_format(TIMEDIFF(TIMEDIFF(end_time, start_time), first_value(TIMEDIFF(end_time, start_time)) over(ORDER BY TIMEDIFF(end_time, start_time))), '%H:%i:%s') AS champion_lag
FROM runners
ORDER BY place;
======================================== 3.14 Функция NTH_VALUE
======================================== 3.15 Фреймы
Режим по умолчанию для FIRST_VALUE, LAST_VALUE, NTH_VALUE и функций агрегации:
over(... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
over(... ROWS UNBOUNDED PRECEDING)
PRECEDING/FOLLOWING
----------------------------------------
SELECT
    month, income,
    income - nth_value(income, 4) over(ORDER BY month rows between unbounded preceding and unbounded following) AS diff,
    round(income * 100 / nth_value(income, 4) over(ORDER BY month rows between unbounded preceding and unbounded following) - 100, 1) AS diff_percent
FROM revenues
WHERE year = 2021
ORDER BY month;
----------------------------------------
SELECT
    year, month, income,
    income - nth_value(income, 4) over(PARTITION BY year ORDER BY month rows between unbounded preceding and unbounded following) AS diff,
    round(income * 100 / nth_value(income, 4) over(PARTITION BY year ORDER BY month rows between unbounded preceding and unbounded following) - 100, 1) AS diff_percent
FROM revenues
ORDER BY year, month;
======================================== 3.16 Фреймы и функции агрегации
SELECT
    month,
    round(income *
        avg(income) over(ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) /
        avg(income) over(ROWS BETWEEN 14 PRECEDING AND 12 PRECEDING)) AS plan
FROM revenues
ORDER BY year, month
LIMIT 12, 12;
======================================== 3.17 Фреймы и интервалы дат
over(RANGE BETWEEN INTERVAL 5 DAY PRECEDING AND INTERVAL 5 DAY FOLLOWING)
======================================== 3.18 ROWS и RANGE во фреймах
======================================== 3.19 Удаление дубликатов с помощью ROW_NUMBER
ИСХОДНАЯ ТАБЛИЦА

CREATE TABLE orders_products (
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL
);
INSERT INTO orders_products (order_id, product_id) 
VALUES
(1, 4),
(5, 7),
(4, 1),
(3, 1),
(8, 2),
(7, 5),
(11, 4),
(8, 9),
(2, 12),
(5, 1),
(7, 5),
(8, 2),
(9, 9),
(12, 1),
(13, 5),
(8, 2),
(11, 5),
(7, 2),
(1, 4),
(4, 6);
----------------------------------------
РЕШЕНИЕ С WITH И ОКОННЫМИ ФУНКЦИЯМИ

-- Создаем новый столбец
ALTER TABLE orders_products
ADD COLUMN products_count INTEGER DEFAULT 1;

WITH
    -- Удаляем данные из orders_products и сохраняем их копию в deleted_table
    deleted_table AS (
        DELETE FROM orders_products RETURNING *
    ),
    -- На основе deleted_table формируем таблицу для вставки
    inserted_table AS (
        SELECT
            ROW_NUMBER() OVER(
                PARTITION BY order_id, product_id
                ORDER BY order_id
            ) AS row_num,
            order_id,
            product_id,
            COUNT(*) OVER(
                PARTITION BY order_id, product_id
            ) AS products_count
        FROM
        deleted_table
    )
-- Вставляем данные из inserted_table в orders_products
INSERT INTO orders_products
SELECT order_id, product_id, products_count FROM inserted_table
WHERE row_num = 1;

-- Создаем уникальный индекс по двум полям
CREATE UNIQUE INDEX op ON orders_products (order_id, product_id);
----------------------------------------
РЕШЕНИЕ С WITH И ГРУППИРОВКОЙ

Для решения задачи можно обойтись и без оконных функций и использовать обычную группировку.

ALTER TABLE orders_products ADD COLUMN products_count INTEGER DEFAULT 1;

WITH 
    deleted_table AS (
        DELETE FROM orders_products RETURNING *),
    inserted_table AS (
        SELECT
            order_id, 
            product_id,
            COUNT(*) AS products_count
        FROM deleted_table
        GROUP BY order_id, product_id
    )
INSERT INTO orders_products 
SELECT order_id, product_id, products_count FROM inserted_table;

CREATE UNIQUE INDEX op ON orders_products (order_id, product_id);
----------------------------------------
РЕШЕНИЕ ЗАДАЧИ В MYSQL

Данную задачу можно решить и в MySQL. Для этого придется создать временную таблицу и заполнить её правильными данными. А после удалить текущую таблицу и переименовать временную.

-- Создаем временную таблицу
CREATE TABLE temp_orders_products (
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    products_count INTEGER NOT NULL
);

-- Заполняем временную таблицу данными
INSERT INTO temp_orders_products (order_id, product_id, products_count)
    SELECT order_id, product_id, products_count FROM (
        SELECT
            ROW_NUMBER() OVER(
                PARTITION BY order_id, product_id ORDER BY order_id) AS row_num,
            order_id, product_id,
            COUNT(*) OVER(PARTITION BY order_id, product_id) AS products_count
        FROM orders_products) t
    WHERE row_num = 1;

-- Удаляем оригинальную orders_products
DROP TABLE orders_products;

-- Переименовываем временную
RENAME TABLE temp_orders_products TO orders_products;
----------------------------------------
РЕШЕНИЕ В MYSQL С ПОМОЩЬЮ ГРУППИРОВКИ
CREATE TABLE temp_orders_products (
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    products_count INTEGER NOT NULL
);

INSERT INTO temp_orders_products (order_id, product_id, products_count)
    SELECT order_id, product_id, products_count FROM (
        SELECT
            order_id, 
            product_id,
            COUNT(*) AS products_count
        FROM orders_products
        GROUP BY order_id, product_id) t;
    
DROP TABLE orders_products;
RENAME TABLE temp_orders_products TO orders_products;
========================================
