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
	make_from_json

feature -- Fields

	title: STRING

feature {NONE} -- Constructors

	default_create
		-- Default constructor
		do
			key := "licensing"
			is_correct := False
			exception_reason := exception_reasons.at (1)
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		do
			key := "licensing"
			keys := <<["title", False]>>
			parse_json_object (json_value)
			if
				not parsed
			then
				is_correct := False
				exception_reason := exception_reasons.at (2)
			else
				is_correct := True
				create exception_reason.make_empty
				make(parsed_string_array.at (1))
			end
		end

	make(p_title: STRING)
		require
			field_exist: p_title /= Void
		do
			title := p_title
		end

invariant
	is_correct implies (title /= Void)
end
