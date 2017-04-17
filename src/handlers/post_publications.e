class
	POST_PUBLICATIONS

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
			j_arr: JSON_ARRAY
			list: LIST[STRING]
			d: DATE
		do
			create j.make_empty
			if not attached {WSF_STRING} req.form_parameter ("year") as year then
				j.put (create {JSON_STRING}.make_from_string ("no input"), "error")
			elseif not
				(year.is_integer and then
				attached year.integer_value as y and then
				year.integer_value >= 1600 and year.integer_value <= 3000)
			then
				j.put (create {JSON_STRING}.make_from_string ("wrong input"), "error")
			else
				list := db.selector.journal_pubs (y)
				create j_arr.make (list.count)
				across list as v loop
					j_arr.add (create {JSON_STRING}.make_from_string (v.item))
				end
				j.put (j_arr, "journal_pubs")
				list := db.selector.conf_pubs (y)
				create j_arr.make (list.count)
				across list as v loop
					j_arr.add (create {JSON_STRING}.make_from_string (v.item))
				end
				j.put (j_arr, "conf_pubs")
			end
			res.send (create {WSF_PAGE_RESPONSE}.make_with_body (j.representation))
		end

end
