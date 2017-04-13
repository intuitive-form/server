class
	COURSE

create
	make,
	make_ready

feature -- Fields

	name: STRING
	semester: STRING
	level: STRING
	students: INTEGER
	start_date: DATE
	end_date: DATE

feature {NONE} -- Constructor

	make(p_name, p_semester, p_level, number_of_students, p_start_date, p_end_date: STRING)
		require
			valid_semester(p_semester)
			valid_level(p_level)
			number_of_students.is_integer and number_of_students.to_integer >= 0
		do
			name := p_name
			semester := p_semester
			level := p_level
			students := number_of_students.to_integer
			create start_date.make_from_string(p_start_date, "yyyy-[0]mm-[0]dd")
			create end_date.make_from_string(p_end_date, "yyyy-[0]mm-[0]dd")
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
