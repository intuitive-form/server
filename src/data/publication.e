class
	PUBLICATION
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
	authors: ARRAYED_LIST[STRING]
	date: DATE


feature {NONE} -- Constructor

	default_create
		-- Deafault constructor
		do
			is_correct := False
			exception_reason := exception_reasons.at (1)
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs from 'json_value' by 'keys'
		local
			data: ARRAYED_LIST[STRING]
		do
			keys := <<["title", False], ["date", False]>>
			if
				attached {JSON_OBJECT} json_value as json_object
			then
				parse_json_array (json_object)
				data := parsed_string_array
			else
				is_correct := False
				exception_reason := exception_reasons.at (2)
			end
			parse_json_object (json_value)
			if
				not parsed
			then
				is_correct := False
				exception_reason := exception_reasons.at (2)
			else
				is_correct := True
				create exception_reason.make_empty
				make(parsed_string_array.at (1), parsed_string_array.at (2), data)
			end
		end

	make(p_title, p_date: STRING; p_authors: ARRAYED_LIST[STRING])
		require
			fields_exuit:	(p_title /= Void) and then (p_date /= Void) and then
							(p_authors /= Void)
		do
			if
				p_authors.count > 0
			then
				title := p_title
				authors := p_authors
				create date.make_from_string(p_date, "yyyy-[0]mm-[0]dd")
			else
				is_correct := False
				exception_reason := exception_reasons.at (3)
			end
		end
		
invariant
	is_correct implies (title /= Void and then authors.count > 0 and then date /= Void)
end
