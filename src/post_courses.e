class
	POST_COURSES

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
			j, j_obj: JSON_OBJECT
			j_arr: JSON_ARRAY
			list: LIST[COURSE]
			d1, d2: DATE
			checker: DATE_VALIDITY_CHECKER
		do
			create j.make_empty
			if not
				(attached {WSF_STRING} req.form_parameter ("unit") as unit and
				attached {WSF_STRING} req.form_parameter ("period_start") as date1 and
				attached {WSF_STRING} req.form_parameter ("period_end") as date2)
			then
				j.put (create {JSON_STRING}.make_from_string ("unsufficient inputs"), "error")
			elseif not db.unit_exists (unit.value) then
				j.put (create {JSON_STRING}.make_from_string ("no such unit"), "error")
			elseif not
				(checker.date_valid (date1.value, "yyyy-[0]mm-[0]dd") and
				checker.date_valid (date2.value, "yyyy-[0]mm-[0]dd"))
			then
				j.put (create {JSON_STRING}.make_from_string ("incorrect input format"), "error")
			else
				create d1.make_from_string (date1.value, "yyyy-[0]mm-[0]dd")
				create d2.make_from_string (date2.value, "yyyy-[0]mm-[0]dd")
				list := db.courses_of_unit_between_dates (unit.value, d1, d2)
				create j_arr.make (list.count)
				across list as course loop
					create j_obj.make
					j_obj.put (create {JSON_STRING}.make_from_string (course.item.name), "name")
					j_obj.put (create {JSON_STRING}.make_from_string (course.item.semester), "semester")
					j_obj.put (create {JSON_NUMBER}.make_integer (course.item.students), "students_number")
					j_arr.add (j_obj)
				end
				j.put (j_arr, "courses")
			end
			res.send (create {WSF_PAGE_RESPONSE}.make_with_body (j.representation))
		end

end
