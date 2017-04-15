class
	PAPER_AWARD

create
	make

feature -- Fields

	title, awarder, award_wording: STRING
	authors: ARRAYED_LIST[STRING]
	date: DATE


feature {NONE} -- Constructor

	make(p_title, p_awarder, p_award_wording, p_date: STRING; p_authors: ARRAYED_LIST[STRING])
		do
			title := p_title
			awarder := p_awarder
			award_wording := p_award_wording
			authors := p_authors
			create date.make_from_string(p_date, "yyyy-[0]mm-[0]dd")
		end
end
