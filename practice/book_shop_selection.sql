select buy.buy_id, book.title, book.price, buy_book.amount
from buy inner join buy_book using (buy_id)
inner join book on buy_book.book_id = book.book_id
inner join client on client.client_id = buy.client_id
where name_client = 'Баранов Павел'
order by buy_id, title;


select name_author, book.title, count(buy_book.buy_id) as Количество from author
inner join book on author.author_id = book.author_id
left join buy_book on buy_book.book_id = book.book_id
group by book.title, name_author
order by name_author, book.title;


select name_city, count(buy.buy_id) as Количество from city
inner join client using (city_id)
inner join buy using (client_id)
group by name_city
order by Количество desc, name_city asc;


select buy.buy_id, buy_step.date_step_end from buy
inner join buy_step using (buy_id)
where step_id = 1 and date_step_end IS NOT NULL
order by buy.buy_id;


select buy.buy_id, client.name_client, sum(book.price*buy_book.amount) as 'Стоимость' from buy
inner join client using (client_id)
inner join buy_book using (buy_id)
inner join book using (book_id)
group by buy.buy_id, client.name_client
order by buy.buy_id;


select buy_id, name_step from buy_step
inner join step using (step_id)
where date_step_end is null and date_step_beg is not null;


select buy_id, DATEDIFF(date_step_end, date_step_beg) as Количество_дней, IF(DATEDIFF(date_step_end, date_step_beg)>days_delivery, DATEDIFF(date_step_end, date_step_beg)-days_delivery,0) as Опоздание from city
inner join client using (city_id)
inner join buy using (client_id)
inner join buy_step using (buy_id)
inner join step using (step_id)
where name_step = 'Транспортировка' and DATEDIFF(date_step_end, date_step_beg) is not null
order by buy_id;


select distinct name_client from client
inner join buy using (client_id)
inner join buy_book using (buy_id)
inner join book using (book_id)
inner join author using (author_id)
where name_author LIKE 'Достоевск%'
order by name_client;


select name_genre, sum(buy_book.amount) as Количество from genre
inner join book using (genre_id)
inner join buy_book using (book_id)
group by name_genre
having sum(buy_book.amount) =
(select max(sum_amount) as max_sum_amount from (
     select sum(buy_book.amount) as sum_amount from buy_book
     inner join book using (book_id)
     group by genre_id) query_in);


select YEAR(date_payment) as Год, MONTHNAME(date_payment) as Месяц, sum(buy_archive.price*buy_archive.amount) AS Сумма from buy_archive
group by YEAR(date_payment), MONTHNAME(date_payment)
union ALL

select YEAR(buy_step.date_step_end) as Год, MONTHNAME(buy_step.date_step_end) as Месяц, sum(book.price*buy_book.amount) AS Сумма from book
INNER JOIN buy_book USING(book_id)
INNER JOIN buy USING(buy_id)
INNER JOIN buy_step USING(buy_id)
INNER JOIN step USING(step_id)
WHERE date_step_end IS NOT NULL and name_step = 'Оплата'
group by YEAR(buy_step.date_step_end), MONTHNAME(buy_step.date_step_end)


order by Месяц, Год;


select title, sum(Количество) as Количество, sum(Сумма) as Сумма
from (
    select title, sum(buy_archive.amount) as Количество, sum(buy_archive.price * buy_archive.amount) as Сумма
    from book
    inner join buy_archive using (book_id)
    group by title
    UNION ALL
    select title, sum(buy_book.amount) as Количество, sum(book.price * buy_book.amount) as Сумма
    from book
    inner join buy_book using (book_id)
    inner join buy using (buy_id)
    inner join buy_step using (buy_id)
    inner join step using (step_id)
    where name_step = 'Оплата' and date_step_end IS NOT NULL
    group by title

) as query_1
group by query_1.title
order by Сумма desc;


