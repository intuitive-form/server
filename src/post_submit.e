class
	POST_SUBMIT

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
			j: JSON_OBJECT
			data: SUBMIT_DATA
			msg: WSF_PAGE_RESPONSE
		do
			create j.make
			create data.make (req)
			if data.is_correct then
				db.insert (data)
				j.put (create {JSON_STRING}.make_from_string ("ok"), "status")
			else
				j.put (create {JSON_STRING}.make_from_string ("error"), "status")
			end
			res.send (create {WSF_PAGE_RESPONSE}.make_with_body (j.representation))
		end

end
