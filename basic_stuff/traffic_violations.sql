create table fine(
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    name varchar(30),
    number_plate varchar(6),
    violation varchar(50),
    sum_fine decimal(8,2),
    date_violation date,
    date_payment date
    );


insert into fine
values (6, 'Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', NULL, '2020-02-14', NULL),
(7, 'Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', NULL, '2020-02-23',NULL),
(8,'Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', NULL, '2020-03-03',NULL);
SELECT * FROM fine;


update fine as f, traffic_violation as tv
set f.sum_fine = tv.sum_fine
where f.violation = tv.violation and f.sum_fine is NULL;

select * from fine;


select name, number_plate, violation from fine
group by name, number_plate, violation
having count(violation)>1
order by name, number_plate, violation asc;


update fine, (select name, number_plate, violation from fine
group by name, number_plate, violation
having count(violation)>1
order by name, number_plate, violation asc) as new
set fine.sum_fine = fine.sum_fine*2
where fine.name = new.name and fine.number_plate = new.number_plate and fine.violation= new.violation and fine.date_payment is null;


update fine, payment
set fine.date_payment = payment.date_payment,
    fine.sum_fine = IF(DATEDIFF(payment.date_payment, payment.date_violation)<=20, fine.sum_fine/2, fine.sum_fine)
where fine.name = payment.name and fine.number_plate = payment.number_plate and fine.violation = payment.violation and fine.date_payment IS NULL;


create table back_payment as
(select name, number_plate, violation, sum_fine, date_violation from fine
 where date_payment IS NULL);


delete from fine
where date_violation <  '2020-02-01';


