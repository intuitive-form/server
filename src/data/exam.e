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
			exception_reason := exception_reasons.at(1)
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from json_value
		do
			key := "examinations"
			keys := <<	["course_name", False],["semester", False],["kind", False],
						["students_number", False],["date", False]>>
			parse_json_object(json_value)
			if
				not parsed
			then
				is_correct := False
				exception_reason := exception_reasons.at(2)
			else
				is_correct := True
				create exception_reason.make_empty
				make(parsed_string_array.at (1), parsed_string_array.at (2), parsed_string_array.at (3),
					parsed_string_array.at (4), parsed_string_array.at (5))
			end
		end

	make(p_course_name, p_semester, p_kind, number_of_students, p_date: STRING)
		require
			fields_exist:	(p_course_name /= Void) and then (p_semester /= Void) and then
							(p_kind /= Void) and then (number_of_students /= Void)
		do
			if
				valid_semester(p_semester) and then
				valid_kind(p_kind) and then
				number_of_students.is_integer and then
				number_of_students.to_integer >= 0
			then
				course_name := p_course_name
				semester := p_semester
				kind := p_kind
				students := number_of_students.to_integer
				create date.make_from_string(p_date, "yyyy-[0]mm-[0]dd")
			else
				is_correct := False
				exception_reason := exception_reasons.at(3)
			end
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
						students >= 0)
end
