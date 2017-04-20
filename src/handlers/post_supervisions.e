class
	POST_SUPERVISIONS

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
			j, j_student: JSON_OBJECT
			j_arr: JSON_ARRAY
			list: LIST[STUDENT]
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
				list := db.selector.supervised_students (unit.value)
				create j_arr.make (list.count)
				across list as g loop
					create j_student.make_with_capacity (2)
					j_student.put (create {JSON_STRING}.make_from_string (g.item.name), "name")
					j_student.put (create {JSON_STRING}.make_from_string (g.item.nature_of_work), "nature_of_work")
					j_arr.add (j_student)
				end
				j.put (j_arr, "supervised_students")
			end
			res.send (create {WSF_PAGE_RESPONSE}.make_with_body (j.representation))
		end

end
