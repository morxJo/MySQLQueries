select name_student, date_attempt, result
from student inner join attempt using (student_id)
inner join subject using (subject_id)
where name_subject like 'Основы баз%'
order by result desc;


select name_subject, count(attempt.subject_id) as Количество, ROUND(AVG(attempt.result),2) as Среднее
from attempt
right join subject using (subject_id)
group by name_subject
order by Среднее desc;


select name_student, attempt.result from student
inner join attempt using (student_id)
where attempt.result in (select max(attempt.result) from attempt)
order by  name_student;


select name_student, name_subject, datediff(max(date_attempt), min(date_attempt)) as Интервал
from student inner join attempt using (student_id)
inner join subject using (subject_id)
group by name_student, name_subject
having count(attempt.subject_id) >= 2
order by Интервал;


select name_subject, count(distinct student_id) as Количество from subject
left join attempt using (subject_id)
group by name_subject
order by Количество desc, name_subject;


select question_id, name_question from question
inner join subject using (subject_id)
where name_subject LIKE 'Основы баз%'
ORDER BY RAND()
limit 3;


select name_question, name_answer, IF(is_correct,'Верно', 'Неверно') as Результат
from question
inner join answer on question.question_id = answer.question_id
left join testing on question.question_id = testing.question_id
where testing.attempt_id = 7 and testing.answer_id = answer.answer_id;


select name_student, name_subject, date_attempt, ROUND(SUM(is_correct/3*100),2) as Результат
from student
inner join attempt on student.student_id = attempt.student_id
inner join subject on attempt.subject_id = subject.subject_id
inner join testing on attempt.attempt_id = testing.attempt_id
inner join answer on testing.answer_id = answer.answer_id
group by name_student, name_subject, date_attempt
order by name_student, date_attempt desc;


select name_subject, concat((SUBSTRING(name_question, 1, 30)) , '...') as Вопрос, count(is_correct) as Всего_ответов, ROUND(SUM(is_correct)/count(is_correct) * 100,2) as Успешность
from subject
inner join question on subject.subject_id = question.subject_id
inner join answer on answer.question_id = question.question_id
inner join testing on answer.answer_id = testing.answer_id
group by name_subject, Вопрос
order by name_subject, Успешность desc, Вопрос;


select name_subject, concat((substring(name_question,1,30)), '...') as Question, concat(substring(name_answer, 1,40), ' ') as answer
from subject
inner join question on subject.subject_id = question.subject_id
inner join answer on answer.question_id = question.question_id
where is_correct = 1;