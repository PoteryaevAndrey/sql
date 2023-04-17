/* 2. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/
DELIMITER //
drop function if exists hello;
create function hello()
	returns varchar(15)
	BEGIN
		DECLARE current_hour INT;
		DECLARE welcome varchar (15);
		SET current_hour = hour(now());
		SET welcome = case
              WHEN current_hour BETWEEN 6 AND 11 THEN "Доброе утро"
              WHEN current_hour BETWEEN 12 AND 17 THEN "Добрый день"
              WHEN current_hour BETWEEN 18 AND 23 THEN "Добрый вечер"
              WHEN current_hour BETWEEN 0 AND 5 THEN "Доброй ночи"
       end;
		RETURN welcome;
	END //
DELIMITER ;
-- вызов функции
SELECT hello() AS 'Приветсвие';
