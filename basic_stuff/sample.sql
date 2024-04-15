SELECT title, amount
FROM book
WHERE amount BETWEEN 5 AND 14;


SELECT title, amount
FROM book
WHERE amount >= 5 AND amount <=14;


SELECT title, price
FROM book
WHERE author IN ('Булгаков М.А.', 'Достоевский Ф.М.');


SELECT title, price
FROM book
WHERE author = 'Булгаков М.А.' OR author = 'Достоевский Ф.М.';


SELECT title, author FROM book
WHERE (price BETWEEN 540.50 AND 800) AND (amount IN (2,3,5,7))
