class
	STUDENT
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

	name: STRING
	nature_of_work: STRING

feature {NONE} -- Constructor

	default_create
		-- Default create
		do
			key := "students"
			is_correct := False
			exception_reason := exception_reasons.at(1)
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constucts field from 'json_value' by 'keys'
		do
			key := "students"
			keys := <<["name", False],["nature_of_work", False]>>
			parse_json_object(json_value)
			if
				not parsed
			then
				is_correct := False
				exception_reason := exception_reasons.at(2)
			else
				is_correct := True
				create exception_reason.make_empty
				make(parsed_string_array.at(1), parsed_string_array.at(2))
			end
		end

	make(p_name, p_nature_of_work: STRING)
		require
			fields_exist:	(p_name /= Void) and then
							(p_nature_of_work /= Void)
		do
			name := p_name
			nature_of_work := p_nature_of_work
		end

invariant
	is_correct implies (name /= Void and then
						nature_of_work /= Void)
end
