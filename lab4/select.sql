-- Формирование списка студентов по их индетификационному номеру
SELECT groups.group_name, students.scholarship, AVG(students.scholarship) over() AS avg_scholarship 
FROM public.groups, public.students; 


