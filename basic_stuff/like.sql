SELECT title
FROM book
WHERE title LIKE 'Б%';

SELECT title FROM book
WHERE title LIKE "_____";


SELECT title FROM book
WHERE   title LIKE "_% и _%" /*отбирает слово И внутри названия */
    OR title LIKE "и _%" /*отбирает слово И в начале названия */
    OR title LIKE "_% и" /*отбирает слово И в конце названия */
    OR title LIKE "и"; /* отбирает название, состоящее из одного слова И */


SELECT title FROM book
WHERE title NOT LIKE "% %";


SELECT title, author FROM book
WHERE author LIKE '%С.%' AND (title LIKE '% %' and title not like " ")
ORDER BY title;

