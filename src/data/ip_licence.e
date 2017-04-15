class
	IP_LICENCE

create
	make

feature
	-- Fields
	title: STRING

feature {NONE}
	-- Constructor
	make(p_title: STRING)
		do
			title := p_title
		end

invariant
	title /= Void
end
