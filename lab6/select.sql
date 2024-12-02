-- Формирование списка размещений студентов в заданном диапазоне дат
CREATE OR REPLACE FUNCTION Period(start_date DATE, end_date DATE)
RETURNS TABLE(accommodation_id INT, accommodation_date DATE, distance INT, room_number INT, student_name INT, neighbour_name INT) AS $$
BEGIN
	RETURN QUERY
	SELECT a.*
	FROM public.accommodations a
	WHERE a.accommodation_date BETWEEN start_date AND end_date;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM Period('2005-08-01', '2005-08-10');

-- Формирование списка групп, средняя стипендия студентов в которых превышает заданное значние
CREATE OR REPLACE FUNCTION Sum_object(min_sum INTEGER)
RETURNS TABLE(group_name VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT g.group_name
    FROM public.groups g
    INNER JOIN public.students s ON g.group_id = s.group_name
    GROUP BY g.group_name
    HAVING SUM(s.scholarship) > min_sum;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM Sum_object(8000);

-- Формирование количества размещений студентов, которые произошли в заданный период
CREATE OR REPLACE FUNCTION row_count(date_from DATE, date_to DATE)
RETURNS INT AS $$
DECLARE
    count_rows INT;
BEGIN
    SELECT COUNT(*)
    INTO count_rows
    FROM public.accommodations
    WHERE accommodation_date BETWEEN date_from AND date_to;

    RETURN count_rows;
END;
$$ LANGUAGE plpgsql;

SELECT row_count('2005-08-01', '2005-08-10');

-- Формирование статистики (минимальное, максимальное и среднее значение) для различных объектов (студенты, комнаты, размещения)
CREATE OR REPLACE PROCEDURE object_stat(object_name VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    min_value INTEGER;
    max_value INTEGER;
    avg_value FLOAT;
BEGIN
    IF object_name = 'students' THEN
        SELECT MIN(scholarship), MAX(scholarship), AVG(scholarship)
        INTO min_value, max_value, avg_value
        FROM students;
    ELSIF object_name = 'rooms' THEN
        SELECT MIN(room_number), MAX(room_number), AVG(room_number)
        INTO min_value, max_value, avg_value
        FROM rooms;
    ELSIF object_name = 'accommodations' THEN
        SELECT MIN(distance), MAX(distance), AVG(distance)
        INTO min_value, max_value, avg_value
        FROM accommodations;
    ELSE
        RAISE EXCEPTION 'Unknown object name: %', object_name;
    END IF;

    RAISE NOTICE 'Минимальное значение: %, Максимальное значение: %, Среднее значение: %', min_value, max_value, avg_value;
END;
$$;

CALL object_stat('students');
CALL object_stat('rooms');
CALL object_stat('accommodations');
 
-- Формирование статистики (минимальное, максимальное и среднее значение) для различных объектов (группы, комнаты)
CREATE OR REPLACE PROCEDURE objects_stat(object_name VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    IF object_name = 'groups' THEN
        FOR rec IN
            SELECT g.group_name, MIN(s.scholarship) AS min_scholarship,
                   MAX(s.scholarship) AS max_scholarship,
                   AVG(s.scholarship) AS avg_scholarship
            FROM public.groups g
            INNER JOIN public.students s ON g.group_id = s.group_name
            GROUP BY g.group_name
        LOOP
            RAISE NOTICE 'Группа: %, Минимальная стипендия: %, Максимальная стипендия: %, Средняя стипендия: %',
                         rec.group_name, rec.min_scholarship, rec.max_scholarship, rec.avg_scholarship;
        END LOOP;
    ELSIF object_name = 'rooms' THEN
        FOR rec IN
            SELECT r.room_number, MIN(a.distance) AS min_distance,
                   MAX(a.distance) AS max_distance,
                   AVG(a.distance) AS avg_distance
            FROM public.rooms r
            INNER JOIN public.accommodations a ON r.room_id = a.room_number
            GROUP BY r.room_number
        LOOP
            RAISE NOTICE 'Комната: %, Минимальное расстояние: %, Максимальное расстояние: %, Среднее расстояние: %',
                         rec.room_number, rec.min_distance, rec.max_distance, rec.avg_distance;
        END LOOP;
    END IF;
END;
$$;

CALL objects_stat('groups');
CALL objects_stat('rooms');

-- Формирование количества объектов и их оценки в зависимости от этого количества
CREATE OR REPLACE PROCEDURE Itog(IN object_name TEXT)
LANGUAGE plpgsql
AS $$
DECLARE
    object_count INTEGER;
    evaluation TEXT;
BEGIN
    EXECUTE format('SELECT COUNT(*) FROM %I', object_name) INTO object_count;

    IF object_count < 2 THEN
        evaluation := 'Незначительный объект';
    ELSIF object_count >= 2 AND object_count <= 3 THEN
        evaluation := 'Обычный объект';
    ELSE
        evaluation := 'Значительный объект';
    END IF;

    RAISE NOTICE 'Объект: %, Количество: %, Оценка: %', object_name, object_count, evaluation;
END;
$$;

CALL Itog('groups');
CALL Itog('rooms');
CALL Itog('students');
CALL Itog('accommodations');

-- Формирование удалений размещений студентов, связанных с удаляемой комнатой
ALTER TABLE public.accommodations
	DROP CONSTRAINT room_room_number_fkey;
ALTER TABLE public.accommodations
	DROP CONSTRAINT student_student_name_fkey;
ALTER TABLE public.accommodations
	DROP CONSTRAINT neighbour_neighbour_name_fkey;

ALTER TABLE public.accommodations 
	ADD CONSTRAINT room_room_number_fkey FOREIGN KEY (room_number) 
			REFERENCES public.rooms(room_id) MATCH SIMPLE
				ON UPDATE NO ACTION
				ON DELETE CASCADE;
ALTER TABLE public.accommodations 
	ADD CONSTRAINT student_student_name_fkey FOREIGN KEY (student_name) 
			REFERENCES public.students(student_id) MATCH SIMPLE
				ON UPDATE NO ACTION
				ON DELETE CASCADE;
ALTER TABLE public.accommodations
	ADD CONSTRAINT neighbour_neighbour_name_fkey FOREIGN KEY (neighbour_name) 
			REFERENCES public.students(student_id) MATCH SIMPLE
				ON UPDATE NO ACTION
				ON DELETE CASCADE;

CREATE OR REPLACE FUNCTION delete_related_accommodations()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM accommodations
    WHERE room_number = OLD.room_id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER after_delete_room
AFTER DELETE ON rooms
FOR EACH ROW EXECUTE FUNCTION delete_related_accommodations();

SELECT * FROM accommodations;
DELETE FROM rooms WHERE room_id = 3;
SELECT * FROM accommodations;

-- Формирование уведомлений перед удалением размещения студента
CREATE OR REPLACE FUNCTION notify_before_delete_accommodation()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Удаляется размещение студента: %', OLD.accommodation_id;

    IF EXISTS (SELECT 1 FROM rooms WHERE room_id = OLD.room_number) THEN
        RAISE NOTICE 'Удаляется комната с номером: %', OLD.room_number;
    END IF;

    IF EXISTS (SELECT 1 FROM students WHERE student_id = OLD.student_name) THEN
        RAISE NOTICE 'Удаляется студент с ID: %', OLD.student_name;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER before_delete_accommodation
BEFORE DELETE ON accommodations
FOR EACH ROW EXECUTE FUNCTION notify_before_delete_accommodation();

SELECT * FROM accommodations;
DELETE FROM accommodations WHERE accommodation_id = 1;
SELECT * FROM accommodations;

-- Формирование суммы значений дистанции от общежития при добавлении новых размещений
CREATE OR REPLACE FUNCTION sum_distance()
RETURNS TRIGGER AS $$
BEGIN 
	NEW.distance := NEW.distance + (SELECT COALESCE(SUM(distance), 0)
	FROM accommodations);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER ins_sum
BEFORE INSERT ON accommodations
FOR EACH ROW
EXECUTE FUNCTION sum_distance();

SELECT * FROM accommodations;
INSERT INTO accommodations (accommodation_date, distance, room_number, student_name, neighbour_name) VALUES
        ('2005-08-20', 300, 1, 1, 2);
SELECT * FROM accommodations;

-- Формирование увеличения стипендии студентов на 10% перед обновлением
CREATE OR REPLACE FUNCTION before_update_value()
RETURNS TRIGGER AS $$
BEGIN
    NEW.scholarship := NEW.scholarship * (1.0 + (10.0 / 100.0));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER Before_Update_Value
BEFORE UPDATE ON students
FOR EACH ROW
EXECUTE FUNCTION before_update_value();

UPDATE students SET scholarship = 2000 WHERE student_id = 1;

SELECT * FROM students WHERE student_id = 1;
