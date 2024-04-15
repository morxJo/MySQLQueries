INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
FROM supply;
SELECT * FROM book;


INSERT INTO book(title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE author NOT LIKE 'Булгаков%' AND author NOT LIKE 'Достоевский%';


INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE title NOT IN (
        SELECT title
        FROM book
      );


INSERT INTO book(title, author, price, amount)
SELECT title, author, price, amount FROM supply
WHERE author NOT IN (SELECT author FROM book);