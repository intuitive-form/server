class
	GRANT
inherit
	FIELD
	redefine
		default_create,
		make_from_json
	end

create
	default_create,
	make_from_json,
	make_ready

feature -- Fields

	title: STRING
	agency: STRING
	period_start: DATE
	period_end: DATE
	continuation: STRING
	amount: INTEGER

feature {NONE} -- Constuctor

	default_create
		-- Default constructor
		do
			key := "grants"
			is_correct := False
			exception_reason := exception_reasons.at (1)
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		do
			key := "grants"
			keys := <<	["title", False], ["agency", False], ["period_start", False],
						["period_end", False], ["continuation", True], ["amount", False] >>
			parse_json_object(json_value)
			if
				not parsed
			then
				is_correct := False
				exception_reason := exception_reasons.at (2)
			else
				is_correct := True
				create exception_reason.make_empty
				make(parsed_string_array.at (1), parsed_string_array.at (2), parsed_string_array.at (3),
						parsed_string_array.at (4), parsed_string_array.at (5), parsed_string_array.at (6))
			end
		end

	make(p_title, p_agency, p_period_start, p_period_end, p_continuation, p_amount: STRING)
		require
			fields_exist:	(p_title /= Void) and then (p_agency /= Void) and then (p_period_start /= Void)
							(p_period_end /= Void) and then (p_continuation /= Void) and then (p_amount /= Void)
		do
			if
				p_amount.is_integer and then p_amount.to_integer >= 0
			then
				title := p_title
				agency := p_agency
				create period_start.make_from_string(p_period_start, "yyyy-[0]mm-[0]dd")
				create period_end.make_from_string(p_period_end, "yyyy-[0]mm-[0]dd")
				continuation := p_continuation
				amount := p_amount.to_integer
			else
				is_correct := False
				exception_reason := exception_reasons.at (3)
			end
		end

	make_ready(p_title, p_agency: STRING; p_start, p_end: DATE; p_continuation: STRING; p_amount: INTEGER)
		do
			is_correct := True
			create exception_reason.make_empty
			title := p_title
			agency := p_agency
			period_start := p_start
			period_end := p_end
			continuation := p_continuation
			amount := p_amount.to_integer
		end

invariant
	is_correct implies (amount >= 0 and then title /= Void and then period_start /= Void and then
						agency /= Void and then period_end /= Void and then continuation /= Void)

end
