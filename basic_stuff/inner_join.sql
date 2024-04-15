SELECT title, name_author
FROM
    author INNER JOIN book
    ON author.author_id = book.author_id;

SELECT title, name_genre, price
FROM book INNER JOIN genre ON book.genre_id = genre.genre_id
WHERE amount > 8
ORDER BY price DESC;


