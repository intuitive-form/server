class
	RESEARCH_PROJECT

create
	make

feature -- Fields

	title: STRING
	personnel: ARRAYED_LIST[STRING]
	extra_personnel: ARRAYED_LIST[STRING]
	date_start: DATE
	date_end: DATE
	sources_of_financing: STRING

feature {NONE} -- Constructor

	make(p_title, p_date_start, p_date_end, p_sources: STRING; p_personnel, p_extra_personnel: ARRAYED_LIST[STRING])
		do
			title := p_title
			personnel := p_personnel
			extra_personnel := p_extra_personnel
			create date_start.make_from_string(p_date_start, "yyyy-[0]mm-[0]dd")
			create date_end.make_from_string(p_date_end, "yyyy-[0]mm-[0]dd")
			sources_of_financing := p_sources
		end
end
