class
	PHD_THESIS

create
	make

feature -- Fields

	student_name: STRING
	title: STRING
	plans: STRING

feature {NONE} -- Constructor

	make(p_student_name, p_title, p_plans: STRING)
		do
			student_name := p_student_name
			title := p_title
			plans := p_plans
		end

invariant
	student_name /= Void
	title /= Void
	plans /= Void
end

