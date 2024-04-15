SELECT name_genre, title, name_author FROM genre
INNER JOIN book ON genre.genre_id = book.genre_id
INNER JOIN author ON author.author_id = book.author_id
WHERE name_genre LIKE 'Роман'
ORDER BY title;


SELECT name_author, count(title) AS Количество
FROM
    author INNER JOIN book
    on author.author_id = book.author_id
GROUP BY name_author
ORDER BY name_author;


SELECT name_author, count(title) AS Количество
FROM
    author LEFT JOIN book
    on author.author_id = book.author_id
GROUP BY name_author
ORDER BY name_author;


SELECT name_author, sum(amount) AS Количество
FROM author
LEFT JOIN book ON author.author_id = book.author_id
GROUP BY name_author
HAVING sum(amount) < 10 or Количество IS NULL
ORDER BY Количество;


SELECT name_author, SUM(amount) as Количество
FROM
    author INNER JOIN book
    on author.author_id = book.author_id
GROUP BY name_author;


SELECT name_author, SUM(amount) as Количество
FROM
    author INNER JOIN book
    on author.author_id = book.author_id
GROUP BY name_author
HAVING SUM(amount) =
     (/* вычисляем максимальное из общего количества книг каждого автора */
      SELECT MAX(sum_amount) AS max_sum_amount
      FROM
          (/* считаем количество книг каждого автора */
            SELECT author_id, SUM(amount) AS sum_amount
            FROM book GROUP BY author_id
          ) query_in
      );


SELECT name_author FROM author
INNER JOIN book ON author.author_id = book.author_id
GROUP BY name_author
HAVING count(distinct genre_id) = 1;


SELECT  name_author, name_genre
FROM
    author
    INNER JOIN book ON author.author_id = book.author_id
    INNER JOIN genre ON  book.genre_id = genre.genre_id
GROUP BY name_author,name_genre, genre.genre_id
HAVING genre.genre_id IN
         (/* выбираем автора, если он пишет книги в самых популярных жанрах*/
          SELECT query_in_1.genre_id
          FROM
              ( /* выбираем код жанра и количество произведений, относящихся к нему */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
               )query_in_1
          INNER JOIN
              ( /* выбираем запись, в которой указан код жанр с максимальным количеством книг */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
                ORDER BY sum_amount DESC
                LIMIT 1
               ) query_in_2
          ON query_in_1.sum_amount= query_in_2.sum_amount
         );



SELECT title, name_author, name_genre, price, amount FROM book
INNER JOIN genre ON genre.genre_id = book.genre_id
INNER JOIN author ON author.author_id = book.author_id
GROUP BY genre.genre_id, title, name_author, name_genre, price, amount
HAVING genre.genre_id IN
    (SELECT query_1.genre_id from
         ( SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
               )query_1
         INNER JOIN
         ( select genre_id, sum(amount) as sum_amount from book
           group by genre_id
          ORDER BY sum_amount DESC
          LIMIT 1)query_2
     ON query_1.sum_amount = query_2.sum_amount)
ORDER BY title ASC;



