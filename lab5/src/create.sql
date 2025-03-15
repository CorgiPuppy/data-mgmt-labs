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
