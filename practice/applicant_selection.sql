select distinct name_enrollee from enrollee
inner join program_enrollee using(enrollee_id)
inner join program using(program_id)
where name_program = 'Мехатроника и робототехника'
order by name_enrollee;


select name_program from program
inner join program_subject using(program_id)
inner join subject using(subject_id)
where name_subject = 'Информатика';


select name_subject, count(subject_id) as Количество, max(result) as Максимум, min(result) as Минимум, round(avg(result),1) as Среднее
from subject
inner join enrollee_subject using (subject_id)
group by name_subject
order by name_subject asc;


select name_program from program
inner join program_subject using(program_id)
group by name_program
having min(min_result) >= 40
order by name_program;


select name_program, plan from program
group by name_program, plan
having plan = (select max(plan) as max_plan from program);


select name_enrollee, sum(if(bonus is null, 0, bonus)) as Бонус from enrollee
left join enrollee_achievement using(enrollee_id)
left join achievement using(achievement_id)
group by name_enrollee
having Бонус >= 0
order by name_enrollee;


select name_department, name_program, plan, count(program_enrollee.enrollee_id) as Количество, round(count(program_enrollee.enrollee_id)/plan, 2) as Конкурс
from department
inner join program using(department_id)
inner join program_enrollee using(program_id)
group by name_department, name_program, plan
order by plan ;


select name_program from program
inner join program_subject using(program_id)
inner join subject using(subject_id)
where name_subject = 'Информатика' or name_subject = 'Математика'
group by name_program
having count(program_id) = 2
order by name_program ;


select name_program, name_enrollee, sum(result) as itog from enrollee
inner join program_enrollee using(enrollee_id)
inner join program using(program_id)
inner join program_subject using(program_id)
inner join subject using(subject_id)
inner join enrollee_subject on enrollee_subject.subject_id = subject.subject_id and enrollee_subject.enrollee_id = enrollee.enrollee_id
group by name_program, name_enrollee
order by name_program, sum(result) desc ;


select distinct name_program, name_enrollee from enrollee
inner join program_enrollee using(enrollee_id)
inner join program using(program_id)
inner join program_subject using(program_id)
inner join subject using(subject_id)
inner join enrollee_subject on enrollee_subject.subject_id = subject.subject_id and enrollee_subject.enrollee_id = enrollee.enrollee_id
where enrollee_subject.result < min_result
group by name_program, name_enrollee
order by name_program, name_enrollee;


SELECT LOWER(name_subject) AS предмет, MIN(result) AS минимум, MAX(result) AS максимум, ROUND(AVG(result)) AS среднее, COUNT(result) AS количество
FROM subject
INNER JOIN enrollee_subject USING(subject_id)
GROUP BY name_subject
ORDER BY AVG(result) DESC;


