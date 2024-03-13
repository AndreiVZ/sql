======================================== 2.2 Ранжирование
Оконные функции ранжирования:

row_number() - порядковый номер строки
dense_rank() - ранг строки
rank() - тоже ранг, но с пропусками
ntile(n) - разбивает все строки на n групп и возвращает номер группы, в которую попала строка
----------------------------------------
select
    ntile(2) over w as tile,
    name, city, salary
from employees
window w as (partition by city order by salary, id)
order by city, salary;
----------------------------------------
select id, name, department, salary
from (
    select *, rank() over(partition by department order by salary desc) as rank_
    from employees
) as t
where rank_ = 1
order by id;
======================================== 2.3 Смещение
Оконные функции смещения:

lag(value, offset) - значение value из строки, отстоящей на offset строк назад от текущей
lead(value, offset) - значение value из строки, отстоящей на offset строк вперед от текущей
first_value(value) - значение value из первой строки фрейма
last_value(value) - значение value из последней строки фрейма
nth_value(value, n) - значение value из n-й строки фрейма
----------------------------------------
Подытожим принцип, по которому работают first_value() и last_value():

Есть окно, которое состоит из одной или нескольких секций (partition by department).
Внутри секции записи упорядочены по конкретному столбцу (order by salary).
У каждой записи в секции свой фрейм. По умолчанию начало фрейма совпадает с началом секции, а конец для каждой записи свой.
Конец фрейма можно приклеить к концу секции, чтобы фрейм в точности совпадал с секцией.
Функция first_value() возвращает значение из первой строки фрейма.
Функция last_value() возвращает значение из последней строки фрейма.
----------------------------------------
select
    name, department,
    lag(salary, 1) over (order by salary, id) as prev,
    salary,
    lead(salary, 1) over (order by salary, id) as next
from employees
order by salary, id;
----------------------------------------
select
    name, city, salary,
    round(salary * 100 / last_value(salary) over w) as percent
from employees
window w as (
    partition by city
    order by salary
    rows between unbounded preceding and unbounded following
)
order by city, salary;


select
    name, city, salary,
    round(salary * 100 / max(salary) over w) as percent
from employees
window w as (
    partition by city
)
order by city, salary;
======================================== 2.4 Агрегация
Оконные функции агрегации:

min(value) - минимальное value среди строк, входящих в окно
max(value) - максимальное value
count(value) - количество value , не равных null
avg(value) - среднее значение по всем value
sum(value) - сумма значений value
group_concat(value, separator) - строка, которая соединяет значения value через разделитель separator в SQLite и MySQL
string_agg(value, separator) - аналог group_concat() в PostgreSQL и MS SQL
----------------------------------------
Вот в какой последовательности действует движок, когда выполняет запрос:

Взять нужные таблицы (from) и соединить их при необходимости (join).
Отфильтровать строки (where).
Сгруппировать строки (group by).
Отфильтровать результат группировки (having).
Взять конкретные столбцы из результата (select).
Рассчитать значения оконных функций (function() over window).
Отсортировать то, что получилось (order by).
----------------------------------------
select
    name, city, salary,
    sum(salary) over w as fund,
    round(salary * 100 / sum(salary) over w) as perc
from employees
window w as (partition by city)
order by city, salary;
----------------------------------------
select
    name, department, salary,
    count(*) over w as emp_cnt,
    round(avg(salary) over w) as sal_avg,
    round((salary - avg(salary) over w) * 100 / avg(salary) over w) as diff
from employees
window w as (partition by department)
order by department, salary, id;
======================================== 2.5 Скользящие агрегаты
Скользящие агрегаты используют те же самые функции, что и агрегаты обычные:

min() и max()
count(), avg() и sum()
group_concat()
Разница только в наличии фрейма у скользящих агрегатов.
----------------------------------------
В общем случае определение фрейма выглядит так:
rows between X preceding and Y following

