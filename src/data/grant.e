class
	GRANT

create
	make,
	make_ready

feature -- Fields

	title: STRING
	agency: STRING
	period_start: DATE
	period_end: DATE
	continuation: STRING
	amount: INTEGER

feature {NONE} -- Constuctor

	make(p_title, p_agency, p_period_start, p_period_end, p_continuation, p_amount: STRING)
		require
			p_amount.is_integer and p_amount.to_integer >= 0
		do
			title := p_title
			agency := p_agency
			create period_start.make_from_string(p_period_start, "yyyy-[0]mm-[0]dd")
			create period_end.make_from_string(p_period_end, "yyyy-[0]mm-[0]dd")
			continuation := p_continuation
			amount := p_amount.to_integer
		end

	make_ready(p_title, p_agency: STRING; p_start, p_end: DATE; p_continuation: STRING; p_amount: INTEGER)
		do
			title := p_title
			agency := p_agency
			period_start := p_start
			period_end := p_end
			continuation := p_continuation
			amount := p_amount.to_integer
		end

invariant
	amount >= 0

end
