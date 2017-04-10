class
	SUBMIT_DATA
create
	make

feature {NONE} -- Initialization

	make(request: WSF_REQUEST)
		-- Constructor
		local
			s1_date_start, s1_date_end: DATE
		do
			if
				-- Section #1
				attached {WSF_STRING} request.form_parameter ("unit-name") as a_unit_name and then
				attached {WSF_STRING} request.form_parameter ("head-name")as a_head_name and then
				attached {WSF_STRING} request.form_parameter ("reporting-period-start") as a_date_start and then
				attached {WSF_STRING} request.form_parameter ("reporting-period-end") as a_date_end and then

				-- Section #2
				attached {WSF_STRING} request.form_parameter ("courses-course-name-1")as a_c_c_name_1 and then
				attached {WSF_STRING} request.form_parameter ("courses-students-number-1")as a_c_s_number_1 and then

				attached {WSF_STRING} request.form_parameter ("examinations-course-name-1")as a_e_c_name_1 and then
				attached {WSF_STRING} request.form_parameter ("examinations-students-number-1")as a_e_s_number_1 and then

				attached {WSF_STRING} request.form_parameter ("students-supervised-name-1")as a_s_s_name_1 and then
				attached {WSF_STRING} request.form_parameter ("students-supervised-work-nature-1")as a_s_s_w_nature_1 and then

				attached {WSF_STRING} request.form_parameter ("completed-student-reports-name-1")as a_c_s_r_name_1 and then
				attached {WSF_STRING} request.form_parameter ("completed-student-reports-title-1")as a_c_s_r_title_1 and then

				-- Section #3
				attached {WSF_STRING} request.form_parameter ("grants-title-1")as a_g_title_1 and then
				attached {WSF_STRING} request.form_parameter ("grants-granting-agency-1")as a_g_g_agency_1 and then
				attached {WSF_STRING} request.form_parameter ("period-start-1")as a_p_start_1 and then
				attached {WSF_STRING} request.form_parameter ("period-end-1")as a_p_end_1 and then
				attached {WSF_STRING} request.form_parameter ("grants-amount-1")as a_g_amount_1 and then

				attached {WSF_STRING} request.form_parameter ("research-projects-title-1")as a_r_p_title_1 and then
				attached {WSF_STRING} request.form_parameter ("research-projects-personnel-involved-name-1-1")as a_r_p_p_i_name_1_1 and then
				attached {WSF_STRING} request.form_parameter ("research-projects-start-date-1")as a_r_p_s_date_1 and then
				attached {WSF_STRING} request.form_parameter ("research-projects-end-date-1")as a_r_p_e_date_1
			then
				is_correct := True

				create s1_date_start.make_from_string (a_date_start.value, "yyyy-[0]mm-[0]dd")
				create s1_date_end.make_from_string (a_date_end.value, "yyyy-[0]mm-[0]dd")

				s1_general := [a_unit_name.value.to_string_8, a_head_name.value.to_string_8, s1_date_start, s1_date_end]

				io.put_string ("SUBMIT_DATA: Processing coures%N")
				proceed_s2_courses (request)
				io.put_string ("SUBMIT_DATA: Processing exams%N")
				proceed_s2_examinations(request)
				io.put_string ("SUBMIT_DATA: Processing students%N")
				proceed_s2_students (request)
				io.put_string ("SUBMIT_DATA: Processing reports%N")
				proceed_s2_students_reports (request)
				io.put_string ("SUBMIT_DATA: Processing PhDs%N")
				proceed_s2_phd (request)
				io.put_string ("SUBMIT_DATA: Processing Section 3, grants%N")
				proceed_s3_grants (request)
				io.put_string ("SUBMIT_DATA: Processing research projects%N")
				proceed_s3_research_projects (request)
				io.put_string ("SUBMIT_DATA: Processing research collabs%N")
				proceed_s3_research_collaborations (request)
				io.put_string ("SUBMIT_DATA: Processing conf pubs%N")
				proceed_s3_conference_publications (request)
				io.put_string ("SUBMIT_DATA: Processing journal pubs%N")
				proceed_s3_journal_publications (request)
			else
				is_correct := False
			end


		end

