SELECT author, MIN(price) AS min_price
FROM book
GROUP BY author;


SELECT author, min(price) AS 'Минимальная_цена', max(price) AS 'Максимальная_цена',
AVG(price) AS 'Средняя_цена' FROM book
GROUP BY author;


SELECT author, SUM(price * amount) AS Стоимость
FROM book
GROUP BY author;


SELECT author, ROUND(SUM(price*amount),2) AS 'Стоимость', ROUND((SUM(price*amount)*0.18)/(1+0.18),2) AS 'НДС',
ROUND(SUM(price*amount)/ 1.18, 2) AS 'Стоимость_без_НДС' FROM book
GROUP BY author;

