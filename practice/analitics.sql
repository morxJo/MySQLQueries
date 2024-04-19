select concat(substring(concat(module_id, ' ', module_name),1,16), '...') as Модуль, concat(substring(concat(module_id, '.', lesson_position, ' ', lesson_name),1,16), '...') as Урок, concat(module_id, '.', lesson_position, '.', step_position, ' ', step_name) as Шаг
from module
inner join lesson using(module_id)
inner join step using(lesson_id)
where step_name LIKE '%ложенн%'
order by Модуль, Урок, Шаг;


insert into step_keyword(step_id,keyword_id)
select step_id, keyword_id from step
CROSS join keyword
where instr(concat(' ',step_name,' '),concat(' ',keyword_name,' ')) > 0 OR instr(concat(' ',step_name,' '),concat(' ',keyword_name,','))>0 OR instr(concat(' ',step_name,' '),concat(' ',keyword_name,'(')) > 0
ORDER BY keyword_id;

select * from step_keyword;


select concat(module_id, '.', lesson_position, '.', if(step_position < 10, concat(0,step_position), step_position), ' ', step_name) as Шаг from lesson
inner join step using(lesson_id)
inner join step_keyword using(step_id)
inner join keyword using(keyword_id)
where keyword_name = 'MAX' or keyword_name = 'AVG'
group by 1
having count(keyword_name) = 2
order by 1;


select Группа,
case
    when Группа = "I" THEN 'от 0 до 10'
    WHEN Группа="II" THEN 'от 11 до 15'
    WHEN  Группа="III" THEN 'от 16 до 27'
    WHEN  Группа="IV" THEN 'больше 27'
end as Интервал, count(Группа) as Количество
from (SELECT student_name, rate,
    CASE
        WHEN rate <= 10 THEN "I"
        WHEN rate <= 15 THEN "II"
        WHEN rate <= 27 THEN "III"
        ELSE "IV"
    END AS Группа
FROM
    (
     SELECT student_name, count(*) as rate
     FROM
         (
          SELECT student_name, step_id
          FROM
              student
              INNER JOIN step_student USING(student_id)
          WHERE result = "correct"
          GROUP BY student_name, step_id
         ) query_in
     GROUP BY student_name
     ORDER BY 2
    ) query_in_1) query_in_2
GROUP BY Группа;



with get_count_correct(st_n_c, count_correct)
as (select step_name, count(*)
    from step
    inner join step_student using(step_id)
    where result = "correct"
    group by step_name
   ),
   get_count_wrong(st_n_w, count_wrong)
as (select step_name, count(*)
    from step
    inner join step_student using(step_id)
    where result = "wrong"
    group by step_name
)
SELECT st_n_c AS Шаг,
    ifnull(ROUND(count_correct / (count_correct + count_wrong) * 100),100) AS Успешность
FROM
    get_count_correct
    LEFT JOIN get_count_wrong ON st_n_c = st_n_w
UNION
SELECT st_n_w AS Шаг,
    ifnull(ROUND(count_correct / (count_correct + count_wrong) * 100),0) AS Успешность
FROM
    get_count_correct
    RIGHT JOIN get_count_wrong ON st_n_c = st_n_w
ORDER BY 2,1;


with student_progress(student_name, progress)
as(
    select student_name, ROUND(COUNT(DISTINCT CASE WHEN result = 'correct' THEN step_id END) /(SELECT COUNT(DISTINCT step_id) FROM step_student)*100) as progress
    from student
    left join step_student using (student_id)
    group by student_name
)
select student_name as Студент, progress as Прогресс,
case
when progress = 100 then "Сертификат с отличием"
when progress >= 80 and progress < 100 then "Сертификат"
else ""
end as Результат
from student_progress
order by 2 desc, 1;


select student_name as Студент, concat(substring(step_name,1,20),'...') as Шаг, result as Результат, FROM_UNIXTIME(submission_time) as Дата_отправки,
  SEC_TO_TIME(IFNULL(submission_time - LAG(submission_time) OVER (ORDER BY submission_time), 0)) AS Разница
from step_student
inner join step using (step_id)
inner join student using (student_id)
where student_name = 'student_61'
order by Дата_отправки;


WITH student_step_time AS (
    SELECT
        student_id,
        step_id,
        SUM(submission_time - attempt_time) AS step_time
    FROM
        step_student
        WHERE (submission_time - attempt_time) < 4 * 3600
    GROUP BY student_id, step_id
),
lesson_time_per_student AS (
    SELECT
        stt.student_id,
        s.lesson_id,
        l.module_id,
        SUM(stt.step_time) AS lesson_time
    FROM
        student_step_time stt
        INNER JOIN step s ON stt.step_id = s.step_id
        INNER JOIN lesson l ON s.lesson_id = l.lesson_id
    GROUP BY
        stt.student_id, s.lesson_id, l.module_id
),
average_lesson_time AS (
    SELECT
        module_id,
        lesson_id,
        AVG(lesson_time / 3600) AS avg_lesson_time_hours
    FROM
        lesson_time_per_student
    GROUP BY
        module_id, lesson_id
)
SELECT
    ROW_NUMBER() OVER (ORDER BY avg_lesson_time_hours) AS Номер,
    CONCAT(al.module_id, '.', l.lesson_position, ' ', l.lesson_name) AS Урок,
    ROUND(al.avg_lesson_time_hours, 2) AS Среднее_время
FROM
    average_lesson_time al
INNER JOIN
    lesson l ON al.module_id = l.module_id AND al.lesson_id = l.lesson_id
ORDER BY
    avg_lesson_time_hours;



WITH get_rate_lesson(mod_id, stud, rate)
AS
(
   SELECT module_id, student_name, count(DISTINCT step_id)
   FROM student INNER JOIN step_student USING(student_id)
                INNER JOIN step USING (step_id)
                INNER JOIN lesson USING (lesson_id)
   WHERE result = "correct"
   GROUP BY module_id, student_name
)
select mod_id as Модуль, stud as Студент, rate as Пройдено_шагов,
    round(rate/ (MAX(rate) OVER (PARTITION BY mod_id)) * 100, 1) as Относительный_рейтинг
from get_rate_lesson
order by mod_id, Относительный_рейтинг desc, stud;


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
ORDER BY 1, 3;



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
order by step_id;