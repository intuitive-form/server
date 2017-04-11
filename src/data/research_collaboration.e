class
	RESEARCH_COLLABORATION

create
	make

feature -- Fields

	institution_country: STRING
	institution_name: STRING
	contracts: ARRAYED_LIST[STRING]
	nature: STRING

feature {NONE} -- Constructor

	make(p_country, p_name, p_nature: STRING; p_contracts: ARRAYED_LIST[STRING])
		do
			institution_country := p_country
			institution_name := p_name
			contracts := p_contracts
			nature := p_nature
		end
end
