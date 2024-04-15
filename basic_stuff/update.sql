UPDATE book
SET price = 0.7 * price;

UPDATE book
SET price = 0.7 * price
WHERE amount < 5;

UPDATE book
SET price = 0.9 * price
WHERE amount BETWEEN 5 AND 10;


UPDATE book
SET amount = amount - buy,
    buy = 0;


UPDATE book
SET buy = IF(amount < buy, buy-(buy-amount), buy),
    price = IF(buy=0, price*0.9, price);


UPDATE book, supply
SET book.amount = book.amount + supply.amount
WHERE book.title = supply.title AND book.author = supply.author;


UPDATE book, supply
SET book.amount = supply.amount + book.amount,
    book.price = (book.price+supply.price)/2
WHERE book.title = supply.title AND book.author = supply.author;