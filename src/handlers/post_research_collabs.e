class
	POST_RESEARCH_COLLABS

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
			j, j_collab: JSON_OBJECT
			j_arr, j_contracts: JSON_ARRAY
			list: LIST[RESEARCH_COLLABORATION]
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
				list := db.selector.research_collaborations (unit.value)
				create j_arr.make (list.count)
				across list as g loop
					create j_collab.make_with_capacity (4)
					create j_contracts.make (g.item.contracts.count)
					j_collab.put (create {JSON_STRING}.make_from_string (g.item.institution_country), "institution_country")
					j_collab.put (create {JSON_STRING}.make_from_string (g.item.institution_name), "institution_name")
					j_collab.put (create {JSON_STRING}.make_from_string (g.item.nature), "nature")
					across g.item.contracts as c loop
						j_contracts.add (create {JSON_STRING}.make_from_string (c.item))
					end
					j_collab.put (j_contracts, "contracts")
					j_arr.add (j_collab)
				end
				j.put (j_arr, "research_collaborations")
			end
			res.send (create {WSF_PAGE_RESPONSE}.make_with_body (j.representation))
		end

end
