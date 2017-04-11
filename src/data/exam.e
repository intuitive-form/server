class
	EXAM

create
	make

feature -- Fields

	course_name: STRING
	semester: STRING
	kind: STRING
	students: INTEGER

feature {NONE} -- Constructor

	make(p_course_name, p_semester, p_kind, number_of_students: STRING)
		require
			valid_semester(p_semester)
			valid_kind(p_kind)
			number_of_students.is_integer and number_of_students.to_integer >= 0
		do
			course_name := p_course_name
			semester := p_semester
			kind := p_kind
			students := number_of_students.to_integer
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
