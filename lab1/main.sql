CREATE TABLE IF NOT EXISTS public.groups
	(
		group_id SERIAL,
		group_name character varying(5) NOT NULL,
		CONSTRAINT groups_pkey PRIMARY KEY (group_id)
	);

CREATE TABLE IF NOT EXISTS public.rooms
	(
		room_id SERIAL,
		room_number integer NOT NULL,
		CONSTRAINT room_number_pkey PRIMARY KEY (room_id)
	);

CREATE TABLE IF NOT EXISTS public.students
	(
		student_id SERIAL,
		student_name character varying(15) NOT NULL,
		scholarship integer NOT NULL,
		group_name integer NOT NULL,
		CONSTRAINT students_pkey PRIMARY KEY (student_id),
		CONSTRAINT group_group_name_fkey FOREIGN KEY (group_name)
			REFERENCES public.groups(group_id) MATCH SIMPLE 
				ON UPDATE NO ACTION
				ON DELETE NO ACTION
	);

CREATE TABLE IF NOT EXISTS public.accommodations
	(
		accommodation_id SERIAL,
		accommodation_date date NOT NULL,
		distance integer NOT NULL,
		room_number integer NOT NULL,
		student_name integer NOT NULL,
		neighbour_name integer NOT NULL,
		CONSTRAINT room_room_number_fkey FOREIGN KEY (room_number) 
			REFERENCES public.rooms(room_id) MATCH SIMPLE
				ON UPDATE NO ACTION
				ON DELETE NO ACTION,
		CONSTRAINT student_student_name_fkey FOREIGN KEY (student_name) 
			REFERENCES public.students(student_id) MATCH SIMPLE
				ON UPDATE NO ACTION
				ON DELETE NO ACTION,
		CONSTRAINT neighbour_neighbour_name_fkey FOREIGN KEY (neighbour_name) 
			REFERENCES public.students(student_id) MATCH SIMPLE
				ON UPDATE NO ACTION
				ON DELETE NO ACTION
	);

INSERT INTO groups (group_name) VALUES 
	('CS-10'), 
	('CS-14');

INSERT INTO rooms (room_number) VALUES
	(14),
	(37),
	(25);

INSERT INTO students (student_name, scholarship, group_name) VALUES
	('Vasilyev', 2000, 1),
	('Petrova', 2570, 2),
	('Sidorov', 2000, 2),
	('Ivanov', 2240, 1),
	('Sidorova', 4500, 1),
	('Grishin', 4000, 2);

INSERT INTO accommodations (accommodation_date, distance, room_number, student_name, neighbour_name) VALUES
	('2005-08-03', 200, 1, 1, 6),
	('2005-08-15', 435, 2, 2, 5),
	('2005-08-02', 112, 3, 3, 4),
	('2005-08-02', 240, 3, 4, 3),
	('2005-08-14', 1200, 2, 5, 2),
	('2005-08-04', 780, 1, 6, 1);
