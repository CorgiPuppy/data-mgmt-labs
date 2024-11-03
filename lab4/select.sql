-- Формирование списка средней стипендии студентов по группам
SELECT students.student_name, groups.group_name, students.scholarship, AVG(students.scholarship) OVER(PARTITION BY students.group_name) AS avg_scholarship
FROM public.students
INNER JOIN public.groups ON students.group_name = groups.group_id;

-- Формирование ранжирования списка студентов по их стипендии
SELECT students.student_name, students.scholarship, DENSE_RANK() OVER(ORDER BY students.scholarship ASC) AS scholarship_rank
FROM public.students;

-- Формирование списка пар студентов, которые проживают в одной комнате
SELECT a.student_name AS student_1, b.student_name AS student_2
FROM public.accommodations AS accommodation_1
INNER JOIN public.accommodations AS accommodation_2 ON accommodation_1.room_number = accommodation_2.room_number
INNER JOIN public.students AS a ON accommodation_1.student_name = a.student_id
INNER JOIN public.students AS b ON accommodation_2.student_name = b.student_id
WHERE a.student_id <> b.student_id;

-- Формирование списка пар студентов, которые проживают в одной комнате, без повторов
SELECT a.student_name AS student_1, b.student_name AS student_2
FROM public.accommodations AS accommodation_1
INNER JOIN public.accommodations AS accommodation_2 ON accommodation_1.room_number = accommodation_2.room_number
INNER JOIN public.students AS a ON accommodation_1.student_name = a.student_id
INNER JOIN public.students AS b ON accommodation_2.student_name = b.student_id
WHERE a.student_id < b.student_id;

-- Формирование списка студентов, у которых стипендия выше, чем у Иванова
SELECT student_name, scholarship
FROM public.students
WHERE scholarship > (SELECT scholarship 
					 FROM public.students
					 WHERE student_name = 'Ivanov');

-- Формирование списка номеров комнат, где живет хотя бы один студент, получающий стипендию больше 2500
SELECT DISTINCT rooms.room_number
FROM public.accommodations
INNER JOIN public.rooms ON accommodations.room_number = rooms.room_id
WHERE student_name IN (SELECT student_id 
					   FROM public.students
					   WHERE scholarship > 2500);

-- Формирование списка студентов, у которых стипендия выше средней стипендии среди всех студентов
SELECT student_name, scholarship
FROM public.students
WHERE scholarship > (SELECT AVG(scholarship)
					 FROM public.students);

-- Формирование списка студентов, которые живут с соседями, имеющими стипендию более 2500
SELECT student_name 
FROM public.students 
WHERE student_id IN (SELECT neighbour_name 
                     FROM public.accommodations 
                     WHERE neighbour_name IN (SELECT student_id 
					 						  FROM public.students
											  WHERE scholarship > 2500));

-- Формирование списка групп, в которых количество студентов такое же, какое количество студентов, получающих стипендию больше 2300
SELECT groups.group_name, COUNT(students.student_id) AS amount_of_students
FROM public.groups
INNER JOIN public.students ON groups.group_id = students.group_name
GROUP BY groups.group_name
HAVING COUNT(students.student_id) = (SELECT COUNT(*)
									 FROM public.students
									 WHERE scholarship > 2300);

-- Формирование списка студентов, которые находятся в группе, где есть хотя бы один студент со стипендией выше 4000
SELECT students.student_name, students.scholarship
FROM public.students
INNER JOIN (SELECT group_name
			FROM public.students
			WHERE scholarship > 4000) AS high_scholarship_groups
	ON students.group_name = high_scholarship_groups.group_name;

-- Формирование списка номеров комнат, в которых живут студенты, получающие стипендию выше 2400
SELECT DISTINCT rooms.room_number
FROM public.accommodations
INNER JOIN public.rooms ON rooms.room_id = accommodations.room_number
WHERE student_name IN (SELECT student_id
                       FROM public.students
					   WHERE scholarship > 2400);

-- Формирование списка пар студентов, которые получают одинаковую стипендию
SELECT a.student_name AS student1, b.student_name AS student2 
FROM public.students AS a 
INNER JOIN public.students AS b ON a.scholarship = b.scholarship 
WHERE a.student_id <> b.student_id;
