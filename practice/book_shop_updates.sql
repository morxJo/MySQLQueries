INSERT INTO client
SELECT 5, 'Попов Илья', city_id, 'popov@test'
FROM city
WHERE name_city = 'Москва';


INSERT INTO buy(buy_description, client_id)
SELECT 'Связаться со мной по вопросу доставки',
(SELECT client_id FROM client WHERE name_client = 'Попов Илья');


insert into buy_book(buy_book_id,buy_id,book_id,amount)
select null,'5',book_id,2
from buy_book
inner join book using (book_id)
inner join author using (author_id)
where book_id = (select book.book_id from book where book.title = 'Лирика' and author.author_id =
                 (select author.author_id from author where author.name_author like 'Пастернак%'))
UNION ALL
select null,'5',book_id,1
from buy_book
inner join book using(book_id)
inner join author using(author_id)
where book_id = (select book.book_id from book where book.title = 'Белая гвардия' and author.author_id =
                 (select author.author_id from author where author.name_author like 'Булгако%'));


update book, buy_book
set book.amount = book.amount - buy_book.amount
where book.book_id = buy_book.book_id and book.book_id in (select buy_book.book_id from buy_book where buy_book.buy_id = 5);


create table buy_pay as
select book.title, author.name_author, book.price, buy_book.amount, sum(book.price*buy_book.amount) as Стоимость
from book
inner join author using (author_id)
inner join buy_book using (book_id)
where buy_book.buy_id = 5
group by book.title, author.name_author, book.price, buy_book.amount
order by book.title;


create table buy_pay as
select buy_id, sum(buy_book.amount) as Количество, sum(buy_book.amount*book.price) as Итого
from buy_book inner join book using (book_id)
where buy_book.buy_id = '5'
group by buy_id;


insert into buy_step(buy_id, step_id)
select buy.buy_id, step.step_id from buy
cross join step
where buy_id = 5;


update buy_step
set date_step_beg = '2020-04-12'
where buy_id = 5 and step_id = 1;


update buy_step
set date_step_end = '2020-04-13'
where buy_id = 5 and step_id = 1;

update buy_step
set date_step_beg = '2020-04-13'
where buy_id = 5 and step_id = 2;

update buy_step
set date_step_end = Now()
where buy_id = 4 and step_id = 1;

update buy_step
set date_step_beg = Now()
where buy_id = 4 and step_id = 2;

