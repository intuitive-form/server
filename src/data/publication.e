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
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs from 'json_value' by 'keys'
		local
			data: ARRAYED_LIST[STRING]
		do
			keys := <<["title", False], ["date", False]>>
			if
				attached {JSON_OBJECT} json_value as json_object and then
				attached {JSON_ARRAY} json_object.item ("authors") as json_authors
			then
				parse_json_array (json_authors)
				data := parsed_string_array
				is_correct := parsed

				if is_correct then
					parse_json_object (json_object)
					is_correct := parsed
				end

				if is_correct then
					make (parsed_string_array.at (1), parsed_string_array.at (2), data)
				end
			else
				is_correct := False
			end

		end

	make(p_title, p_date: STRING; p_authors: ARRAYED_LIST[STRING])
		require
			fields_exuit:	(p_title /= Void) and then (p_date /= Void) and then
							(p_authors /= Void)
		local
			checker: DATE_VALIDITY_CHECKER
		do
			create checker
			is_correct := p_authors.count > 0 and checker.date_valid (p_date, "yyyy-[0]mm-[0]dd")
			if is_correct then
				title := p_title
				authors := p_authors
				create date.make_from_string(p_date, "yyyy-[0]mm-[0]dd")
			end
		end

invariant
	is_correct implies (title /= Void and then authors.count > 0 and then date /= Void)
end
