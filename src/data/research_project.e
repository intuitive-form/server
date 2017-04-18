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
			exception_reason := exception_reasons.at (1)
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		local
			data_1, data_2: ARRAYED_LIST[STRING]
		do
			key := "projects"
			keys := <<["title", False], ["start_date", False], ["end_date", False], ["financing", False]>>
			if
				attached {JSON_OBJECT} json_value as json_object
			then
				parse_json_array (json_object.item ("personnel"))
				data_1 := parsed_string_array
				parse_json_array (json_object.item ("extra_personnel"))
				data_2 := parsed_string_array
				parse_json_object (json_value)
				if
					not parsed
				then
					is_correct := False
					exception_reason := exception_reasons.at (2)
				else
					is_correct := True
					create exception_reason.make_empty
					make(parsed_string_array.at (1), parsed_string_array.at (2), parsed_string_array.at (3),
						parsed_string_array.at (4), data_1, data_2)
				end
			else
				is_correct := False
				exception_reason := exception_reasons.at (2)
			end
		end

	make(p_title, p_date_start, p_date_end, p_sources: STRING; p_personnel, p_extra_personnel: ARRAYED_LIST[STRING])
		require
			fields_exist: 	(p_title /= Void) and then (p_date_start /= Void) and then (p_date_end /= Void) and then
							(p_sources /= Void) and then (p_personnel /= Void) and then (p_extra_personnel /= Void)
		do
			if
				p_personnel.count > 0
			then
				title := p_title
				personnel := p_personnel
				extra_personnel := p_extra_personnel
				create date_start.make_from_string(p_date_start, "yyyy-[0]mm-[0]dd")
				create date_end.make_from_string(p_date_end, "yyyy-[0]mm-[0]dd")
				sources_of_financing := p_sources
			else
				is_correct := False
				exception_reason := exception_reasons.at (3)
			end
		end

invariant
	is_correct implies (title /= Void and then personnel.count > 0 and then extra_personnel /= Void and then
						date_start /= Void and then date_end /= Void and then sources_of_financing /= Void)

end
