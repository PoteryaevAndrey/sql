use lesson_4;

-- 1. Создайте представление, в которое попадет информация о  пользователях (имя, фамилия, город и пол),
-- которые не старше 20 лет.
create or replace view short_info as
select u.firstname,
    u.lastname,
    p.hometown,
    p.gender
from users as u
    join profiles as p on u.id = p.user_id
where TIMESTAMPDIFF(year, p.birthday, now()) <= 20;
select *
from short_info;
drop view short_info;

-- 2. Найдите кол-во,  отправленных сообщений каждым пользователем и  выведите ранжированный список пользователей,
-- указав имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге
-- (первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK)
select *,
    dense_rank() over(
        order by sum_messages desc
    ) as rang
from (
        select distinctrow firstname,
            lastname,
            count(*) over(partition by from_user_id) as sum_messages
        from users as u
            join messages as m on u.id = from_user_id
    ) as d;
    
-- 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at)
-- и найдите разницу дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG)
select body as 'Сообщение',
    created_at as 'Дата отправления',
    TIMESTAMPDIFF(
        MINUTE,
        lag(created_at, 1, created_at) over(
            order by created_at
        ),
        created_at
    ) as 'Разница отправки (минуты)'
from messages;