class
	PUBLICATION

create
	make

feature -- Fields

	title: STRING
	authors: ARRAYED_LIST[STRING]

feature {NONE} -- Constructor

	make(p_title: STRING; p_authors: ARRAYED_LIST[STRING])
		do
			title := p_title
			authors := p_authors
		end
end
