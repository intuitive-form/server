class
	POST_GRANTS

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
			j, j_grant: JSON_OBJECT
			j_arr: JSON_ARRAY
			list: LIST[GRANT]
		do
			create j.make_empty
			if
				not attached {WSF_STRING} req.form_parameter ("unit") as unit
			then
				j.put (create {JSON_STRING}.make_from_string ("no input"), "error")
			elseif
				not db.selector.unit_exists (unit.value)
			then
				j.put (create {JSON_STRING}.make_from_string ("no such unit"), "error")
			else
				list := db.selector.grants_of_unit (unit.value)
				create j_arr.make (list.count)
				across list as g loop
					create j_grant.make_with_capacity (2)
					j_grant.put (create {JSON_STRING}.make_from_string (g.item.title), "title")
					j_grant.put (create {JSON_NUMBER}.make_integer (g.item.amount), "amount")
					j_arr.add (j_grant)
				end
				j.put (j_arr, "grants")
			end
			res.send (create {WSF_PAGE_RESPONSE}.make_with_body (j.representation))
		end

end
