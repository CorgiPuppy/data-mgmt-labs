-- Формирование списка студентов из группы КС-10
SELECT students.student_name, groups.group_name
FROM public.students
INNER JOIN public.groups ON students.group_name = groups.group_id
WHERE groups.group_id = 1;

-- Формирование списка студентов из группы КС-14, номером комнаты и стипендией меньше 4000 
SELECT students.student_name, groups.group_name, accommodations.room_number
FROM public.students
INNER JOIN public.groups ON students.group_name = groups.group_id
INNER JOIN public.accommodations ON students.student_id = accommodations.student_name
WHERE groups.group_id = 2 AND students.scholarship < 4000;

-- Формирование списка студентов из группы КС-10, номером комнаты, стипендией больше 2000 и расстоянием от общежития выше 500
SELECT students.student_name, groups.group_name, accommodations.room_number
FROM public.students
INNER JOIN public.groups ON students.group_name = groups.group_id
INNER JOIN public.accommodations ON students.student_id = accommodations.student_name
WHERE students.scholarship > 2000 AND groups.group_id = 1 AND accommodations.distance > 500;

-- Формирование списка студентов по дате заселения с их стипендией, расстоянием от общежития и названием группы
SELECT accommodations.accommodation_date, students.student_name, students.scholarship, groups.group_name, accommodations.distance 
FROM public.students
INNER JOIN public.groups ON students.group_name = groups.group_id
INNER JOIN public.accommodations ON students.student_id = accommodations.student_name;

-- Формирование списка студентов по дате заселения в общежития в период от 2005-08-04 до 2005-08-15
SELECT students.student_name, accommodations.accommodation_date
FROM public.students
INNER JOIN public.accommodations ON students.student_id = accommodations.student_name
WHERE accommodations.accommodation_date BETWEEN '2005-08-04' AND '2005-08-15';

-- Формирование списка размещений и списка студентов, включая студентов, которые не заселились
SELECT accommodations.accommodation_date, students.student_name, accommodations.neighbour_name, accommodations.distance, accommodations.room_number
FROM public.accommodations
LEFT OUTER JOIN public.students ON students.student_id = accommodations.student_name;

-- Формирование списка студентов и списка размещений с отображением незаселившихся студентов
SELECT accommodations.accommodation_date, students.student_name, accommodations.neighbour_name, accommodations.distance, accommodations.room_number
FROM public.students
RIGHT OUTER JOIN public.accommodations ON students.student_id = accommodations.student_name;

-- Формирование списка размещений со студентами, не заселившимися в общежитие
SELECT accommodations.accommodation_date, students.student_name, accommodations.neighbour_name, accommodations.distance, rooms.room_number
FROM public.accommodations
FULL OUTER JOIN public.students ON students.student_id = accommodations.student_name
FULL OUTER JOIN public.rooms ON rooms.room_id = accommodations.room_number;
