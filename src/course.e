class
	COURSE

create
	make

feature -- Fields
	name: STRING
	semester: STRING
	level: STRING
	students: INTEGER

feature {NONE} -- Constructor
	make(p_name, p_semester, p_level, number_of_students: STRING)
		require
			valid_semester(p_semester)
			valid_level(p_level)
			number_of_students.is_integer and number_of_students.to_integer >= 0
		do
			name := p_name
			semester := p_semester
			level := p_level
			students := number_of_students.to_integer
		end


feature -- Checkers
	valid_semester(s: STRING): BOOLEAN
		do
			Result := s ~ "Fall" or
				s ~ "Summer"
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
