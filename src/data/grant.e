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
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		do
			key := "grants"
			keys := <<	["title", False], ["agency", False], ["period_start", False],
						["period_end", False], ["continuation", True], ["amount", False] >>
			if
				attached {JSON_OBJECT} json_value as json_object
			then
				parse_json_object (json_object)
				is_correct := parsed

				if is_correct then
					make (
						parsed_string_array.at (1),
						parsed_string_array.at (2),
						parsed_string_array.at (3),
						parsed_string_array.at (4),
						parsed_string_array.at (5),
						parsed_string_array.at (6)
					)
				end
			else
				is_correct := False
			end
		end

	make(p_title, p_agency, p_period_start, p_period_end, p_continuation, p_amount: STRING)
		require
			fields_exist:	(p_title /= Void) and then (p_agency /= Void) and then (p_period_start /= Void)
							(p_period_end /= Void) and then (p_continuation /= Void) and then (p_amount /= Void)
		local
			checker: DATE_VALIDITY_CHECKER
		do
			create checker
			if
				p_amount.is_integer and then p_amount.to_integer >= 0 and then
				checker.date_valid (p_period_start, "yyyy-[0]mm-[0]dd") and then
				checker.date_valid (p_period_end, "yyyy-[0]mm-[0]dd")
			then
				title := p_title
				agency := p_agency
				create period_start.make_from_string(p_period_start, "yyyy-[0]mm-[0]dd")
				create period_end.make_from_string(p_period_end, "yyyy-[0]mm-[0]dd")
				continuation := p_continuation
				amount := p_amount.to_integer
				is_correct := period_start.is_less (period_end)
			else
				is_correct := False
			end
		end

	make_ready(p_title, p_agency: STRING; p_start, p_end: DATE; p_continuation: STRING; p_amount: INTEGER)
		do
			is_correct := True
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
