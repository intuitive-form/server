class
	COURSE
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

	name: STRING
	semester: STRING
	level: STRING
	students: INTEGER
	start_date: DATE
	end_date: DATE

feature {NONE} -- Constructor

	default_create
		-- Default constructor
		do
			key := "courses"
			is_correct := True
			create exception_reason.make_empty
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from json_object
		local
			keys: ARRAY[TUPLE[STRING, BOOLEAN]]
			values: ARRAYED_LIST[STRING]
			parser: PARSER
			checker: CHECKER
		do
			key := "courses"
			keys := <<	["name", False], ["semester", False], ["level", False],
						 ["students", False], ["start_date", False], ["start-date", False]>>
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
				make(values.at (1), values.at (2), values.at (3),
				values.at (4), values.at (5), values.at (6))
			else
				is_correct := False
				exception_reason := exception_reasons.at (2)
			end
		end

	make(p_name, p_semester, p_level, p_students, p_start_date, p_end_date: STRING)
		-- Fills the fieds
		do
			if
				valid_semester (p_semester) and then
				valid_level(p_level) and then
				p_students.is_integer and then
				p_students.to_integer >= 0
			then
				is_correct := True
				create exception_reason.make_empty

				name := p_name
				semester := p_semester
				level := p_level
				students := p_students.to_integer
				create start_date.make_from_string (p_start_date, "yyyy-[0]mm-[0]dd")
				create end_date.make_from_string (p_end_date, "yyyy-[0]mm-[0]dd")
			else
				is_correct := False
				exception_reason := exception_reasons.at (3)
			end
		end

	make_ready(p_name, p_semester, p_level: STRING; p_students: INTEGER; p_start_date, p_end_date: DATE)
		do
			name := p_name
			semester := p_semester
			level := p_level
			students := p_students
			start_date := p_start_date
			end_date := p_end_date
		end


feature -- Checkers

	valid_semester(s: STRING): BOOLEAN
		do
			Result := s ~ "Fall" or
				s ~ "Spring"
		end

	valid_level(l: STRING): BOOLEAN
		do
			Result := l ~ "Bachelor" or
				l ~ "Master"
		end

invariant
	valid_semester(semester)
	valid_level(level)
	students >= 0

end
