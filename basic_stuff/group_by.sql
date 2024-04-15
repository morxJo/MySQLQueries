SELECT author, SUM(amount)
FROM book
GROUP BY author;


INSERT INTO book (title, author, price, amount) VALUES ('Черный человек','Есенин С.А.', Null, Null);

SELECT author, COUNT(author), COUNT(amount), COUNT(*)
FROM book
GROUP BY author;


SELECT author AS 'Автор',
count(title) AS 'Различных_книг',
sum(amount) AS 'Количество_экземпляров' FROM book
GROUP BY author;