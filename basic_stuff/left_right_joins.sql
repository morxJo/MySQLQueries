SELECT name_author, title
FROM author LEFT JOIN book
     ON author.author_id = book.author_id
ORDER BY name_author;


SELECT name_genre FROM genre
LEFT JOIN book ON book.genre_id = genre.genre_id
WHERE genre.genre_id NOT IN (select book.genre_id from book)
