class
	GET_COURSES

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
			across db.selector.courses as course loop
				create j_obj.make_with_capacity (2)
				j_obj.put (create {JSON_STRING}.make_from_string (course.item.name), "title")
				j_obj.put (create {JSON_STRING}.make_from_string (course.item.semester), "semester")
				j.add (j_obj)
			end
			res.send (create {WSF_PAGE_RESPONSE}.make_with_body (j.representation))
		end

end