feature -- Attributes

	is_correct: BOOLEAN
		-- True if the submitted form is correct

	s1_general: detachable TUPLE[STRING_8, STRING_8, DATE, DATE]
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

	s3_conference_publications: detachable ARRAYED_LIST [PUBLICATION]
		-- Section #3 Conference publicaitions: Title / Authors

	s3_journal_publications: detachable ARRAYED_LIST[PUBLICATION]
		-- Section #2 Journal publications: Title / Authors

feature {NONE} -- Proceeding features

	proceed_s2_courses(request: WSF_REQUEST)
		-- Proceeds data from Section #2 Courses
		local
			i: INTEGER
			ccn, cs, cl, csn: STRING
			a_ccn, a_cs, a_cl, a_csn: STRING
		do
			create s2_courses.make (1)
			ccn := "courses-course-name-"
			cs := "courses-semester-"
			cl := "courses-level-"
			csn := "courses-students-number-"
			from
				i := 1
				a_ccn := ccn + i.out
				a_cs := cs + i.out
				a_cl := cl + i.out
				a_csn := csn + i.out
			until
				not attached {WSF_STRING} request.form_parameter(a_ccn)
			loop
				if
					attached {WSF_STRING} request.form_parameter(a_ccn) as value_1 and then
					attached {WSF_STRING} request.form_parameter(a_cs) as value_2 and then
					attached {WSF_STRING} request.form_parameter(a_cl) as value_3 and then
					attached {WSF_STRING} request.form_parameter(a_csn) as value_4
				then
					s2_courses.sequence_put (create {COURSE}.make(value_1.value.as_string_8, value_2.value.as_string_8,
							value_3.value.as_string_8, value_4.value.as_string_8))
				end
				i := i + 1
				a_ccn := ccn + i.out
				a_cs := cs + i.out
				a_cl := cl + i.out
				a_csn := csn + i.out
			end
		end

	proceed_s2_examinations(request: WSF_REQUEST)
		-- Proceeds data from Section #2 Examinations
		local
			i: INTEGER
			ecn, es, eek, esn: STRING
			a_ecn, a_es, a_eek, a_esn: STRING
		do
			create s2_examinations.make (1)
			ecn := "examinations-course-name-"
			es := "examinations-semester-"
			eek := "examinations-exam-kind-"
			esn := "examinations-students-number-"
			from
				i := 1
				a_ecn := ecn + i.out
				a_es := es + i.out
				a_eek := eek + i.out
				a_esn := esn + i.out
			until
				not attached {WSF_STRING} request.form_parameter (a_ecn)
			loop
				if
					attached {WSF_STRING} request.form_parameter (a_ecn) as value_1 and then
					attached {WSF_STRING} request.form_parameter (a_es) as value_2 and then
					attached {WSF_STRING} request.form_parameter (a_eek) as value_3 and then
					attached {WSF_STRING} request.form_parameter (a_esn) as value_4
				then
					s2_examinations.sequence_put (create {EXAM}.make (value_1.value.as_string_8, value_2.value.as_string_8,
						value_3.value.as_string_8, value_4.value.as_string_8))
				end
				i :=  i + 1
				a_ecn := ecn + i.out
				a_es := es + i.out
				a_eek := eek + i.out
				a_esn := esn + i.out
			end
		end

	proceed_s2_students(request: WSF_REQUEST)
		-- Proceeds data from Section #2 Students
		local
			i: INTEGER
			ssn, sswn: STRING
			a_ssn, a_sswn: STRING
		do
			create s2_students.make (1)
			ssn := "students-supervised-name-"
			sswn := "students-supervised-work-nature-"
			from
				i := 1
				a_ssn := ssn + i.out
				a_sswn := sswn + i.out
			until
				not attached {WSF_STRING} request.form_parameter (a_ssn)
			loop
				if
					attached {WSF_STRING} request.form_parameter (a_ssn) as value_1 and then
					attached {WSF_STRING} request.form_parameter (a_sswn) as value_2
				then
					s2_students.sequence_put (create {STUDENT}.make (value_1.value.as_string_8, value_2.value.as_string_8))
				end
				i := i + 1
				a_ssn := ssn + i.out
				a_sswn := sswn + i.out
			end
		end

	proceed_s2_students_reports(request: WSF_REQUEST)
		-- Proceeds data from Section #2 Student reports
		local
			i: INTEGER
			csrn, csrt, csrpp: STRING
			a_csrn, a_csrt, a_csrpp: STRING
		do
			create s2_student_reports.make(1)
			csrn := "completed-student-reports-name-"
			csrt := "completed-student-reports-title-"
			csrpp := "completed-student-reports-publication-plans-"
			from
				i := 1
				a_csrn := csrn + i.out
				a_csrt := csrt + i.out
				a_csrpp := csrpp + i.out
			until
				not attached {WSF_STRING} request.form_parameter (a_csrn)
			loop
				if
					attached {WSF_STRING} request.form_parameter (a_csrn) as value_1 and then
					attached {WSF_STRING} request.form_parameter (a_csrt) as value_2
				then
					if
						attached {WSF_STRING} request.form_parameter (a_csrpp) as value_3
					then
						s2_student_reports.sequence_put (create {STUDENT_REPORT}.make (value_1.value.as_string_8,
							value_2.value.as_string_8, value_3.value.as_string_8))
					else
						s2_student_reports.sequence_put (create {STUDENT_REPORT}.make (value_1.value.as_string_8,
							value_2.value.as_string_8, ""))
					end
				end
				i := i + 1
				a_csrn := csrn + i.out
				a_csrt := csrt + i.out
				a_csrpp := csrpp + i.out
			end
		end

	proceed_s2_phd(request: WSF_REQUEST)
		-- Proceeds data from Section #2 Phd theses
		local
			i: INTEGER
			cptn, cptt, cptpp: STRING
			a_cptn, a_cptt, a_cptpp: STRING
		do
			create s2_phd.make (1)
			cptn := "completed-PhD-theses-name-"
			cptt := "completed-PhD-theses-title-"
			cptpp := "completed-PhD-theses-publication-plans-"
			from
				i := 1
				a_cptn := cptn + i.out
				a_cptt := cptt + i.out
				a_cptpp := cptpp + i.out
			until
				not (attached {WSF_STRING} request.form_parameter (a_cptn) or
				attached {WSF_STRING} request.form_parameter (a_cptt) or
				attached {WSF_STRING} request.form_parameter (a_cptpp))
			loop
				if
					attached {WSF_STRING} request.form_parameter (a_cptn) as value_1
				then
					if
						attached {WSF_STRING} request.form_parameter (a_cptt) as value_2
					then
						if
							attached {WSF_STRING} request.form_parameter (a_cptpp) as value_3
						then
							s2_phd.sequence_put (create {PHD_THESIS}.make (value_1.value.as_string_8,
								value_2.value.as_string_8, value_3.value.as_string_8))
						else
							s2_phd.sequence_put (create {PHD_THESIS}.make (value_1.value.as_string_8,
														value_2.value.as_string_8, ""))
						end
					else
						if
							attached {WSF_STRING} request.form_parameter (a_cptpp) as value_3
						then
							s2_phd.sequence_put (create {PHD_THESIS}.make (value_1.value.as_string_8,
								"", value_3.value.as_string_8))
						else
							s2_phd.sequence_put (create {PHD_THESIS}.make (value_1.value.as_string_8,
														"", ""))
						end
					end
				else
					if
						attached {WSF_STRING} request.form_parameter (a_cptt) as value_2
					then
						if
							attached {WSF_STRING} request.form_parameter (a_cptpp) as value_3
						then
							s2_phd.sequence_put (create {PHD_THESIS}.make ("",
								value_2.value.as_string_8, value_3.value.as_string_8))
						else
							s2_phd.sequence_put (create {PHD_THESIS}.make ("",
														value_2.value.as_string_8, ""))
						end
					else
						if
							attached {WSF_STRING} request.form_parameter (a_cptpp) as value_3
						then
							s2_phd.sequence_put (create {PHD_THESIS}.make ("",
								"", value_3.value.as_string_8))
						end
					end
				end
				i := i + 1
				a_cptn := cptn + i.out
				a_cptt := cptt + i.out
				a_cptpp := cptpp + i.out
			end
		end


	proceed_s3_grants(request: WSF_REQUEST)
		-- Proceeds data from Section #3 Grants
		local
			i: INTEGER
			gt, gga, ps, pe, gc, ga: STRING
			a_gt, a_gga, a_ps, a_pe, a_gc, a_ga: STRING
		do
			create s3_grants.make(1)
			gt := "grants-title-"
			gga := "grants-granting-agency-"
			ps := "period-start-"
			pe := "period-end-"
			gc := "grants-continuation-"
			ga := "grants-amount-"
			from
				i := 1
				a_gt := gt + i.out
				a_gga := gga + i.out
				a_ps := ps + i.out
				a_pe := pe + i.out
				a_gc := gc + i.out
				a_ga := ga + i.out
			until
				not attached {WSF_STRING} request.form_parameter (a_gt)
			loop
				if
					attached {WSF_STRING} request.form_parameter (a_gt) as value_1 and then
					attached {WSF_STRING} request.form_parameter (a_gga) as value_2 and then
					attached {WSF_STRING} request.form_parameter (a_ps) as value_3 and then
					attached {WSF_STRING} request.form_parameter (a_pe) as value_4 and then
					attached {WSF_STRING} request.form_parameter (a_ga) as value_6
				then
					if
						attached {WSF_STRING} request.form_parameter (a_gc) as value_5
					then
						s3_grants.sequence_put (create {GRANT}.make (value_1.value.as_string_8,
							value_2.value.as_string_8, value_3.value.as_string_8, value_4.value.as_string_8,
								value_5.value.as_string_8, value_6.value.as_string_8))
					else
						s3_grants.sequence_put (create {GRANT}.make (value_1.value.as_string_8,
							value_2.value.as_string_8, value_3.value.as_string_8, value_4.value.as_string_8,
								"", value_6.value.as_string_8))
					end
				end
				i := i + 1
				a_gt := gt + i.out
				a_gga := gga + i.out
				a_ps := ps + i.out
				a_pe := pe + i.out
				a_gc := gc + i.out
				a_ga := ga + i.out
			end
		end

	proceed_s3_research_projects(request: WSF_REQUEST)
		-- Proceeds data from Section #3 Researh Projects
		local
			data_1: ARRAYED_LIST[STRING]
			data_2: ARRAYED_LIST[STRING]
			i, j: INTEGER
			rpt, rppin, rpepin, rpsd, rped, rpfs: STRING
			a_rpt, a_rppin, b_rppin, a_rpepin, b_rpepin, a_rpsd, a_rped, a_rpfs: STRING
		do
			create s3_research_projects.make(1)
			rpt := "research-projects-title-"
			rppin := "research-projects-personnel-involved-name-"
			rpepin := "research-projects-extra-personnel-involved-name-"
			rpsd := "research-projects-start-date-"
			rped := "research-projects-end-date-"
			rpfs := "research-projects-financing-sources-"
			from
				i := 1
				a_rpt := rpt + i.out
				a_rppin := rppin + i.out + "-"
				a_rpepin := rpepin + i.out + "-"
				a_rpsd := rpsd + i.out
				a_rped := rped + i.out
				a_rpfs := rpfs + i.out
			until
				not attached {WSF_STRING} request.form_parameter (a_rpt)
			loop
				create data_1.make (1)
				create data_2.make (1)

				from
					j := 1
					b_rppin := a_rppin + j.out
				until
					not attached {WSF_STRING} request.form_parameter (b_rppin) as value
				loop
					io.new_line
					data_1.sequence_put (value.value.as_string_8)
					j := j + 1
					b_rppin := a_rppin + j.out
				end

				from
					j := 1
					b_rpepin := a_rpepin + j.out
				until
					not attached {WSF_STRING} request.form_parameter (b_rpepin) as value
				loop
					data_2.sequence_put (value.value.as_string_8)
					j := j + 1
					b_rpepin := a_rpepin + j.out
				end

				if
					attached {WSF_STRING} request.form_parameter (a_rpt) as value_1 and then
					attached {WSF_STRING} request.form_parameter (a_rpsd) as value_2 and then
					attached {WSF_STRING} request.form_parameter (a_rped) as value_3 and then
					attached {WSF_STRING} request.form_parameter (a_rpfs) as value_4
				then
					s3_research_projects.sequence_put (create {RESEARCH_PROJECT}.make (value_1.value.as_string_8,
						value_2.value.as_string_8, value_3.value.as_string_8, value_4.value.as_string_8,
							data_1, data_2))
				end
				i := i + 1
				a_rpt := rpt + i.out
				a_rppin := rppin + i.out + "-"
				a_rpepin := rpepin + i.out + "-"
				a_rpsd := rpsd + i.out
				a_rped := rped + i.out
				a_rpfs := rpfs + i.out
			end
		end

	proceed_s3_research_collaborations(request: WSF_REQUEST)
		-- Proceed data from Section #3 Research Collaborations
		local
			data_1: ARRAYED_LIST[STRING]
			i, j: INTEGER
			rcc, rcn, rccn, rcna: STRING
			a_rcc, a_rcn, a_rccn, b_rccn, a_rcna: STRING
		do
			create s3_research_collaborations.make (1)
			rcc := "research-collaboration-country-"
			rcn := "research-collaboration-name-"
			rccn := "research-collaboration-contracts-name-"
			rcna := "research-collaboration-nature-"
			from
				i := 1
				a_rcc := rcc + i.out
				a_rcn := rcn + i.out
				a_rccn := rccn + i.out + "-"
				a_rcna := rcna + i.out
			until
				not (attached {WSF_STRING} request.form_parameter (a_rcc) or
					attached {WSF_STRING} request.form_parameter (a_rcn) or
					attached {WSF_STRING} request.form_parameter (a_rccn))
			loop
				create data_1.make (1)
				from
					j := 1
					b_rccn := a_rccn + j.out
				until
					not attached {WSF_STRING} request.form_parameter (b_rccn) as value
				loop
					data_1.sequence_put (value.value.as_string_8)
					j := j + 1
					b_rccn := a_rccn + j.out
				end
				if
					data_1.count = 0
				then
					data_1.sequence_put ("")
				end
				if
					attached {WSF_STRING} request.form_parameter (a_rcc) as value_1
				then
					if
						attached {WSF_STRING} request.form_parameter (a_rcn) as value_2
					then
						if
							attached {WSF_STRING} request.form_parameter (a_rccn) as value_3
						then
							s3_research_collaborations.sequence_put (create {RESEARCH_COLLABORATION}.make (value_1.value.as_string_8,
								 value_2.value.as_string_8, value_3.value.as_string_8, data_1))
						else
							s3_research_collaborations.sequence_put (create {RESEARCH_COLLABORATION}.make (value_1.value.as_string_8,
								 value_2.value.as_string_8, "", data_1))
						end
					else
						if
							attached {WSF_STRING} request.form_parameter (a_rccn) as value_3
						then
							s3_research_collaborations.sequence_put (create {RESEARCH_COLLABORATION}.make (value_1.value.as_string_8,
								 "", value_3.value.as_string_8, data_1))
						else
							s3_research_collaborations.sequence_put (create {RESEARCH_COLLABORATION}.make (value_1.value.as_string_8,
								 "", "", data_1))
						end
					end
				else
					if
						attached {WSF_STRING} request.form_parameter (a_rcn) as value_2
					then
						if
							attached {WSF_STRING} request.form_parameter (a_rccn) as value_3
						then
							s3_research_collaborations.sequence_put (create {RESEARCH_COLLABORATION}.make ("",
								 value_2.value.as_string_8, value_3.value.as_string_8, data_1))
						else
							s3_research_collaborations.sequence_put (create {RESEARCH_COLLABORATION}.make ("",
								 value_2.value.as_string_8, "", data_1))
						end
					else
						if
							attached {WSF_STRING} request.form_parameter (a_rccn) as value_3
						then
							s3_research_collaborations.sequence_put (create {RESEARCH_COLLABORATION}.make ("",
								 "", value_3.value.as_string_8, data_1))
						end
					end
				end
				i := i + 1
				a_rcc := rcc + i.out
				a_rcn := rcn + i.out
				a_rccn := rccn + i.out + "-"
				a_rcna := rcna + i.out
			end
			if
				s3_research_collaborations.count = 0
			then
				create data_1.make (1)
				from
					j := 1
					b_rccn := a_rccn + j.out
				until
					not attached {WSF_STRING} request.form_parameter (b_rccn) as value
				loop
					data_1.sequence_put (value.value.as_string_8)
					j := j + 1
					b_rccn := a_rccn + j.out
				end
				if
					data_1.count = 0
				then
					data_1.sequence_put ("")
				end
				s3_research_collaborations.sequence_put (create {RESEARCH_COLLABORATION}.make (
					"", "", "", data_1))
			end
		end

	proceed_s3_conference_publications(request: WSF_REQUEST)
		-- Proceeds data from Section #3 Conference puplications
		local
			data_1: ARRAYED_LIST[STRING]
			i, j: INTEGER
			cpt, cpa: STRING
			a_cpt, a_cpa, b_cpa: STRING
		do
			create s3_conference_publications.make (1)
			cpt := "conference-publications-title-"
			cpa := "conference-publications-author-"
			from
				i := 1
				a_cpt := cpt + i.out
				a_cpa := cpa + i.out + "-"
			until
				not attached {WSF_STRING} request.form_parameter(a_cpt) as value_1
			loop
				create data_1.make (1)
				from
					j := 1
					b_cpa := a_cpa + j.out
				until
					not attached {WSF_STRING} request.form_parameter(b_cpa) as value
				loop
					data_1.sequence_put (value.value.as_string_8)
					j := j + 1
					b_cpa := a_cpa + j.out
				end
				if
					data_1.count = 0
				then
					data_1.sequence_put ("")
				end
				s3_conference_publications.sequence_put (create {PUBLICATION}.make (value_1.value.as_string_8,
					 data_1))
				i := i + 1
				a_cpt := cpt + i.out
				a_cpa := cpa + i.out + "-"
			end
			if
				s3_conference_publications.count = 0
			then
				from
					j := 1
					b_cpa := a_cpa + j.out
				until
					not attached {WSF_STRING} request.form_parameter(b_cpa) as value
				loop
					data_1.sequence_put (value.value.as_string_8)
					j := j + 1
					b_cpa := a_cpa + j.out
				end
				if
					data_1.count = 0
				then
					data_1.sequence_put ("")
				end
				s3_conference_publications.sequence_put (create {PUBLICATION}.make ("", data_1))
			end
		end

	proceed_s3_journal_publications(request: WSF_REQUEST)
		-- Proceeds data from Section #3 Journal puplications
		local
			data_1: ARRAYED_LIST[STRING]
			i, j: INTEGER
			cpt, cpa: STRING
			a_cpt, a_cpa, b_cpa: STRING
		do
			create s3_journal_publications.make (1)
			cpt := "journal-publications-title-"
			cpa := "journal-publications-author-1-"
			from
				i := 1
				a_cpt := cpt + i.out
				a_cpa := cpa + i.out + "-"
			until
				not attached {WSF_STRING} request.form_parameter(a_cpt) as value_1
			loop
				create data_1.make (1)
				from
					j := 1
					b_cpa := a_cpa + j.out
				until
					not attached {WSF_STRING} request.form_parameter(b_cpa) as value
				loop
					data_1.sequence_put (value.value.as_string_8)
					j := j + 1
					b_cpa := a_cpa + j.out
				end
				if
					data_1.count = 0
				then
					data_1.sequence_put ("")
				end
				s3_conference_publications.sequence_put (create {PUBLICATION}.make (value_1.value.as_string_8,
					 data_1))
				i := i + 1
				a_cpt := cpt + i.out
				a_cpa := cpa + i.out + "-"
			end
			if
				s3_conference_publications.count = 0
			then
				from
					j := 1
					b_cpa := a_cpa + j.out
				until
					not attached {WSF_STRING} request.form_parameter(b_cpa) as value
				loop
					data_1.sequence_put (value.value.as_string_8)
					j := j + 1
					b_cpa := a_cpa + j.out
				end
				if
					data_1.count = 0
				then
					data_1.sequence_put ("")
				end
				s3_conference_publications.sequence_put (create {PUBLICATION}.make ("", data_1))
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
