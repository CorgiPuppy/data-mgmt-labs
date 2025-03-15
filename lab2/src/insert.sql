INSERT INTO groups (group_name)
VALUES 
	('CS-10'), 
	('CS-14');

INSERT INTO rooms (room_number)
VALUES
	(14),
	(37),
	(25);

INSERT INTO students (student_name, scholarship, group_name) 
VALUES
	('Vasilyev', 2000, 1),
	('Petrova', 2570, 2),
	('Sidorov', 2000, 2),
	('Ivanov', 2240, 1),
	('Sidorova', 4500, 1),
	('Grishin', 4000, 2);

INSERT INTO accommodations (accommodation_date, distance, room_number, student_name, neighbour_name) 
VALUES
	('2005-08-03', 200, 1, 1, 6),
	('2005-08-15', 435, 2, 2, 5),
	('2005-08-02', 112, 3, 3, 4),
	('2005-08-02', 240, 3, 4, 3),
	('2005-08-14', 1200, 2, 5, 2),
	('2005-08-04', 780, 1, 6, 1);

INSERT INTO accommodations (accommodation_date, distance, room_number, student_name, neighbour_name) 
VALUES 
    ('2005-08-05', 300, 1, NULL, NULL), 
    ('2005-08-06', 500, 2, NULL, NULL);
