class
	CHECKER

create make

feature {NONE}
	submit_data: SUBMIT_DATA

feature {NONE}
	make(p_sd: SUBMIT_DATA)
		do
			submit_data := p_sd
		end

end
