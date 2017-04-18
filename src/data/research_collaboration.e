class
	RESEARCH_COLLABORATION
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

	institution_country: STRING
	institution_name: STRING
	contracts: ARRAYED_LIST[STRING]
	nature: STRING

feature {NONE} -- Constructor

	default_create
		-- Default constructor
		do
			key := "collaborations"
			is_correct := False
			exception_reason := exception_reasons.at (1)
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		local
			data: ARRAYED_LIST[STRING]
		do
			key := "country"
			keys := <<["country", False], ["name", False], ["nature", False]>>
			if
				attached {JSON_OBJECT} json_value as json_object
			then
				parse_json_array (json_object.item ("contacts"))
				data := parsed_string_array
				parse_json_object (json_value)
				if
					not parsed
				then
					is_correct := False
					exception_reason := exception_reasons.at (2)
				else
					is_correct := True
					create exception_reason.make_empty
					make(parsed_string_array.at (1), parsed_string_array.at (2), parsed_string_array.at (3), data)
				end
			else
				is_correct := False
				exception_reason := exception_reasons.at (2)
			end
		end

	make(p_country, p_name, p_nature: STRING; p_contracts: ARRAYED_LIST[STRING])
		require
			fields_exist: (p_country /= Void and then p_name /= Void and then p_nature /= Void and then
							p_contracts /= Void)
		do
			institution_country := p_country
			institution_name := p_name
			contracts := p_contracts
			nature := p_nature
		end

invariant
	is_correct implies (institution_country /= Void and then institution_name /= Void and then
						contracts /= Void and then nature /= Void)
end
