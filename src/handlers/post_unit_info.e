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
			j_arr, j_arr2: JSON_ARRAY
			j_obj: JSON_OBJECT
			grants: LIST[GRANT]
			phds: LIST[PHD_THESIS]
			patents: LIST[PATENT]
			licenses: LIST[IP_LICENCE]
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
				j.put (create {JSON_STRING}.make_from_string (db.selector.head_name (unit.value)), "head")

				grants := db.selector.grants_of_unit (unit.value)
				create j_arr.make (grants.count)
				across grants as g loop
					create j_obj.make_with_capacity (5)
					j_obj.put (create {JSON_STRING}.make_from_string (g.item.title), "title")
					j_obj.put (create {JSON_STRING}.make_from_string (g.item.agency), "granting_agency")
					j_obj.put (create {JSON_STRING}.make_from_string (g.item.period_start.formatted_out ("yyyy-mm-dd")), "period_start")
					j_obj.put (create {JSON_STRING}.make_from_string (g.item.period_end.formatted_out ("yyyy-mm-dd")), "period_end")
					j_obj.put (create {JSON_NUMBER}.make_integer (g.item.amount), "amount")
					j_arr.add (j_obj)
				end
				j.put (j_arr, "grants")

				phds := db.selector.phds_of_unit (unit.value)
				create j_arr.make (phds.count)
				across phds as phd loop
					create j_obj.make_with_capacity (3)
					j_obj.put (create {JSON_STRING}.make_from_string (phd.item.title), "title")
					j_obj.put (create {JSON_STRING}.make_from_string (phd.item.student_name), "author")
					j_obj.put (create {JSON_STRING}.make_from_string (phd.item.plans), "plans")
					j_arr.add (j_obj)
				end
				j.put (j_arr, "phd_theses")

				patents := db.selector.patents_of_unit (unit.value)
				create j_arr.make (phds.count)
				across patents as iter loop
					create j_obj.make_with_capacity (2)
					j_obj.put (create {JSON_STRING}.make_from_string (iter.item.title), "title")
					j_obj.put (create {JSON_STRING}.make_from_string (iter.item.country), "country")
					j_arr.add (j_obj)
				end
				j.put (j_arr, "patents")

				licenses := db.selector.ip_licences_of_unit (unit.value)
				create j_arr.make (phds.count)
				across patents as iter loop
					j_arr.add (create {JSON_STRING}.make_from_string (iter.item.title))
				end
				j.put (j_arr, "ip_licenses")

				create j_arr.make_empty
				across db.selector.paper_awards_of_unit (unit.value) as iter loop
					j_arr.add (iter.item.to_json)
				end
				j.put (j_arr, "paper_awards")

				create j_arr.make_empty
				across db.selector.academia_members_of_unit (unit.value) as iter loop
					create j_obj.make_with_capacity (3)
					j_obj.put (create {JSON_STRING}.make_from_string (iter.item.name), "name")
					j_obj.put (create {JSON_STRING}.make_from_string (iter.item.organization), "organization")
					j_obj.put (create {JSON_STRING}.make_from_string (iter.item.date.formatted_out ("yyyy-mm-dd")), "date")
					j_arr.add (j_obj)
				end
				j.put (j_arr, "academia_memberships")
			end
			res.send (create {WSF_PAGE_RESPONSE}.make_with_body (j.representation))
		end

end
