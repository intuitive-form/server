class
	PATENT
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

	title, country: STRING

feature {NONE}	-- Constructors

	default_create
		-- Default constructor
		do
			key := "patents"
			is_correct := False
			exception_reason := exception_reasons.at (1)
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' and 'keys'
		do
			key := "patents"
			keys := <<["title", False], ["country", False]>>
			parse_json_object (json_value)
			if
				not parsed
			then
				is_correct := False
				exception_reason := exception_reasons.at (2)
			else
				is_correct := True
				create exception_reason.make_empty
				make(parsed_string_array.at (1), parsed_string_array.at (2))
			end
		end

	make(p_title, p_country: STRING)
		require
			fields_exist:	(p_title /= Void) and then (p_country /= Void)
		do
			title := p_title
			country := p_country
		end

invariant
	is_correct implies (title /= Void and then
						country /= Void)
end
