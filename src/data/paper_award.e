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
	make_from_json

feature -- Fields

	title, awarder, award_wording: STRING
	authors: ARRAYED_LIST[STRING]
	date: DATE


feature {NONE} -- Constructors

	default_create
		-- Default constructor
		do
			key := "paper_awards"
			is_correct := False
			exception_reason := exception_reasons.at (1)
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		local
			data: ARRAYED_LIST[STRING]
		do
			key := "paper_awards"
			keys := <<["title", False], ["conference_journal", False], ["wording", False], ["date", False]>>
			if
				attached {JSON_OBJECT} json_value as json_object
			then
				parse_json_array(json_object.item ("authors"))
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
					make(parsed_string_array.at (1), parsed_string_array.at (2), parsed_string_array.at (3),
							parsed_string_array.at (4), data)
				end
			else
				is_correct := False
				exception_reason := exception_reasons.at (2)
			end
		end

	make(p_title, p_awarder, p_award_wording, p_date: STRING; p_authors: ARRAYED_LIST[STRING])
		require
			fields_exist: 	(p_title /= Void) and then (p_awarder /= Void) and then (p_award_wording /= Void) and then
							(p_date /= Void) and then (p_authors /= Void)
		do
			title := p_title
			awarder := p_awarder
			award_wording := p_award_wording
			authors := p_authors
			create date.make_from_string(p_date, "yyyy-[0]mm-[0]dd")
		end

invariant
	is_correct implies (title /= Void and then awarder /= Void and then award_wording /= Void and then
						authors /= Void and then date /= Void)
end
