with avg_time as (select student_name, avg(submission_time-attempt_time) as a_time from student
                  inner join step_student using(student_id)
                  where (submission_time-attempt_time) <= 1*3600
                  group by student_name),
student_time as (select student_name,
                 step_id,
                 concat(module_id, '.', lesson_position, '.', step_position) as step_info,
                 result,
                 ROW_NUMBER() OVER (PARTITION BY step_id order by submission_time) as attempt_numb,
                 case when a_time > 1 * 3600 then round(attempt_time,0)
                 else (submission_time - attempt_time) end as needed_attempt_time
                 from student
                 inner join step_student using(student_id)
                 inner join step using(step_id)
                 inner join lesson using(lesson_id)
                 inner join avg_time using(student_name)
                 where student_name = "student_59"
                 order by step_id, attempt_numb )
select student_name as Студент, step_info as Шаг, attempt_numb as Номер_попытки, result as Результат, SEC_TO_TIME(needed_attempt_time) as Время_попытки, round(needed_attempt_time / sum(needed_attempt_time) over (PARTITION BY step_id) * 100, 2) as Относительное_время
from student_time
order by step_id