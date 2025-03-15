-- Формирование списка студентов по алфавиту имен с отображением текстового параметра стипендии “Выше ..” или “Ниже средней”
SELECT students.student_name AS name, students.scholarship AS stipend, 'Выше среднего' AS parametr
FROM public.students
WHERE students.scholarship > (SELECT AVG(students.scholarship) FROM public.students)

UNION

SELECT students.student_name AS name, students.scholarship AS stipend, 'Ниже среднего' AS parametr
FROM public.students
WHERE students.scholarship <= (SELECT AVG(students.scholarship) FROM public.students)

ORDER BY name;

-- Формирование списка студентов по алфаиту имен в обратном порядке, у которых наивысшая или низшая стипендия
SELECT students.student_name AS name, students.scholarship AS stipend, 'Наивысший' AS parametr
FROM public.students
WHERE students.scholarship = (SELECT MAX(students.scholarship) FROM public.students)

UNION

SELECT students.student_name AS name, students.scholarship AS stipend, 'Низший' AS parametr
FROM public.students
WHERE students.scholarship = (SELECT MIN(students.scholarship) FROM public.students)

ORDER BY name DESC;

-- Формирование списка студентов, их комнат, а также соседей, если они есть
SELECT s.student_name AS student_name, rooms.room_number, students.student_name AS neighbour_name
FROM public.students s
INNER JOIN public.accommodations ON s.student_id = accommodations.student_name
INNER JOIN public.rooms ON accommodations.room_number = rooms.room_id
LEFT OUTER JOIN public.students ON accommodations.neighbour_name = students.student_id

UNION

SELECT students.student_name AS student_name, rooms.room_number, 'Нет соседа' AS neighbour_name
FROM public.students
INNER JOIN public.accommodations ON students.student_id = accommodations.student_name
INNER JOIN public.rooms ON accommodations.room_number = rooms.room_id
WHERE accommodations.neighbour_name IS NULL

ORDER BY student_name;

-- Формирование списка студентов, которые имеют стипендию выше 3000 и которые из группы КС-10
SELECT students.student_name
FROM public.students
WHERE students.scholarship > 3000

INTERSECT

SELECT students.student_name
FROM public.students
WHERE students.group_name = 1;

-- Формирование списка студентов, которые проживают в комнате номер 14, за исключением тех, кто из группы КС-14
SELECT students.student_id, students.student_name
FROM public.students
WHERE students.student_id IN (SELECT accommodations.student_name
                              FROM public.accommodations
							  WHERE accommodations.room_number = 1
)

EXCEPT

SELECT students.student_id, students.student_name
FROM public.students
WHERE students.group_name = 2;

-- Формирование списка студентов из группы КС-10
CREATE OR REPLACE VIEW students_view AS
SELECT students.student_id, students.student_name, students.group_name
FROM public.students
WHERE students.group_name = 1
WITH CHECK OPTION;

SELECT * FROM students_view;

-- Формирование списка студентов с их стипендиями и группы, в которых они обучаются 
CREATE OR REPLACE VIEW Itog_query AS
SELECT students.student_id AS "ID Студента", students.student_name AS "Имя Студента", students.scholarship AS "Стипендия", students.group_name AS "ID Группы"
FROM public.students;

SELECT * FROM Itog_query;

-- Установка стипендии номиналом в 3000 рублей студенту, ID которого номер 1
UPDATE Itog_query
SET "Стипендия" = 3000
WHERE "ID Студента" = 1;

SELECT * FROM Itog_query;

-- Формирование списка размещений по датам, дистанции студентов от общежития, комнатам
CREATE OR REPLACE VIEW accommodations_view AS
SELECT accommodations.accommodation_id, accommodations.accommodation_date, accommodations.distance, accommodations.room_number
FROM public.accommodations
WITH CHECK OPTION;

SELECT * FROM accommodations_view;

-- Формирование списка групп, в каждой из которых рассчитана средняя стипендия
CREATE OR REPLACE VIEW Avg_Obj AS
SELECT students.group_name AS "ID Группы", AVG(students.scholarship) AS "Средняя Стипендия"
FROM public.students
GROUP BY students.group_name;

SELECT * FROM Avg_Obj;
