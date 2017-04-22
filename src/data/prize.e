class
	PRIZE
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

	recipient: STRING
	name: STRING
	institution: STRING
	date: DATE

feature -- Constructors

	default_create
		-- Default constructor
		do
			key := "prizes"
			is_correct := False
			exception_reason := exception_reasons.at (1)
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		do
			key := "prizes"
			keys := <<	["recipient", False],["name", False],
						["institution", False],["date", False]>>
			parse_json_object (json_value)
			if
				not parsed
			then
				is_correct := False
				exception_reason := exception_reasons.at (2)
			else
				is_correct := True
				create exception_reason.make_empty
				make(parsed_string_array.at (1), parsed_string_array.at (2),
						parsed_string_array.at (3), parsed_string_array.at (4))
			end
		end

	make(p_recipient, p_name, p_institution, p_date: STRING)
		local
			checker: DATE_VALIDITY_CHECKER
		do
			create checker
			if
				checker.date_valid (p_date, "yyyy-[0]mm-[0]dd")
			then
				recipient := p_recipient
				name := p_name
				institution := p_institution
				create date.make_from_string (p_date, "yyyy-[0]mm-[0]dd")
			else
				is_correct := False
				exception_reason := exception_reasons.at (3)
			end
		end

invariant
	is_correct implies (recipient /= Void and then name /= Void and then
						institution /= Void and then date /= Void)
end
