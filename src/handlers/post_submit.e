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
		do
			create j.make
			if
				not attached {WSF_STRING} req.form_parameter ("value") as json_content or else
				not attached (create {SUBMIT_DATA}.make (json_content.value.as_string_8)) as data
			then
				j.put (create {JSON_STRING}.make_from_string ("error"), "status")
				j.put (create {JSON_STRING}.make_from_string ("no input"), "error")
			elseif not data.is_correct then
				j.put (create {JSON_STRING}.make_from_string ("error"), "status")
				j.put (create {JSON_STRING}.make_from_string ("wrong format"), "error")
			elseif
				db.selector.unit_exists (data.s1_general.name)
			then
				j.put (create {JSON_STRING}.make_from_string ("error"), "status")
				j.put (create {JSON_STRING}.make_from_string ("unit exists"), "error")
			elseif
				across data.s2_courses as iter some
					db.selector.get_course_id (iter.item.name, iter.item.semester) = -1
				end
			then
				j.put (create {JSON_STRING}.make_from_string ("error"), "status")
				j.put (create {JSON_STRING}.make_from_string ("course exists"), "error")
			else
				db.insert (data)
				j.put (create {JSON_STRING}.make_from_string ("ok"), "status")
			end
			res.send (create {WSF_PAGE_RESPONSE}.make_with_body (j.representation))
		end

end
