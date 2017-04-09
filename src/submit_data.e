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

				proceed_s2_courses (request)
				proceed_s2_examinations(request)
				proceed_s2_students (request)
				proceed_s2_students_reports (request)
				proceed_s2_phd (request)
				proceed_s3_grants (request)
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

	s2_courses: detachable ARRAYED_LIST[TUPLE[STRING, STRING, STRING, STRING]]
		-- Section #2 Courses: Course Name / Semester / Level / Number of students

	s2_examinations: detachable ARRAYED_LIST[TUPLE[STRING, STRING, STRING, STRING]]
		-- Section #2 Examinations: Course Name / Semester / Kind of exam / Number of students

	s2_students: detachable ARRAYED_LIST[TUPLE[STRING, STRING]]
		-- Section #2 Students: Name / Nature of work

	s2_student_reports: detachable ARRAYED_LIST[TUPLE[STRING, STRING, STRING]]
		-- Section #2 Stundent reports: Student Name / Title / Publication plans

	s2_phd: detachable ARRAYED_LIST[TUPLE[STRING, STRING, STRING]]
		-- Section #2 PhD theses: Student Name / Title / Publication plans

	s3_grants: detachable ARRAYED_LIST[TUPLE[STRING, STRING, STRING, STRING, STRING, STRING]]
		-- Section #3 Grants: Title / Granting agency / Period start / Period end /
		-- /Continuation of other grant / Amount

	s3_researh_projects: detachable ARRAYED_LIST[TUPLE[STRING, ARRAYED_LIST[STRING], ARRAYED_LIST[STRING], STRING, STRING, STRING]]
		-- Section #3 Research Collaborations: Title / Personnel involved / Extra personnel involved /
		-- /Date of start / Expected Date of end / Sources of financing

feature -- Queries

