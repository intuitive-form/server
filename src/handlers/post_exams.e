class
	POST_EXAMS

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
			j, j_exam: JSON_OBJECT
			j_arr: JSON_ARRAY
			list: LIST[EXAM]
			date1, date2: DATE
			checker: DATE_VALIDITY_CHECKER
		do
			create j.make_empty
			if not
				(attached {WSF_STRING} req.form_parameter ("start_date") as start_date and
				attached {WSF_STRING} req.form_parameter ("end_date") as end_date)
			then
				j.put (create {JSON_STRING}.make_from_string ("no input"), "error")
			elseif not
				(checker.date_valid (start_date.value, "yyyy-[0]mm-[0]dd") and
				checker.date_valid (end_date.value, "yyyy-[0]mm-[0]dd"))
			then
				j.put (create {JSON_STRING}.make_from_string ("incorrect input"), "error")
			else
				create date1.make_from_string (start_date.value, "yyyy-[0]mm-[0]dd")
				create date2.make_from_string (end_date.value, "yyyy-[0]mm-[0]dd")
				list := db.selector.exams_between_dates (date1, date2)
				create j_arr.make (list.count)
				across list as e loop
					create j_exam.make_with_capacity (2)
					j_exam.put (create {JSON_STRING}.make_from_string (e.item.course_name), "course")
					j_exam.put (create {JSON_STRING}.make_from_string (e.item.date.formatted_out("yyyy-[0]mm-[0]dd")), "date")
					j_arr.add (j_exam)
				end
				j.put (j_arr, "exams")
			end
			res.send (create {WSF_PAGE_RESPONSE}.make_with_body (j.representation))
		end

end
