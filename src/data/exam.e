class
	EXAM
inherit
	FIELD
	redefine
		make_from_json,
		default_create
	end

create
	default_create,
	make_ready,
	make_from_json

feature -- Fields

	course_name: STRING
	semester: STRING
	kind: STRING
	students: INTEGER
	date: DATE

feature {NONE} -- Constructor

	default_create
		-- Default constructor
		do
			key := "examinations"
			is_correct := False
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from json_value
		do
			key := "examinations"
			keys := <<	["course_name", False],["semester", False],["kind", False],
						["students_number", False],["date", False]>>
			if
				attached {JSON_OBJECT} json_value as json_object
			then
				parse_json_object (json_object)
				is_correct := parsed
				if is_correct then
					make (
						parsed_string_array.at (1),
						parsed_string_array.at (2),
						parsed_string_array.at (3),
						parsed_string_array.at (4),
						parsed_string_array.at (5)
					)
				end
			else
				is_correct := False
			end
		end

	make(p_course_name, p_semester, p_kind, number_of_students, p_date: STRING)
		require
			fields_exist:	(p_course_name /= Void) and then (p_semester /= Void) and then
							(p_kind /= Void) and then (number_of_students /= Void) and then
							(p_date /= Void)
		local
			checker: DATE_VALIDITY_CHECKER
		do
			create checker
			is_correct :=
				valid_semester(p_semester) and then
				valid_kind(p_kind) and then
				number_of_students.is_integer and then
				number_of_students.to_integer >= 0 and then
				checker.date_valid (p_date, "yyyy-[0]mm-[0]dd")
			if is_correct then
				course_name := p_course_name
				semester := p_semester
				kind := p_kind
				students := number_of_students.to_integer
				create date.make_from_string(p_date, "yyyy-[0]mm-[0]dd")
			end
		end

	make_ready(p_course_name, p_semester, p_kind: STRING; p_students: INTEGER; p_date: DATE)
		require
			valid_semester(p_semester)
			valid_kind(p_kind)
		do
			is_correct := True
			course_name := p_course_name
			semester := p_semester
			kind := p_kind
			students := p_students
			date := p_date
		end

feature -- Checkers

	valid_semester(s: STRING): BOOLEAN
		do
			Result := s ~ "Fall" or
				s ~ "Spring"
		end

	valid_kind(k: STRING): BOOLEAN
		do
			Result := k ~ "Final exam" or
				k ~ "Repetition exam" or
				k ~ "Midterm exam"
		end

invariant
	is_correct implies (valid_semester (semester) and then valid_kind (kind) and then
						students >= 0 and then course_name /= Void and then date /= Void)
end
