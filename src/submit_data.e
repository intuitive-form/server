class
	SUBMIT_DATA
create
	make

feature {NONE} -- Initialization

	make(input: STRING)
		-- Constructor
		local
			parser: JSON_PARSER
			sections: ARRAYED_LIST[JSON_OBJECT]
			all_fields: ARRAY[ARRAY[ARRAYED_LIST[FIELD]]]
			all_keys: ARRAY[ARRAY[FIELD]]
			name, iterator: STRING
			i: INTEGER
		do
			create parser.make_with_string (input)
			parser.parse_content
			if
				parser.is_valid and parser.is_parsed and then
				attached {JSON_OBJECT} parser.parsed_json_object as json_object
			then
				create sections.make (1)
					-- Creating a list of Sections
				from
					name := "section"
					i := 1
					iterator := name + i.out
				until
					not attached {JSON_OBJECT} json_object.item (iterator) as section or
					i = 7
				loop
					sections.sequence_put (section)
					i := i + 1
					iterator := name + i.out
				end
				create s1_general.make_from_json(sections.at (1))
				create_all_fields
					-- Initializing the fields
				all_fields := 	<<
									<<>>,
									<< 	s2_courses, s2_examinations, s2_students, s2_student_reports, s2_phd>>,
									<< 	s3_grants, s3_research_projects, s3_research_collaborations,
										s3_conference_publications, s3_research_collaborations >>,
									<<	s4_patents, s4_ip_licensing >>,
									<<	s5_paper_awards, s5_memberships, s5_prizes >>,
									<<	s6_collaborations>>
								>>
				all_keys := 	<<
									<<>>,
									<<	create {COURSE}, create {EXAM}, create {STUDENT}, create {STUDENT_REPORT},
										create {PHD_THESIS} >>,
									<<	create {GRANT}, create {RESEARCH_PROJECT}, create {RESEARCH_COLLABORATION},
										create {CONFERENCE_PUBLICATION}, create {JOURNAL_PUBLICATION} >>,
									<<	create {PATENT}, create {IP_LICENCE} >>,
									<< 	create {PAPER_AWARD}, create {MEMBERSHIP}, create {PRIZE} >>,
									<<	create {COLLABORATION} >>
								>>
				i := 1
				across sections as iter loop
					proceed_section (all_fields.at (i), all_keys.at(i), iter.item)
					i := i + 1
				end
				if
					attached {JSON_STRING} json_object.item ("section7") as json_string
				then
					s1_general.set_section7 (json_string.item)
				end
				is_correct := True
			else
				is_correct := False
			end
		end

	create_all_fields
		-- Initialize all the fields
		do
			create s2_courses.make (1)
			create s2_examinations.make (1)
			create s2_students.make (1)
			create s2_student_reports.make (1)
			create s2_phd.make (1)
			create s3_grants.make (1)
			create s3_research_projects.make (1)
			create s3_research_collaborations.make (1)
			create s3_conference_publications.make (1)
			create s3_journal_publications.make (1)
			create s4_patents.make (1)
			create s4_ip_licensing.make (1)
			create s5_paper_awards.make (1)
			create s5_memberships.make (1)
			create s5_prizes.make (1)
			create s6_collaborations.make (1)
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
		-- Section #3 Journal publications: Title / Authors

	s4_patents: detachable ARRAYED_LIST[PATENT]
		-- Section #4 Patents: Title / Country of patent

	s4_ip_licensing: detachable ARRAYED_LIST[IP_LICENCE]
		-- Section #4 IP Licensing: Title

	s5_paper_awards: detachable ARRAYED_LIST[PAPER_AWARD]
		-- Section #5 Paper Awards: Title / Authors / Awarding conference or journal /
		-- /Exact wording of award / Date

	s5_memberships: detachable ARRAYED_LIST[MEMBERSHIP]
		-- Section #5 Memberships: Name of member / Academic organization or Institution /
		-- /Date of membership

	s5_prizes: detachable ARRAYED_LIST[PRIZE]
		-- Section #5 Prizes: Recipient / Name of prize / Granting institution /
		-- /Date
	s6_collaborations: detachable ARRAYED_LIST[COLLABORATION]
		-- Section #6 Collaborations: Company / Nature of collaboration

feature {NONE} -- Proceeding features

	proceed_section(fields: ARRAY[ARRAYED_LIST[FIELD]]; keys: ARRAY[FIELD]; json_section: JSON_OBJECT)
		-- Proceeds one section
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > keys.count
			loop
				if attached {JSON_ARRAY} json_section.item (keys.at (i).key) as json_value then
					proceed_field (fields.at(i), keys.at (i), json_value)
				end
				i := i + 1
			variant
				keys.count - i + 1
			end
		end

	proceed_field(field: ARRAYED_LIST[FIELD]; key: FIELD; json_section: JSON_ARRAY)
		-- Proceeds one field
		local
			temp_array: ARRAYED_LIST[JSON_VALUE]
			new_field: like key
		do
			temp_array := json_section.array_representation
			across temp_array as iter loop
				create new_field.make_from_json(iter.item)
				if new_field.is_correct then
					field.sequence_put (new_field)
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
	attached s3_journal_publications and
	attached s4_patents and
	attached s4_ip_licensing and
	attached s5_paper_awards and
	attached s5_memberships and
	attached s5_prizes and
	attached s6_collaborations)
end
