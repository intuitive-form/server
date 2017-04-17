class
	GET_UNITS

inherit
	WSF_STARTS_WITH_HANDLER

create
	make

feature {NONE} -- Initialization

	make (p_db: DB_HANDLER)
		do
			db := p_db
		end

	db: DB_HANDLER

feature -- Execution

	execute (a_start_path: READABLE_STRING_8; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			j: JSON_ARRAY
			j_obj: JSON_OBJECT
		do
			create j.make_empty
			across db.selector.unit_names as unit loop
				j.add (create {JSON_STRING}.make_from_string (unit.item))
			end
			res.send (create {WSF_PAGE_RESPONSE}.make_with_body (j.representation))
		end

end
