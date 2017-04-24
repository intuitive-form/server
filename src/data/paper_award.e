class
	PAPER_AWARD
inherit
	FIELD
	redefine
		default_create,
		make_from_json
	end

create
	default_create,
	make_ready,
	make_from_json

feature -- Fields

	title, awarder, award_wording: STRING
	authors: ARRAYED_LIST[STRING]
	date: DATE

feature
	to_json: JSON_OBJECT
		local
			j_arr: JSON_ARRAY
		do
			create Result.make_with_capacity (5)
			create j_arr.make (authors.count)
			across authors as iter loop
				j_arr.add (create {JSON_STRING}.make_from_string (iter.item))
			end
			Result.put (create {JSON_STRING}.make_from_string (title), "title")
			Result.put (create {JSON_STRING}.make_from_string (award_wording), "award_wording")
			Result.put (create {JSON_STRING}.make_from_string (awarder), "awarder")
			Result.put (create {JSON_STRING}.make_from_string (date.formatted_out ("yyyy-[0]mm-[0]dd")), "date")
			Result.put (j_arr, "authors")
		end


feature {NONE} -- Constructors

	default_create
		-- Default constructor
		do
			key := "paper_awards"
			is_correct := False
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		local
			data: ARRAYED_LIST[STRING]
		do
			key := "paper_awards"
			keys := <<["title", False], ["conference_journal", False], ["wording", False], ["date", False]>>
			if
				attached {JSON_OBJECT} json_value as json_object and then
				attached {JSON_ARRAY} json_object.item ("authors") as json_authors
			then
				parse_json_array (json_authors)
				data := parsed_string_array
				parse_json_object (json_object)
				is_correct := parsed
				if is_correct then
					make (
						parsed_string_array.at (1),
						parsed_string_array.at (2),
						parsed_string_array.at (3),
						parsed_string_array.at (4),
						data
					)
				end
			else
				is_correct := False
			end
		end

	make(p_title, p_awarder, p_award_wording, p_date: STRING; p_authors: ARRAYED_LIST[STRING])
		require
			fields_exist: 	(p_title /= Void) and then (p_awarder /= Void) and then (p_award_wording /= Void) and then
							(p_date /= Void) and then (p_authors /= Void)
		local
			checker: DATE_VALIDITY_CHECKER
		do
			create checker
			is_correct := p_authors.count > 0 and checker.date_valid (p_date, "yyyy-[0]mm-[0]dd")
			if is_correct then
				make_ready (p_title, p_awarder, p_award_wording,
					create {DATE}.make_from_string(p_date, "yyyy-[0]mm-[0]dd"), p_authors)
			end

		end

	make_ready (p_title, p_awarder, p_award_wording: STRING; p_date: DATE; p_authors: ARRAYED_LIST[STRING])
		require
			fields_exist: 	(p_title /= Void) and then (p_awarder /= Void) and then (p_award_wording /= Void) and then
							(p_date /= Void) and then (p_authors /= Void)
		do
			title := p_title
			awarder := p_awarder
			award_wording := p_award_wording
			date := p_date
			authors := p_authors
		end

invariant
	is_correct implies (title /= Void and then awarder /= Void and then award_wording /= Void and then
						authors /= Void and then date /= Void)
end
