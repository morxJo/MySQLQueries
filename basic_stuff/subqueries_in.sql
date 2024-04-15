SELECT title, author, amount, price
FROM book
WHERE author IN (
        SELECT author
        FROM book
        GROUP BY author
        HAVING SUM(amount) >= 12
      );


SELECT author, title, amount FROM book
WHERE amount IN (SELECT amount FROM book
GROUP BY amount
HAVING COUNT(amount)=1);

SELECT title, author, amount, price
FROM book
WHERE amount < ALL (
        SELECT AVG(amount)
        FROM book
        GROUP BY author
      );


SELECT title, author, amount, price
FROM book
WHERE amount < ANY (
        SELECT AVG(amount)
        FROM book
        GROUP BY author
      );


SELECT author, title, price
FROM book
WHERE price < ANY (SELECT min(price) FROM book
                   GROUP BY author);
