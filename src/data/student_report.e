class
	STUDENT_REPORT
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
			key := "student_reports"
			is_correct := False
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constucts field from 'json_value' by 'keys'
		do
			key := "student_reports"
			keys := <<["student_name", False], ["title", False], ["plans", True]>>
			if
				attached {JSON_OBJECT} json_value as json_object
			then
				parse_json_object (json_object)
				is_correct := parsed

				if is_correct then
					make (
						parsed_string_array.at (1),
						parsed_string_array.at (2),
						parsed_string_array.at (3)
					)
				end
			else
				is_correct := False
			end
		end

	make(p_student_name, p_title, p_plans: STRING)
		require
			fields_exist:	(p_student_name /= Void) and then (p_title /= Void)
							(p_plans /= Void)
		do
			is_correct := True
			student_name := p_student_name
			title := p_title
			plans := p_student_name
		end

invariant
	is_correct implies (student_name /= Void and then title /= Void and then
						title /= Void and then plans /= Void)
end