feature {NONE} -- Commands

	proceed_into_tuple(request: WSF_REQUEST; param_name: STRING; tuple: TUPLE; index: INTEGER)
		-- Proceeds form parameter with 'param_name' from 'request' into 'tuple' with 'index'
		require
			request_exists: request /= Void
			param_name_exists: param_name /= Void
			tuple_exists: tuple /= Void
		do
			if
				attached {WSF_STRING} request.form_parameter (param_name) as value
			then
				if
					attached {TUPLE[STRING, ARRAYED_LIST[STRING], ARRAYED_LIST[STRING], STRING, STRING, STRING]} tuple as t
				then
					t.put (value.value.as_string_8, index)
				elseif
					attached {TUPLE[STRING, STRING, STRING, STRING, STRING, STRING]} tuple as t
				then
					t.put(value.value.as_string_8, index)
				elseif
					attached {TUPLE[STRING, STRING, STRING, STRING]} tuple as t
				then
					t.put(value.value.as_string_8, index)
				elseif
					attached {TUPLE[STRING, STRING, STRING]} tuple as t
				then
					t.put (value.value.as_string_8, index)
				elseif
					attached {TUPLE[STRING, STRING]} tuple as t
				then
					t.put (value.value.as_string_8, index)
				end
			end

		end

	proceed_s2_courses(request: WSF_REQUEST)
		-- Proceeds data from Section #2 Courses
		local
			data: TUPLE[STRING, STRING, STRING, STRING]
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
				attached {WSF_STRING} request.form_parameter(a_ccn)
			loop
				data := ["", "", "", ""]
				proceed_into_tuple (request, a_ccn, data, 1)
				proceed_into_tuple (request, a_cs, data, 2)
				proceed_into_tuple (request, a_cl, data, 3)
				proceed_into_tuple (request, a_csn, data, 4)
				if attached {ARRAYED_LIST[TUPLE[STRING, STRING, STRING, STRING]]} s2_courses as a_courses then
					a_courses.sequence_put (data)
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
			data: TUPLE[STRING, STRING, STRING, STRING]
			ecn, es, eek, esn: STRING
			a_ecn, a_es, a_eek, a_esn: STRING
			i: INTEGER
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
				data := ["", "", "", ""]
				proceed_into_tuple (request, a_ecn, data, 1)
				proceed_into_tuple (request, a_es, data, 2)
				proceed_into_tuple (request, a_eek, data, 3)
				proceed_into_tuple (request, a_esn, data, 4)
				if attached {ARRAYED_LIST[TUPLE[STRING, STRING, STRING, STRING]]} s2_examinations as a_examinations then
					a_examinations.sequence_put (data)
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
			data: TUPLE[STRING, STRING]
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
				data := ["", ""]
				proceed_into_tuple (request, a_ssn, data, 1)
				proceed_into_tuple (request, a_ssn, data, 2)
				if
					attached {ARRAYED_LIST[TUPLE[STRING, STRING]]} s2_students as a_students
				then
					a_students.sequence_put (data)
				end
				i := i + 1
				a_ssn := ssn + i.out
				a_sswn := sswn + i.out
			end
		end

	proceed_s2_students_reports(request: WSF_REQUEST)
		-- Proceeds data from Section #2 Student reports
		local
			data: TUPLE[STRING, STRING, STRING]
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
				data := ["", "", ""]
				proceed_into_tuple(request, a_csrn, data, 1)
				proceed_into_tuple(request, a_csrt, data, 2)
				proceed_into_tuple(request, a_csrpp, data, 3)
				if
					attached {ARRAYED_LIST[TUPLE[STRING, STRING, STRING]]} s2_student_reports as a_student_reports
				then
					a_student_reports.sequence_put (data)
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
			data: TUPLE[STRING, STRING, STRING]
			i: INTEGER
			cptn, cptt, cptpp: STRING
			a_cptn, a_cptt, a_cptpp: STRING
			flag: BOOLEAN
		do
			create s2_phd.make (1)
			cptn := "completed-PhD-theses-name-"
			cptt := "completed-PhD-theses-title-"
			cptpp := "completed-PhD-theses-publication-plans-"
			flag := True
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
				data := ["", "", ""]
				proceed_into_tuple(request, a_cptn, data, 1)
				proceed_into_tuple(request, a_cptt, data, 2)
				proceed_into_tuple(request, a_cptpp, data, 3)
				if
					attached {ARRAYED_LIST[TUPLE[STRING, STRING, STRING]]} s2_phd as a_phd
				then
					a_phd.sequence_put (data)
				end
				flag := False
				i := i + 1
				a_cptn := cptn + i.out
				a_cptt := cptt + i.out
				a_cptpp := cptpp + i.out
			end
			if
				flag
			then
				if
					attached {ARRAYED_LIST[TUPLE[STRING, STRING, STRING]]} s2_phd as a_phd
				then
					data := ["", "", ""]
					a_phd.sequence_put (data)
				end
			end
		end

	proceed_s3_grants(request: WSF_REQUEST)
		-- Proceeds data from Section #3 Grants
		local
			data: TUPLE[STRING, STRING, STRING, STRING, STRING, STRING]
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
				data := ["", "", "", "", "", ""]
				proceed_into_tuple(request, a_gt, data, 1)
				proceed_into_tuple(request, a_gga, data, 2)
				proceed_into_tuple(request, a_ps, data, 3)
				proceed_into_tuple(request, a_pe, data, 4)
				proceed_into_tuple(request, a_gc, data, 5)
				proceed_into_tuple(request, a_ga, data, 6)
				if
					attached {ARRAYED_LIST[TUPLE[STRING, STRING, STRING, STRING, STRING, STRING]]} s3_grants as a_grants
				then
					a_grants.sequence_put (data)
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

	proceed_s3_researh_projects(request: WSF_REQUEST)
		-- Proceeds data from Section #3 Researh Projects
		local
			data_1: ARRAYED_LIST[STRING]
			data_2: ARRAYED_LIST[STRING]
			data: TUPLE[STRING, ARRAYED_LIST[STRING], ARRAYED_LIST[STRING], STRING, STRING, STRING]
			i, j: INTEGER
			rpt, rppin, rpepin, rpsd, rped, rpfs: STRING
			a_rpt, a_rppin, b_rppin, a_rpepin, b_rpepin, a_rpsd, a_rped, a_rpfs: STRING
		do
			create s3_researh_projects.make(1)
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
					b_rppin := a_rppin + i.out
				until
					not attached {WSF_STRING} request.form_parameter (b_rppin) as value
				loop
					data_1.sequence_put (value.value.as_string_8)
					j := j + 1
					b_rppin := a_rppin + i.out
				end
				from
					j := 1
					b_rpepin := a_rpepin + i.out
				until
					not attached {WSF_STRING} request.form_parameter (b_rpepin) as value
				loop
					data_2.sequence_put (value.value.as_string_8)
					j := j + 1
					b_rpepin := a_rpepin + i.out
				end
				if
				    data_2.count = 0
				then
					data_2.sequence_put ("")
				end
				data := ["", data_1, data_2, "", "", ""]
				proceed_into_tuple (request, a_rpt, data, 1)
				proceed_into_tuple (request, a_rpsd, data, 4)
				proceed_into_tuple (request, a_rped, data, 5)
				proceed_into_tuple (request, a_rpfs, data, 6)
				if
					attached {ARRAYED_LIST[TUPLE[STRING, ARRAYED_LIST[STRING], ARRAYED_LIST[STRING], STRING, STRING, STRING]]} s3_researh_projects as a_research_projects
 				then
					a_research_projects.sequence_put (data)
				end
				i := 1
				a_rpt := rpt + i.out
				a_rppin := rppin + i.out + "-"
				a_rpepin := rpepin + i.out + "-"
				a_rpsd := rpsd + i.out
				a_rped := rped + i.out
				a_rpfs := rpfs + i.out
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
	attached s3_grants)
end