Где X — количество строк перед текущей, а Y — количество строк после текущей
Если указать вместо X или Y значение unbounded — это значит «граница секции»
Если указать вместо X preceding или Y following значение current row — это значит «текущая запись»
Фрейм никогда не выходит за границы секции, если столкнулся с ней — обрезается
----------------------------------------
Правило такое:

если в окне есть order by,
и используется функция агрегации,
и не указано определение фрейма,
то используется фрейм по умолчанию.
(rows between unbounded preceding and current row)
----------------------------------------
select year, month, income,
    round(avg(income) over(order by year, month rows between 1 preceding and current row)) as roll_avg
from expenses
order by year, month;
----------------------------------------
select
    id, name, department, salary,
    sum(salary) over w as total
from employees
window w as (
    partition by department
    order by id
    rows between unbounded preceding and current row
)
order by department, salary, id;
======================================== 2.6 Статистика
cume_dist() и percent_rank() во многом похожи на функцию ранжирования rank():

rank() считает абсолютный ранг строки (ее место относительно других строк согласно order by окна)
cume_dist() и percent_rank() считают относительный ранг (в процентах относительно других строк).
Как и rank(), cume_dist() и percent_rank() имеют смысл только при заданном order by окна. Как и rank(), они поддерживают секции (partition by) и не поддерживают фреймы.
----------------------------------------
select 
    wdate, wtemp,
    round(cume_dist() over w, 2) as cd,
    round(percent_rank() over w, 2) as pr
from weather
where month(wdate) = 3
window w as (order by wtemp)
order by wtemp desc
limit 5;
----------------------------------------
select 
    wdate, wtemp,
    round(cume_dist() over w, 2) as perc
from weather
where month(wdate) = 3
window w as (order by wtemp)
order by wdate
limit 5;
----------------------------------------
select *
from (
    select 
        wdate, wtemp,
        round(cume_dist() over w, 2) as perc
    from weather
    window w as (partition by month(wdate) order by month(wdate), wtemp)
    order by wdate) t1
where day(wdate) = 7;
----------------------------------------
Процентиль как оконная функция
Процентиль как функция агрегации задается так:
percentile_disc(PERCENT) within group (order by COLUMN)
Где PERCENT — порог процентиля (десятичная дробь от 0 до 1), а COLUMN — столбец, по которому считается процентиль.

Единственная часть «окошек», которую поддерживает процентиль — секции (partition by). Сортировка не поддерживается (она уже задана в within group), фреймы тоже. Полный синтаксис выглядит так:

percentile_disc(PERCENT) within group (order by COLUMN) over (partition by OTHER_COLUMNS)
----------------------------------------
Помимо percentile_disc() существует функция percentile_cont():

percentile_disc рассматривает набор данных как дискретный (то есть состоящий из отдельных значений). Всегда возвращает конкретное значение из тех, что есть в таблице.
percentile_cont рассматривает набор данных как непрерывный (как будто значения в наборе — это выборка из некоторого непрерывного распределения данных). Рассчитывает процентиль аналитически по формуле.
---------------------------------------- PostgreSQL v15
select
    extract(month from wdate) as month,
    round(avg(wtemp)::decimal, 2) as t_avg,
    percentile_disc(0.50) within group (order by wtemp) as t_med,
    percentile_disc(0.90) within group (order by wtemp) as t_p90
from weather
group by month;
----------------------------------------
Статистические функции
Оконные функции для расчета статистик:

Функция Описание
cume_dist() процент строк, которые меньше либо равны текущей
percent_rank()  процент строк, которые строго меньше текущей
percentile_disc(N)  N-й процентиль дискретного распределения
percentile_cont(N)  N-й процентиль непрерывного распределения
cume_dist() и percent_rank() поддерживают сортировку и секции в окне, а percentile_disc() и percentile_cont() — только секции.

Все статистические функции не поддерживают фреймы.
======================================== 2.7 Резюме
Вот задачи, которые решаются с помощью оконных функций в SQL:

1. Ранжирование (всевозможные рейтинги).
2. Сравнение со смещением (соседние элементы и границы).
3. Агрегация (количество, сумма и среднее).
4. Скользящие агрегаты (сумма и среднее в динамике).
5. Статистика (относительные ранги и сводные показатели).

