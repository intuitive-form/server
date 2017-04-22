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
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' and 'keys'
		do
			key := "patents"
			keys := <<["title", False], ["country", False]>>

			if
				attached {JSON_OBJECT} json_value as json_object
			then
				parse_json_object (json_object)
				is_correct := parsed

				if is_correct then
					make (
						parsed_string_array.at (1),
						parsed_string_array.at (2)
					)
				end
			else
				is_correct := False
			end
		end

	make(p_title, p_country: STRING)
		require
			fields_exist:	(p_title /= Void) and then (p_country /= Void)
		do
			is_correct := True
			title := p_title
			country := p_country
		end

invariant
	is_correct implies (title /= Void and then
						country /= Void)
end
