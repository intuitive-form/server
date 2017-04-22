class
	COLLABORATION
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

	company: STRING
	nature: STRING

feature -- Constructors

	default_create
		-- Default constructor
		do
			key := "collaborations"
			is_correct := False
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		do
			key := "collaborations"
			keys := <<["company", False], ["nature", False]>>
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

	make(p_company, p_nature: STRING)
		require
			fields_exist: 	(p_company /= Void) and then (p_nature /= Void)
		do
			is_correct := True
			company := p_company
			nature := p_nature
		end

invariant
	is_correct implies (company /= Void and then nature /= Void)
end