Оконные функции вычисляют результат по строкам, которые попали в окно. Определение окна указывает, как выглядит окно:

1. Из каких секций состоит (partition by).
2. Как отсортированы строки внутри секции (order by).
3. Как выглядит фрейм внутри секции (rows between).

window w as (
  partition by ...
  order by ...
  rows between ... and ...
)

partition by поддерживается всеми оконными функциями и всегда необязательно. Если не указать — будет одна секция.
order by поддерживается всеми оконными функциями. Для функций ранжирования и смещения оно обязательно, для агрегации — нет. Если не указать order by для функции агрегации — она посчитает обычный агрегат, если указать — скользящий.

Фрейм поддерживается только некоторыми функциями:
- first_value(), last_value(), nth_value();
- функции агрегации.
Остальные функции фреймы не поддерживают.

SQLite реализует оконные функции точно так же, как PostgreSQL, так что если придется работать с постгресом — вам уже все известно.
----------------------------------------
⚪ — необязательно
🔵 — обязательно
🔴 — не поддерживается
----------------------------------------
Функции ранжирования

Функция       Секции  Сортировка  Фрейм  Описание
row_number()    ⚪       🔵       🔴    порядковый номер строки
dense_rank()    ⚪       🔵       🔴    ранг строки
rank()          ⚪       🔵       🔴    ранг  с пропусками
ntile(n)        ⚪       🔵       🔴    номер группы
----------------------------------------
Функции смещения

Функция              Секции  Сортировка  Фрейм  Описание
lag(value, n)          ⚪       🔵       🔴    значение из n-й строки назад
lead(value, n)         ⚪       🔵       🔴    значение из n-й строки вперед
first_value(value)     ⚪       🔵       🔵    значение из первой строки фрейма
last_value(value)      ⚪       🔵       🔵    значение из последней строки фрейма
nth_value(value, n)    ⚪       🔵       🔵    значение из n-й строки фрейма
----------------------------------------
Функции агрегации

Функция                 Секции  Сортировка  Фрейм  Описание
min(value)                ⚪       ⚪       ⚪    минимальное из секции или фрейма
max(value)                ⚪       ⚪       ⚪    максимальное из секции или фрейма
count(value)              ⚪       ⚪       ⚪    количество по секции или фрейму
avg(value)                ⚪       ⚪       ⚪    среднее по секции или фрейму
sum(value)                ⚪       ⚪       ⚪    сумма по секции или фрейму
group_concat(val, sep)    ⚪       ⚪       ⚪    строковое соединение по секции или фрейму
----------------------------------------
Функции статистики

Функция             Секции  Сортировка  Фрейм  Описание
cume_dist()           ⚪       🔵       🔴    процент строк, которые меньше либо равны текущей
percent_rank()        ⚪       🔵       🔴    процент строк, которые строго меньше текущей
percentile_disc(n)    ⚪     w/group     🔴    N-й процентиль дискретного распределения
percentile_cont(n)    ⚪     w/group     🔴    N-й процентиль непрерывного распределения
======================================== 3.1 ROWS и GROUPS
В общем виде определение фрейма выглядит так:
ROWS BETWEEN frame_start AND frame_end

Начало фрейма (frame_start) может быть:
current row — начиная с текущей строки;
N preceding — начиная с N-й строки перед текущей;
N following — начиная с N-й строки после текущей;
unbounded preceding — начиная с границы секции.

Аналогично, конец фрейма (frame_end) может быть:
current row — до текущей строки;
N preceding — до N-й строки перед текущей;
N following — до N-й строки после текущей;
unbounded following — до границы секции.

Только у некоторых функций фрейм настраивается:
функции смещения first_value(), last_value(), nth_value();
все функции агрегации: count(), avg(), sum(), ...
----------------------------------------
select id, name, department, salary,
    min(salary) over(partition by department order by salary, id ROWS BETWEEN 1 preceding AND current row) as prev_salary,
    max(salary) over(partition by department) as max_salary
