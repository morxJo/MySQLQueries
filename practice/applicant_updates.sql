CREATE TABLE applicant
select program.program_id, enrollee.enrollee_id, sum(result) as itog from enrollee
    inner join program_enrollee using(enrollee_id)
    inner join program using(program_id)
    inner join program_subject using(program_id)
    inner join subject using(subject_id)
    inner join enrollee_subject on enrollee_subject.subject_id = subject.subject_id and enrollee_subject.enrollee_id = enrollee.enrollee_id
group by program.program_id, enrollee.enrollee_id
order by program.program_id, sum(result) desc ;


delete from applicant
using applicant
    inner join program on applicant.program_id = program.program_id
    inner join enrollee on applicant.enrollee_id = enrollee.enrollee_id
    inner join program_enrollee on program_enrollee.enrollee_id = enrollee.enrollee_id
    inner join program_subject on program.program_id = program_subject.program_id
    inner join subject on program_subject.subject_id = subject.subject_id
    inner join enrollee_subject on enrollee_subject.subject_id = subject.subject_id and enrollee_subject.enrollee_id = enrollee.enrollee_id
WHERE result < min_result AND applicant.program_id = program_enrollee.program_id;


update applicant
inner join
(select enrollee_id, sum(if(bonus is null, 0, bonus)) as extra_points
 from enrollee_achievement
 left join achievement on achievement.achievement_id = enrollee_achievement.achievement_id
 group by enrollee_id
) as bonus using(enrollee_id)
set itog = itog + extra_points;


create table applicant_order
select * from applicant
order by program_id, itog desc;


SET @num_pr := 0;
SET @row_num := 1;

update applicant_order
set str_id = if(@num_pr=program_id, @row_num := @row_num + 1, @row_num := 1 AND @num_pr := program_id);


create table student
select name_program, name_enrollee, itog
from enrollee
join applicant_order using (enrollee_id)
join program using (program_id)
where applicant_order.str_id <= program.plan
order by name_program, itog desc;

