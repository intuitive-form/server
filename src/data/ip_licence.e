class
	IP_LICENCE
inherit
	FIELD
	redefine
		default_create,
		make_from_json
	end

create
	default_create,
	make,
	make_from_json

feature -- Fields

	title: STRING

feature {NONE} -- Constructors

	default_create
		-- Default constructor
		do
			key := "licensing"
			is_correct := False
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		do
			key := "licensing"
			keys := <<["title", False]>>
			if
				attached {JSON_OBJECT} json_value as json_object
			then
				parse_json_object (json_object)
				is_correct := parsed

				if is_correct then
					make (parsed_string_array.at (1))
				end
			else
				is_correct := False
			end
		end

	make(p_title: STRING)
		require
			field_exist: p_title /= Void
		do
			is_correct := True
			title := p_title
		end

invariant
	is_correct implies (title /= Void)
end
