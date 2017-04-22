class
	RESEARCH_PROJECT
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
	personnel: ARRAYED_LIST[STRING]
	extra_personnel: ARRAYED_LIST[STRING]
	date_start: DATE
	date_end: DATE
	sources_of_financing: STRING

feature {NONE} -- Constructor

	default_create
		-- Default create
		do
			key := "projects"
			is_correct := False
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		local
			data_1, data_2: ARRAYED_LIST[STRING]
		do
			key := "projects"
			keys := <<["title", False], ["start_date", False], ["end_date", False], ["financing", False]>>
			if
				attached {JSON_OBJECT} json_value as json_object and then
				attached {JSON_ARRAY} json_object.item ("personnel") as json_personnel and then
				attached {JSON_ARRAY} json_object.item ("extra_personnel") as json_extra_personnel
			then
				parse_json_array (json_personnel)
				data_1 := parsed_string_array
				is_correct := parsed

				if is_correct then
					parse_json_array (json_extra_personnel)
					data_2 := parsed_string_array
					is_correct := parsed
				end

				if is_correct then
					parse_json_object (json_object)
					is_correct := parsed
				end

				if is_correct then
					make (
						parsed_string_array.at (1),
						parsed_string_array.at (2),
						parsed_string_array.at (3),
						parsed_string_array.at (4),
						data_1, data_2
					)
				end
			else
				is_correct := False
			end
		end

	make(p_title, p_date_start, p_date_end, p_sources: STRING; p_personnel, p_extra_personnel: ARRAYED_LIST[STRING])
		require
			fields_exist: 	(p_title /= Void) and then (p_date_start /= Void) and then (p_date_end /= Void) and then
							(p_sources /= Void) and then (p_personnel /= Void) and then (p_extra_personnel /= Void)
		local
			checker: DATE_VALIDITY_CHECKER
		do
			create checker
			is_correct :=
				p_personnel.count > 0 and then
				checker.date_valid (p_date_start, "yyyy-[0]mm-[0]dd") and then
				checker.date_valid (p_date_end, "yyyy-[0]mm-[0]dd")
			if is_correct then
				title := p_title
				personnel := p_personnel
				extra_personnel := p_extra_personnel
				create date_start.make_from_string(p_date_start, "yyyy-[0]mm-[0]dd")
				create date_end.make_from_string(p_date_end, "yyyy-[0]mm-[0]dd")
				sources_of_financing := p_sources
			end
		end

invariant
	is_correct implies (title /= Void and then personnel.count > 0 and then extra_personnel /= Void and then
						date_start /= Void and then date_end /= Void and then sources_of_financing /= Void)

end
