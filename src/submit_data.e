class
	SUBMIT_DATA
create
	make

feature {NONE} -- Initialization

	make(request: WSF_REQUEST)
		-- Constructor
		local
			parser: JSON_PARSER
			sections: ARRAYED_LIST[JSON_OBJECT]
			name, iterator: STRING
			i: INTEGER
		do
			if
				attached {WSF_STRING} request.form_parameter ("value") as json_content
			then
				create parser.make_with_string (json_content.value.as_string_8)
				if
					parser.is_valid and then
					attached {JSON_OBJECT} parser.parsed_json_object as json_object
				then
					create sections.make (1)
						-- Creating a list of Sections
					from
						name := "section"
						i := 1
						iterator := name + i.out
					until
						not attached {JSON_OBJECT} json_object.item (create {JSON_STRING}.make_from_string (iterator)) as section
					loop
						sections.sequence_put (section)
						i := i + 1
						iterator := name + i.out
					end
						-- Filling the list
				end
			else
				is_correct := False
			end
		end

feature -- Attributes

	exception: BOOLEAN
		-- True if something went wrong

	is_correct: BOOLEAN
		-- True if the submitted form is correct

	s1_general: detachable UNIT
		-- Section #1 General: Name of unit / Name of head unit / Start of the reporting period /
		-- /End of the reporting period

	s2_courses: detachable ARRAYED_LIST[COURSE]
		-- Section #2 Courses: Course Name / Semester / Level / Number of students

	s2_examinations: detachable ARRAYED_LIST[EXAM]
		-- Section #2 Examinations: Course Name / Semester / Kind of exam / Number of students

	s2_students: detachable ARRAYED_LIST[STUDENT]
		-- Section #2 Students: Name / Nature of work

	s2_student_reports: detachable ARRAYED_LIST[STUDENT_REPORT]
		-- Section #2 Stundent reports: Student Name / Title / Publication plans

	s2_phd: detachable ARRAYED_LIST[PHD_THESIS]
		-- Section #2 PhD theses: Student Name / Title / Publication plans

	s3_grants: detachable ARRAYED_LIST[GRANT]
		-- Section #3 Grants: Title / Granting agency / Period start / Period end /
		-- /Continuation of other grant / Amount

	s3_research_projects: detachable ARRAYED_LIST[RESEARCH_PROJECT]
		-- Section #3 Research projects: Title / Personnel involved / Extra personnel involved /
		-- /Date of start / Expected Date of end / Sources of financing

	s3_research_collaborations: detachable ARRAYED_LIST[RESEARCH_COLLABORATION]
		-- Section #3 Research collaborations: Country of institution / Name of institution /
		-- /Contracts / Nature of collaboration

	s3_conference_publications: detachable ARRAYED_LIST[PUBLICATION]
		-- Section #3 Conference publicaitions: Title / Authors

	s3_journal_publications: detachable ARRAYED_LIST[PUBLICATION]
		-- Section #2 Journal publications: Title / Authors


feature {NONE} -- Proceeding features

	add_into_list(a_list: ARRAYED_LIST[ANY]; values: ARRAYED_LIST[STRING]; list_values: ARRAYED_LIST[ARRAYED_LIST[STRING]])
		-- Adds to 'a_list' object of some type with 'values'
		do
			if
				attached {ARRAYED_LIST[COURSE]} a_list as courses
			then
				courses.sequence_put (create {COURSE}.make (values.i_th (1), values.i_th (2), values.i_th (3),
					values.i_th (4), values.i_th (5), values.i_th (6)))
			elseif
				attached {ARRAYED_LIST[EXAM]} a_list as exams
			then
				exams.sequence_put (create {EXAM}.make (values.i_th (1), values.i_th (2), values.i_th (3),
					values.i_th (4)))
			elseif
				attached {ARRAYED_LIST[STUDENT]} a_list as students
			then
				students.sequence_put (create {STUDENT}.make (values.i_th (1), values.i_th (2)))
			elseif
				attached {ARRAYED_LIST[STUDENT_REPORT]} a_list as student_reports
			then
				student_reports.sequence_put (create {STUDENT_REPORT}.make (values.i_th (1), values.i_th (2), values.i_th (30)))
			elseif
				attached {ARRAYED_LIST[PHD_THESIS]} a_list as phd
			then
				phd.sequence_put (create {PHD_THESIS}.make (values.i_th (1), values.i_th (2), values.i_th (3)))
			elseif
				attached {ARRAYED_LIST[GRANT]} a_list as grants
			then
				grants.sequence_put (create {GRANT}.make (values.i_th (1), values.i_th (2), values.i_th (3),
					values.i_th (4), values.i_th (5), values.i_th (6)))
			elseif
				attached {ARRAYED_LIST[RESEARCH_PROJECT]} a_list as research_projects
			then
				research_projects.sequence_put (create {RESEARCH_PROJECT}.make (values.i_th (1), values.i_th (2),
					values.i_th (3), values.i_th (4), list_values.i_th (1), list_values.i_th (2)))
			elseif
				attached {ARRAYED_LIST[RESEARCH_COLLABORATION]} a_list as research_collaborations
			then
				research_collaborations.sequence_put (create {RESEARCH_COLLABORATION}.make (values.i_th (1), values.i_th (2),
					values.i_th (3), list_values.i_th (1)))
			elseif
				attached {ARRAYED_LIST[PUBLICATION]} a_list as publications
			then
				publications.sequence_put (create {PUBLICATION}.make (values.i_th (1), values.i_th (2),
					 list_values.i_th (1)))
			end
		end

	proceed_json_object(json_object: JSON_OBJECT; a_keys: ARRAY[TUPLE[STRING, BOOLEAN]]): ARRAYED_LIST[STRING]
		-- Returns values of 'a_keys' from 'json_object'
		local
			i: INTEGER
		do
			create Result.make(1)
			from
				i := 1
			until
				i > a_keys.count
			loop
				if
					attached {STRING} a_keys.at(i).at(1) as string and then
					attached {BOOLEAN} a_keys.at (i).at(2) as boolean and then
					attached {JSON_STRING} json_object.item (string) as value
				then
					if
						value.item.is_empty implies (boolean)
					then
						Result.sequence_put(value.item)
					else
						exception := True
					end

				end
				i := i + 1
			end
		end

	proceed_json_array(json_array: JSON_ARRAY; a_keys: ARRAY[TUPLE[STRING, BOOLEAN]]): ARRAYED_LIST[ARRAYED_LIST[STRING]]
		-- Returns values of 'a_keys' from every item of 'json_array'
		local
			i: INTEGER
			temp_array: ARRAYED_LIST[JSON_VALUE]
			values: ARRAYED_LIST[STRING]
		do
			create Result.make(1)
			temp_array := json_array.array_representation
			across temp_array as iter
			loop
				if
					attached {JSON_OBJECT} iter.item as json_object
				then
					Result.sequence_put(proceed_json_object (json_object, a_keys))
				end
			end
		end

invariant
	is_correct implies (
	attached s1_general and
	attached s2_courses and
	attached s2_examinations and
	attached s2_students and
	attached s2_student_reports and
	attached s2_phd and
	attached s3_grants and
	attached s3_research_projects and
	attached s3_research_collaborations and
	attached s3_conference_publications and
	attached s3_journal_publications)
end
