-- Формирование общего количества студентов 
SELECT COUNT(*) AS amount_of_students
FROM public.students;

-- Формирование количества студентов, размещенных в определенный день месяца
SELECT EXTRACT(DAY FROM accommodation_date) AS day, COUNT(*) AS amount_of_students
FROM public.accommodations
GROUP BY day;

-- Формирование количества студентов из каждой группы
SELECT groups.group_name, COUNT(students.student_id) AS amount_of_students
FROM public.groups
INNER JOIN public.students ON groups.group_id = students.group_name
GROUP BY groups.group_name;

-- Формирование количества студентов из каждой группы и из каждого номера комнаты 
SELECT groups.group_name, rooms.room_number, COUNT(students.student_id) AS amount_of_students
FROM public.groups
INNER JOIN public.students ON groups.group_id = students.group_name
INNER JOIN public.accommodations ON students.student_id = accommodations.student_name
INNER JOIN public.rooms ON rooms.room_id = accommodations.room_number 
GROUP BY groups.group_name, rooms.room_number;

-- Формирование по определенным датам количества студентов, заселенных раньше 2005-08-14 
SELECT accommodation_date, COUNT(*) AS amount_of_students
FROM public.accommodations
GROUP BY accommodation_date
	HAVING accommodation_date < '2005-08-14';

-- Формирование списка групп, в которых количество студентов больше 2
SELECT groups.group_name, COUNT(students.student_id) AS amount_of_students
FROM public.groups
INNER JOIN public.students ON groups.group_id = students.group_name
GROUP BY groups.group_name
	HAVING COUNT(students.student_id) > 2;

-- Формирование списка групп, в которых суммарная стипендия всех студентов больше 8600
SELECT groups.group_name, SUM(students.scholarship) AS sum_scholarship
FROM public.groups
INNER JOIN public.students ON groups.group_id = students.group_name
GROUP BY groups.group_name
	HAVING SUM(students.scholarship) > 8600;

-- Формирование количества размещений и студентов из каждой группы
SELECT groups.group_name, COUNT(accommodations.accommodation_id) AS amount_of_accommodations, COUNT(students.student_id) AS amount_of_students
FROM public.groups
INNER JOIN public.students ON groups.group_id = students.group_name
INNER JOIN public.accommodations ON students.student_id = accommodations.student_name
GROUP BY groups.group_name;

-- Формирование списка групп в порядке возрастания средней дальности от общежития, выраженной в милях, студентов из опреденной группы
SELECT groups.group_name, (AVG(accommodations.distance) / 1.61) AS average_distance_mile
FROM public.groups
INNER JOIN public.students ON groups.group_id = students.group_name
INNER JOIN public.accommodations ON students.student_id = accommodations.student_name
GROUP BY groups.group_name
ORDER BY average_distance_mile ASC;

-- Формирование списка групп в порядке убывания средней стипендии студентов из определенной группы, учитывая, что размер стипендии выводится, исходя из налоговой ставки (13%) 
SELECT groups.group_name, AVG(students.scholarship * (1 - 0.13)) AS average_scholarship
FROM public.groups
INNER JOIN public.students ON groups.group_id = students.group_name
GROUP BY groups.group_name
ORDER BY average_scholarship DESC;
