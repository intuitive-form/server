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
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		do
			key := "prizes"
			keys := <<	["recipient", False],["name", False],
						["institution", False],["date", False]>>
			if
				attached {JSON_OBJECT} json_value as json_object
			then
				parse_json_object (json_object)
				is_correct := parsed
				if is_correct then
					make (
						parsed_string_array.at (1),
						parsed_string_array.at (2),
						parsed_string_array.at (3),
						parsed_string_array.at (4)
					)
				end
			else
				is_correct := False
			end
		end

	make(p_recipient, p_name, p_institution, p_date: STRING)
		local
			checker: DATE_VALIDITY_CHECKER
		do
			create checker
			is_correct := checker.date_valid (p_date, "yyyy-[0]mm-[0]dd")
			if is_correct then
				recipient := p_recipient
				name := p_name
				institution := p_institution
				create date.make_from_string (p_date, "yyyy-[0]mm-[0]dd")
			end
		end

invariant
	is_correct implies (recipient /= Void and then name /= Void and then
						institution /= Void and then date /= Void)
end
