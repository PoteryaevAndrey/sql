use lesson_4;
/*(по желанию)* Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users
 ,communities и messages в таблицу logs помещается время и дата создания записи
 ,название таблицы
 ,идентификатор первичного ключа.*/
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
       log_id SERIAL PRIMARY KEY,
       create_data datetime,
       name_table varchar(20),
       i_primari_key int
);

-- Нельзя создать триггер на несколько таблиц 
DELIMITER //
drop trigger if exists logger_u//
drop trigger if exists logger_c//
drop trigger if exists logger_m//
CREATE trigger logger_u
after insert ON users for each row 
	begin
		INSERT INTO logs(create_data, name_table, i_primari_key)
			values(now(), 'users', new.id);
	end//
CREATE trigger logger_c
after insert ON communities for each row 
	begin
		INSERT INTO logs(create_data, name_table, i_primari_key)
			values(now(), 'communities', new.id);
	end//
CREATE trigger logger_m
after insert ON messages for each row 
	begin
		INSERT INTO logs(create_data, name_table, i_primari_key)
			values(now(), 'messages', new.id);
	end//
DELIMITER ;
INSERT INTO users (firstname, lastname, email) 
VALUES 
	('Fred', 'Scott', 'fred50@example.org'),
	('Inna', 'Hu', 'terrence.wright@example.org');
INSERT INTO communities (name) 
VALUES 
	('rubi'), ('tttt');
INSERT INTO messages  (from_user_id, to_user_id, body, created_at) 
VALUES
	(4, 6, 'Voluptatem ut quaerat quia. Pariatur esse amet ratione qui quia. In necessitatibus reprehenderit et. Nam accusantium aut qui quae nesciunt non.',  DATE_ADD(NOW(), INTERVAL 1 MINUTE)),
	(2, 4, 'Sint dolores et debitis est ducimus. Aut et quia beatae minus. Ipsa rerum totam modi sunt sed. Voluptas atque eum et odio ea molestias ipsam architecto.',  DATE_ADD(NOW(), INTERVAL 3 MINUTE));
-- Проверка
select * from logs;
select * from users;
select * from communities;
select * from messages;
-- Очистка
delete from users where id > 10;
delete from communities where id > 10;
delete from messages where id > 20;
truncate logs;