class
	PHD_THESIS
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

	student_name: STRING
	title: STRING
	plans: STRING

feature {NONE} -- Constructor

	default_create
		-- Default constructor
		do
			key := "phd_reports"
			is_correct := False
			exception_reason := exception_reasons.at (1)
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		do
			key := "phd_reports"
			keys := <<["student_name", False], ["title", False], ["plans", True]>>
			parse_json_object(json_value)
			if
				not parsed
			then
				is_correct := False
				exception_reason := exception_reasons.at (1)
			else
				is_correct := True
				create exception_reason.make_empty
			end
		end

	make(p_student_name, p_title, p_plans: STRING)
		require
			fields_exist: 	(p_student_name /= Void) and then (p_title /= Void)
							(p_plans /= Void)
		do
			student_name := p_student_name
			title := p_title
			plans := p_plans
		end

invariant
	is_correct implies (student_name /= Void and then title /= Void and then
						plans /= Void)
end

