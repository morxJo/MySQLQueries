select name,city,per_diem,date_first,date_last from trip
where name like '%а %'
order by date_last desc;


select name from trip
where city LIKE 'Москва'
group by name
order by name asc;


select city, count(city) as 'Количество' from trip
group by city
order by city;


select city, count(city) as 'Количество' from trip
group by city
order by count(city) desc
limit 2;


select name, city, DATEDIFF(date_last, date_first)+1 as 'Длительность'
from trip
where city not in ('Москва','Санкт-Петербург')
order by DATEDIFF(date_last, date_first)+1 desc, city desc;


select name, city, date_first, date_last from trip
where DATEDIFF(date_last,date_first)+1 = (SELECT min(DATEDIFF(date_last,date_first)+1) as 'разница' from trip);


select name,city,date_first, date_last from trip
where month(date_first) = month(date_last)
order by city, name;


select MONTHNAME(date_first) as 'Месяц', count(MONTHNAME(date_first)) as 'Количество'
from trip
group by MONTHNAME(date_first)
order by count(MONTHNAME(date_first)) desc, MONTHNAME(date_first);


select name, city, date_first, (DATEDIFF(date_last, date_first)+1)*per_diem AS 'Сумма'
from trip
where MONTH(date_first) = 3 or MONTH(date_first) = 2
order by name, (DATEDIFF(date_last, date_first)+1)*per_diem desc;


select name, sum((datediff(date_last, date_first)+1)*per_diem) as Сумма from trip
where name in (select name from trip
               group by name
               having count(name)>3)
group by name
order by Сумма desc;



