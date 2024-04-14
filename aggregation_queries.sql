with find_step_interval as (select student_name as stud, CONCAT(module_id, '.', lesson_position) as lesson, max(submission_time) as max_time from lesson
                            inner join step using(lesson_id)
                            inner join step_student using(step_id)
                            inner join student using(student_id)
                            WHERE result = 'correct'
                            group by stud, lesson
                            ),
                           requirements AS
                            (SELECT stud FROM find_step_interval
                             GROUP BY stud
                             HAVING COUNT(*) >= 3 )

select stud as Студент, lesson as Урок, FROM_UNIXTIME(max_time) as Макс_время_отправки, ifnull(ceil((max_time - LAG(max_time) over (partition by stud ORDER BY max_time)) / 86400), '-') AS Интервал
FROM find_step_interval JOIN requirements USING(stud)
ORDER BY 1, 3
