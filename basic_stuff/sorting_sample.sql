SELECT title, author, price
FROM book
ORDER BY title;

SELECT title, author, price
FROM book
ORDER BY 1;


SELECT author, title, amount AS Количество
FROM book
WHERE price < 750
ORDER BY author, amount DESC;


SELECT author, title, amount AS Количество
FROM book
WHERE price < 750
ORDER BY author, Количество DESC;


SELECT author, title, amount AS Количество
FROM book
WHERE price < 750
ORDER BY 1, 3 DESC;


SELECT author, title FROM book
WHERE amount BETWEEN 2 AND 14
ORDER BY 1 DESC , title