from employees
order by department, salary, id;
----------------------------------------
Кроме фрейма по строкам (ROWS) бывают еще фреймы по группам (GROUPS) и диапазону (RANGE):

ROWS BETWEEN frame_start AND frame_end
GROUPS BETWEEN frame_start AND frame_end
RANGE BETWEEN frame_start AND frame_end

Инструкции для границ группового фрейма используются такие же, как для строкового, но смысл их отличается:

current row — текущая группа (а не текущая строка);
N preceding / following — N-я группа относительно текущей (а не N-я строка);
unbounded preceding / following — граница секции (как у строкового фрейма).
----------------------------------------
select id, name, salary,
    count(*) over(order by salary GROUPS BETWEEN current row AND unbounded following) as ge_cnt
from employees
order by salary, id;

11  Дарья   70  10
12  Борис   78  9
21  Елена   84  8
22  Ксения  90  7
31  Вероника    96  6
32  Григорий    96  6
33  Анна    100 4
23  Леонид  104 3
24  Марина  104 3
25  Иван    120 1


select id, name, salary,
    count(*) over(order by salary ROWS BETWEEN current row AND unbounded following) as ge_cnt
from employees
order by salary, id;

id  name    salary  ge_cnt
11  Дарья   70  10
12  Борис   78  9
21  Елена   84  8
22  Ксения  90  7
31  Вероника    96  6
32  Григорий    96  5
33  Анна    100 4
23  Леонид  104 3
24  Марина  104 2
25  Иван    120 1
----------------------------------------
select id, name, salary,
    max(salary) over(order by salary GROUPS BETWEEN 1 following AND 1 following) as next_salary 
from employees
order by salary, id;
----------------------------------------
Мы рассмотрели строковые (rows) и групповые (groups) фреймы:
- rows-фрейм оперирует отдельными записями;
- groups-фрейм оперирует группами записей (группа включает все строки с одинаковым значением столбцов из order by).

Групповые фреймы есть смысл использовать, если в order by окна указан неуникальный набор столбцов. Например, order by department или order by city создает группы строк с одинаковым департаментом или городом — и тут групповой фрейм уместен.
А order by department, id задает уникальную сортировку (не может быть двух строк с одинаковым значением id) — так что здесь groups не имеет смысла.
======================================== 3.2 RANGE
Последний тип фрейма — фрейм по диапазону:
RANGE BETWEEN frame_start AND frame_end

У диапазонных фреймов несколько особенностей:

1. Только один столбец в order by
Поскольку range-фрейм динамически рассчитывается по вхождению в диапазон between .. and .., то в order by должен быть ровно один столбец. Так не получится:
window w as (
  order by salary, city
  range between 10 preceding and 10 following
)

2. Только числа или даты для N preceding / following
Условия N preceding и N following работают только для числовых столбцов и столбцов с датами. Например, такой фрейм лишен смысла:
window w as (
  order by department
  range between 10 preceding and 10 following
)

3. current row — как у groups-фрейма
Условие current row для range-фрейма работает так же, как для groups-фрейма — включает строки с одинаковым значением столбца из order by. Условия unbounded preceding и unbounded following для всех типов фреймов работают одинаково — включает строки от начала секции (unbounded preceding) и до конца секции (unbounded following).
----------------------------------------
select id, name, salary,
    count(*) over(order by salary range between current row and 10 following) as p10_cnt
from employees
order by salary, id;
----------------------------------------
select id, name, salary,
    max(salary) over(order by salary range between 30 preceding and 10 preceding) as lower_sal
from employees
order by salary, id;
----------------------------------------
Границы фрейма
Все типы фреймов — rows, groups и range — используют одни и те же инструкции, чтобы задать границы:

unbounded preceding / following,
N preceding / following,
current row.
Но трактовка этих инструкций может отличаться в зависимости от типа фрейма.

Инструкции unbounded preceding и unbounded following всегда означают границы секции:

current row для строковых фреймов означает текущую запись, а для груповых и диапазонных — текущую запись и все равные ей (по значениям из order by):

