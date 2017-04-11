class
	STUDENT

create
	make

feature -- Fields

	name: STRING
	nature_of_work: STRING

feature {NONE} -- Constructor

	make(p_name, p_nature_of_work: STRING)
		do
			name := p_name
			nature_of_work := p_nature_of_work
		end
		
invariant
	name /= Void
	nature_of_work /= Void
end
