class
	PATENT

create
	make

feature
	-- Fields
	title, country: STRING

feature {NONE}
	-- Constructor
	make(p_title, p_country: STRING)
		do
			title := p_title
			country := p_country
		end

invariant
	title /= Void
	country /= Void
end