N preceding и N following означают:
для строковых фреймов — количество записей до / после текущей;
для групповых фреймов — количество групп до / после текущей;
для диапазонных фреймов — диапазон значений относительно текущей записи.
----------------------------------------
Фрейм по умолчанию
Если фрейм не указан явно, используется такой:
RANGE BETWEEN unbounded preceding AND current row

Умолчательный фрейм охватывает записи от начала секции до конца текущей группы (группа образована из записей с одинаковыми значениями order by).

Все сказанное относится только к функциям, у которых фрейм настраивается:
функции смещения first_value(), last_value(), nth_value();
все функции агрегации: count(), avg(), sum(), ...
У прочих функций фрейм всегда равен секции.
======================================== 3.3 EXCLUDE
Теперь определение фрейма выглядит так:
{ ROWS | GROUPS | RANGE } BETWEEN frame_start AND frame_end

Виды исключений
Стандарт SQL предусматривает четыре разновидности EXCLUDE:
1. EXCLUDE NO OTHERS. Ничего не исключать. Вариант по умолчанию: если явно не указать exclude, сработает именно он.
2. EXCLUDE CURRENT ROW. Исключить текущую запись (как мы сделали на предыдущем шаге с сотрудником).
3. EXCLUDE GROUP. Исключить текущую запись и все равные ей (по значению столбцов из order by).
4. EXCLUDE TIES. Оставить текущую запись, но исключить равные ей.
----------------------------------------
select id, name, salary,
    round(avg(salary) over(
        order by salary
        range between current row and 20 following
        exclude current row)) as p20_sal
from employees
order by salary, id;
---------------------------------------- 3.4 FILTER
select
    id, name, salary,
    round(salary * 100 / avg(salary) over ()) as perc,
    round(salary * 100 / avg(salary) filter(where city <> 'Самара') over ()) as msk,
    round(salary * 100 / avg(salary) filter(where city <> 'Москва') over ()) as sam
from employees
order by id;
----------------------------------------
select
    name, city,
    sum(salary) over w as base,
    -- sum(salary) filter(where department <> 'it') over w as no_it,
    sum(case when department != 'it' then salary else 0 end) over w as no_it
from employees
window w as (partition by city)
order by city, id;
----------------------------------------
select
    name, city,
    sum(salary) over w as base,
    round(sum(
        case
            when department = 'hr' then salary * 2
            when department = 'it' then salary / 2
            else salary
        end
) over w) as alt
from employees
window w as (partition by city)
order by city, id;
======================================== 4.1 Финансы
select year, month, revenue,
    lag(revenue, 1) over(order by year, month) as prev,
    round(revenue * 100 / lag(revenue, 1) over(order by year, month)) as perc
from sales
where year = 2020 and plan = 'gold';
----------------------------------------
select plan, year, month, revenue,
    sum(revenue) over (partition by plan order by plan, year, month) as total
from sales
where year = 2020 and month in (1, 2, 3)
order by plan, year, month;
----------------------------------------
select year, month, revenue,
    round(avg(revenue) over (order by year, month rows between 1 preceding and 1 following)) as avg3m
from sales
where year = 2020 and plan = 'platinum'
order by year, month;
----------------------------------------
select year, month, revenue,
    last_value(revenue) over (partition by year order by year, month rows between unbounded preceding and unbounded following) as december,
    round(revenue * 100 / last_value(revenue) over (partition by year order by year, month rows between unbounded preceding and unbounded following)) as perc
from sales
where plan = 'silver'
order by year, month;
----------------------------------------
select year, plan, sum(revenue) as revenue,
    sum(sum(revenue)) over (partition by year) as total,
    round(sum(revenue) * 100 / sum(sum(revenue)) over (partition by year)) as perc
from sales
group by year, plan
order by year, plan;
----------------------------------------
select year, month, sum(revenue) as revenue,
    ntile(3) over (order by sum(revenue) desc) as tile
