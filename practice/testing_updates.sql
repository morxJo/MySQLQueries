insert into attempt(student_id, subject_id, date_attempt)
select student_id, subject_id, NOW() from attempt
inner join student using (student_id)
inner join subject using (subject_id)
where name_student = 'Баранов Павел' and name_subject = 'Основы баз данных';


insert into testing(attempt_id, question_id)
select attempt_id, question_id
from attempt
inner join question on attempt.subject_id = question.subject_id
where attempt_id = (select max(attempt_id) from attempt)
group by question_id, attempt_id
order by rand()
limit 3;


update attempt
set result = (select CEILING(sum(is_correct/3*100)) from answer
inner join testing using (answer_id)
where attempt_id = 8)
where attempt_id = 8;


delete from attempt
using
    attempt
    inner join testing using (attempt_id)
where date_attempt < '2020-05-01';


insert into attempt(student_id, subject_id, date_attempt)
SELECT student_id, subject_id, NOW()
from student
left join attempt using (student_id)
cross join subject using (subject_id);

select name_student, name_subject, date_attempt
from attempt
inner join student using(student_id)
inner join subject using(subject_id);

