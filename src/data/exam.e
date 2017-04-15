class
	EXAM
inherit
	FIELD
	redefine
		default_create,
		make_from_json
	end

create
	default_create,
	make_from_json

feature -- Fields

	course_name: STRING
	semester: STRING
	kind: STRING
	students: INTEGER

feature {NONE} -- Constructor

	default_create
		do
			key := "examinations"
			is_correct := True
			create exception_reason.make_empty
		end

	make_from_json(json_value: JSON_VALUE)
		local
			keys: ARRAY[TUPLE[STRING, BOOLEAN]]
			values: ARRAYED_LIST[STRING]
			parser: PARSER
			checker: CHECKER
		do
			key := "examinations"
			keys := <<	["course_name", False], ["semester", False],
						["kind", False], ["students_number", False]>>
			create parser
			create checker
				-- Initializing
			values := parser.parse_json_object (json_value, keys)
			if
				not parser.parsed
			then
				is_correct := False
				exception_reason := exception_reasons.at (1)
			elseif
				checker.valid_correlation (values, keys)
			then
				is_correct := True
				create exception_reason.make_empty
				make(values.i_th (1), values.i_th (2), values.i_th (3), values.i_th (4))
			else
				is_correct := False
				exception_reason := exception_reasons.at (2)
			end
		end

	make(p_course_name, p_semester, p_kind, number_of_students: STRING)
		-- Fills the fields
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
			else
				is_correct := False
				exception_reason := exception_reasons.at (3)
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
	valid_semester(semester)
	valid_kind(kind)
	students >= 0
end
