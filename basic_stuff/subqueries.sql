SELECT title, author, price, amount
FROM book
WHERE price = (
         SELECT MIN(price)
         FROM book
      );


SELECT author, title, price
FROM book
WHERE price <= ( SELECT AVG(price) FROM book)
ORDER BY title ASC;

SELECT title, author, amount
FROM book
WHERE ABS(amount - (SELECT AVG(amount) FROM book)) >3;


SELECT author, title, price from book
where abs(price - (select min(price) from book)) <= 150
order by price