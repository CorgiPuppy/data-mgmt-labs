SELECT students.student_name, groups.group_name
FROM students
INNER JOIN groups ON students.group_name = groups.group_id
WHERE groups.group_id = 1;

SELECT students.student_name, rooms.room_number, accommodations.distance
FROM students
INNER JOIN accommodations ON students.student_id = accommodations.student_name
INNER JOIN rooms ON accommodations.room_number = rooms.room_id
WHERE rooms.room_number > 1 AND students.group_name = 2;

SELECT students.student_name, rooms.room_number, accommodations.accommodation_date
FROM students
INNER JOIN accommodations ON students.student_id = accommodations.student_name
INNER JOIN rooms ON accommodations.room_number = rooms.room_id
WHERE students.scholarship > 2000 AND rooms.room_number = 1 AND students.group_name = 2;

SELECT students.student_name, groups.group_name, rooms.room_number
FROM students
INNER JOIN groups ON students.group_name = groups.group_id
INNER JOIN rooms ON students.group_name = groups.group_id;

SELECT students.student_name, accommodations.accommodation_date
FROM students
INNER JOIN accommodations ON students.student_id = accommodations.student_name
WHERE accommodations.accommodation_date BETWEEN '2005-08-01' AND '2005-08-15';

SELECT accommodations.accommodation_id, accommodations.accommodation_date, accommodations.distance, students.student_name
FROM accommodations
LEFT OUTER JOIN students ON students.student_id = accommodations.student_name;

SELECT accommodations.accommodation_id, accommodations.accommodation_date, accommodations.distance, students.student_name 
FROM accommodations 
RIGHT OUTER JOIN students ON students.student_id = accommodations.student_name;

SELECT accommodations.accommodation_id, accommodations.accommodation_date, accommodations.distance, students.student_name, rooms.room_number
FROM accommodations
FULL OUTER JOIN students ON students.student_id = accommodations.student_name
FULL OUTER JOIN rooms ON rooms.room_id = accommodations.room_number;
