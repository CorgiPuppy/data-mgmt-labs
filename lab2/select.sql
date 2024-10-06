SELECT students.student_name, groups.group_name
FROM students
INNER JOIN groups ON students.group_name = groups.group_id
WHERE groups.group_id = 1;

SELECT students.student_name, rooms.room_number, accommodations.distance
FROM students
INNER JOIN accommodations ON students.student_id = accommodations.student_name
INNER JOIN rooms ON accommodations.room_number = rooms.room_id
WHERE rooms.room_number > 1 AND students.group_name = 2;
