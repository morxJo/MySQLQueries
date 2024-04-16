UPDATE book
     INNER JOIN author ON author.author_id = book.author_id
     INNER JOIN supply ON book.title = supply.title
                         and supply.author = author.name_author
SET book.amount = book.amount + supply.amount,
    supply.amount = 0
WHERE book.price = supply.price;


UPDATE book
     INNER JOIN author ON author.author_id = book.author_id
     INNER JOIN supply ON book.title = supply.title
                         AND supply.author = author.name_author
SET book.amount = book.amount + supply.amount,
    book.price = (book.amount*book.price + supply.amount*supply.price)/(supply.amount+book.amount),
    supply.amount = 0
WHERE book.price <> supply.price;

SELECT * FROM book;
SELECT * FROM supply;


UPDATE book
SET genre_id =
      (
       SELECT genre_id
       FROM genre
       WHERE name_genre = 'Роман'
      )
WHERE book_id = 9;


update book
set genre_id =
    ( select genre_id from genre where name_genre = 'Поэзия')
where book.title = 'Стихотворения и поэмы';


update book
set genre_id = 3
where book_id = 11;


DELETE FROM author
WHERE author_id IN (SELECT author_id from book
                  GROUP BY author_id
                  HAVING sum(amount) < 20);


DELETE FROM genre
WHERE genre_id IN (SELECT genre_id FROM book
                  GROUP BY genre_id
                  HAVING count(title) < 4);

DELETE FROM author
USING
author INNER JOIN book ON book.author_id = author.author_id
INNER JOIN genre ON genre.genre_id = book.genre_id
WHERE name_genre = 'Поэзия';