from sales
where year = 2020
group by year, month
order by revenue desc;
----------------------------------------
select year, quarter, sum(revenue) as revenue,
    lag(sum(revenue), 4) over() as prev,
    round(sum(revenue) * 100 / lag(sum(revenue), 4) over()) as perc
from sales
group by year, quarter
limit 4, 4;


-- if no quarters
with t as (
    select year, month, sum(revenue) as revenue,
        ntile(4) over (order by month) as quarter
    from sales
    group by year, month
    order by year, quarter)

select year, quarter, sum(revenue) as revenue,
    lag(sum(revenue), 4) over() as prev,
    round(sum(revenue) * 100 / lag(sum(revenue), 4) over()) as perc
from t
group by year, quarter
limit 4, 4;
----------------------------------------
with t as (
    select year, month,
        max(case when plan = 'silver' then quantity end) as silver,
        max(case when plan = 'gold' then quantity end) as gold,
        max(case when plan = 'platinum' then quantity end) as platinum
    from sales
    where year = 2020
    group by year, month
    order by year, month)
    
select year, month,
    rank() over (order by max(silver) desc) as silver,
    rank() over (order by max(gold) desc) as gold,
    rank() over (order by max(platinum) desc) as platinum
from t
group by year, month
order by year, month;
======================================== 4.2 Кластеризация
with agroups as (
    select
        user_id,
        adate,
        to_days(adate) - dense_rank() over w as group_id  # MySQL
        # unixepoch(adate)/86400 - dense_rank() over w as group_id  # SQLite
    from activity
    window w as (order by user_id, adate)
    order by user_id, adate
)
select
    user_id,
    min(adate) as day_start,
    max(adate) as day_end,
    count(*) as day_count
from agroups
group by user_id, group_id
order by user_id, day_start;
----------------------------------------
Вот универсальный алгоритм поиска кластеров на SQL:

Посчитать расстояние L между соседними значениями через lag().
Идентифицировать границы по условию sum(case when L > N then 1 else 0 end), где N — максимально допустимое расстояние между соседними значениями кластера.
Агрегировать кластеры по идентификатору.
----------------------------------------
with t1 as (
    select
        user_id,
        adate, 
        points - lag(points) over w as points_lag,
        points
    from activity
    window w as (order by user_id, adate)
    order by user_id, adate
),

t2 as (
    select
        *,
        sum(case when points_lag >= 0 then 0 else 1 end) over w as group_id
    from t1
    window w as (order by user_id, adate)
)

select 
    user_id,
    min(adate) as day_start,
    max(adate) as day_end,
    count(*) as day_count,
    sum(points) as p_total
from t2
group by user_id, group_id
having day_count > 1;
======================================== 4.3 Очистка данных
select wdate, wtemp, precip
from (select wdate, wtemp, precip,
      row_number() over(partition by precip order by wdate desc) as rownum
      from weather
      where MONTH(wdate) = 4) t1
where rownum = 1
order by wdate;
----------------------------------------
select wdate, precip, case when precip is NULL then avg_3 else precip end as fixed
from
    (select
        wdate, precip,
        round(avg(precip) over(rows between 1 preceding and 1 following), 1) as avg_3
    from weather
    where wdate between '2020-03-06' and '2020-03-11' or wdate between '2020-06-01' and '2020-06-06') t1
order by wdate;
----------------------------------------
select
    extract(month from wdate) as wmonth,
    percentile_cont(0.90) within group (order by pressure) as p90
from weather
group by extract(month from wdate);

-- Теперь для каждого месяца считаем количество дней, в которые значение осадков превысило 90-й процентиль:

with boundary as (
    select
        to_char(wdate, 'YYYY-MM') as wmonth,
        percentile_cont(0.90) within group (order by pressure) as p90
    from weather
    group by to_char(wdate, 'YYYY-MM')
)
select
    to_char(wdate, 'YYYY-MM') as wmonth,
    count(*) filter (where pressure > boundary.p90) as over_count
from weather
    join boundary on to_char(wdate, 'YYYY-MM') = boundary.wmonth
group by to_char(wdate, 'YYYY-MM')
order by wmonth;
========================================