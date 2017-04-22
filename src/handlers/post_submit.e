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
			elseif not data.is_correct or else not check_fields(data) then
				j.put (create {JSON_STRING}.make_from_string ("error"), "status")
				j.put (create {JSON_STRING}.make_from_string ("wrong format"), "error")
			elseif
				db.selector.unit_exists (data.s1_general.name)
			then
				j.put (create {JSON_STRING}.make_from_string ("error"), "status")
				j.put (create {JSON_STRING}.make_from_string ("unit exists"), "error")
			elseif
				across data.s2_courses as iter some
					db.selector.get_course_id (iter.item.name, iter.item.semester) /= -1
				end
			then
				j.put (create {JSON_STRING}.make_from_string ("error"), "status")
				j.put (create {JSON_STRING}.make_from_string ("course exists"), "error")
			elseif
				not across data.s2_examinations as iter1 all
					db.selector.get_course_id (iter1.item.course_name, iter1.item.semester) /= -1 or else
					across data.s2_courses as iter2 some
						iter1.item.course_name ~ iter2.item.name and iter1.item.semester ~ iter2.item.semester
					end
				end
			then
				j.put (create {JSON_STRING}.make_from_string ("error"), "status")
				j.put (create {JSON_STRING}.make_from_string ("exam for non-existant course"), "error")
			else
				db.insert (data)
				j.put (create {JSON_STRING}.make_from_string ("ok"), "status")
			end
			res.send (create {WSF_PAGE_RESPONSE}.make_with_body (j.representation))
		end

feature {NONE}

	check_fields (data: SUBMIT_DATA): BOOLEAN
		require
			data.is_correct
		do
			Result := data.s1_general.is_correct and then
			across data.s2_courses as iter all iter.item.is_correct end and data.s2_courses.count > 0 and then
			across data.s2_examinations as iter all iter.item.is_correct end and data.s2_examinations.count > 0 and then
			across data.s2_phd as iter all iter.item.is_correct end and then
			across data.s2_student_reports as iter all iter.item.is_correct end and then
			across data.s2_students as iter all iter.item.is_correct end and then
			across data.s3_grants as iter all iter.item.is_correct end and then
			across data.s3_research_projects as iter all iter.item.is_correct end and then
			across data.s3_research_collaborations as iter all iter.item.is_correct end and then
			across data.s3_conference_publications as iter all iter.item.is_correct end and then
			across data.s3_journal_publications as iter all iter.item.is_correct end and then
			across data.s4_patents as iter all iter.item.is_correct end and then
			across data.s4_ip_licensing as iter all iter.item.is_correct end and then
			across data.s5_paper_awards as iter all iter.item.is_correct end and then
			across data.s5_memberships as iter all iter.item.is_correct end and then
			across data.s5_prizes as iter all iter.item.is_correct end and then
			across data.s6_collaborations as iter all iter.item.is_correct end
		end

end
