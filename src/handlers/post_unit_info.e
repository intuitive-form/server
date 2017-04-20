class
	POST_UNIT_INFO

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
			j_obj: JSON_OBJECT
			grants: LIST[GRANT]
		do
			create j.make_empty
			if not attached {WSF_STRING} req.form_parameter ("unit") as unit then
				j.put (create {JSON_STRING}.make_from_string ("no input"), "error")
			elseif not db.selector.unit_exists (unit.value) then
				j.put (create {JSON_STRING}.make_from_string ("no such unit"), "error")
			else
				j.put (create {JSON_STRING}.make_from_string (db.selector.head_name (unit.value)), "head")
				grants := db.selector.grants_of_unit (unit.value)
				create j_arr.make (grants.count)
				across grants as g loop
					create j_obj.make
					j_obj.put (create {JSON_STRING}.make_from_string (g.item.title), "title")
					j_obj.put (create {JSON_STRING}.make_from_string (g.item.agency), "granting_agency")
					j_obj.put (create {JSON_STRING}.make_from_string (g.item.period_start.formatted_out ("yyyy-mm-dd")), "period_start")
					j_obj.put (create {JSON_STRING}.make_from_string (g.item.period_end.formatted_out ("yyyy-mm-dd")), "period_end")
					j_obj.put (create {JSON_NUMBER}.make_integer (g.item.amount), "amount")
					j_arr.add (j_obj)
				end
				j.put (j_arr, "grants")
			end
			res.send (create {WSF_PAGE_RESPONSE}.make_with_body (j.representation))
		end

end
