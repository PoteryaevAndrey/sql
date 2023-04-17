USE lesson_4;
/* 1. Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, 
с помощью которой можно переместить любого (одного) пользователя из таблицы users в таблицу users_old. 
(использование транзакции с выбором commit или rollback – обязательно).*/
DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
       id SERIAL PRIMARY KEY,
       firstname VARCHAR(50),
       lastname VARCHAR(50) COMMENT 'Фамилия',
       email VARCHAR(120) UNIQUE
);
DROP procedure IF EXISTS move_user;
DELIMITER //
CREATE procedure move_user(iduser INT, op varchar(5), out result varchar(100)) 
begin
		DECLARE `_rollback` BIT DEFAULT 0;
		DECLARE code varchar(100);
		DECLARE error_string varchar(100);
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
			BEGIN
				SET `_rollback` = 1;
				GET stacked DIAGNOSTICS CONDITION 1 code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
			END;
	start transaction;
	if op = 'arhiv' THEN 
       -- переместить в архив
		INSERT INTO users_old SELECT * FROM users WHERE id = iduser;
		delete FROM users WHERE id = iduser;
	else 
       -- вернуть из архива
		INSERT INTO users SELECT * FROM users_old WHERE id = iduser;
		delete FROM users_old WHERE id = iduser;
	end if;
	IF `_rollback` THEN
		SET result = concat('Ошибка: ', code, ' Текст ошибки: ', error_string);
		ROLLBACK;
	ELSE
		SET result = 'O K';
		COMMIT;
	END IF;
END// 
DELIMITER ;

-- Перемещаем записи
call move_user(2, 'arhiv', @res);
SELECT @res AS 'Результат операции';
call move_user(4, 'arhiv', @res);
SELECT @res AS 'Результат операции';
-- Проверяем получилось ли
SELECT * FROM users;
SELECT * FROM users_old;
-- Возращаем записи, а то кончатся быстро 
call move_user (2, 'rev', @res);
SELECT @res AS 'Результат операции';
call move_user(4, 'rev', @res);
SELECT @res AS 'Результат операции';
SELECT * FROM users;
SELECT * FROM users_old;
