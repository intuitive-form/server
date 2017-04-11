class
	PUBLICATION

create
	make

feature -- Fields

	title: STRING
	authors: ARRAYED_LIST[STRING]
	date: DATE


feature {NONE} -- Constructor

	make(p_title, p_date: STRING; p_authors: ARRAYED_LIST[STRING])
		do
			title := p_title
			authors := p_authors
			create date.make_from_string(p_date, "yyyy-[0]mm-[0]dd")
		end
end
