class
	UNIT
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

	name, head, misc: STRING
	start_date, end_date: DATE


feature {NONE} -- Constructor

	default_create
		-- Default constructor
		do
			key := "section1"
			is_correct := False
			exception_reason := exception_reasons.at (1)
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		do
			key := "section1"
			keys := <<	["unit_name", False], ["head_name", False], ["reporting_period_start", False],
						["reporting_period_end", False]>>
			parse_json_object (json_value)
			if
				not parsed
			then
				is_correct := False
				exception_reason := exception_reasons.at (2)
			else
				is_correct := True
				create exception_reason.make_empty
				make(parsed_string_array.at (1), parsed_string_array.at (2), parsed_string_array.at (3),
						parsed_string_array.at (4), "")
			end
		end

	make(p_name, p_head, p_start_date, p_end_date, p_misc: STRING)
		require
			fields_exist: 	(p_name /= Void) and then (p_head /= Void) and then (p_start_date /= Void) and then
							(p_end_date /= Void)
		do
			name := p_name
			head := p_head
			create start_date.make_from_string(p_start_date, "yyyy-[0]mm-[0]dd")
			create end_date.make_from_string(p_end_date, "yyyy-[0]mm-[0]dd")
			misc := p_misc
		end

invariant
	is_correct implies (name /= Void and then head /= Void and then start_date /= Void
					and then end_date /= Void and then misc /= Void)
end
