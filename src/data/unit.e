note
	description: "Summary description for {UNIT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNIT

create
	make

feature -- Fields

	name, head: STRING
	start_date, end_date: DATE


feature {NONE} -- Constructor

	make(p_name, p_head, p_start_date, p_end_date: STRING)
		do
			name := p_name
			head := p_head
			create start_date.make_from_string(p_start_date, "yyyy-[0]mm-[0]dd")
			create end_date.make_from_string(p_end_date, "yyyy-[0]mm-[0]dd")
		end


end
