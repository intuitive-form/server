class
	SUBMIT_DATA
create
	make

feature {NONE} -- Initialization

	make(request: WSF_REQUEST)
		-- Constructor
		do
			if
				-- Section #1
				attached {WSF_STRING} request.form_parameter ("unit-name") as a_unit_name and then
				attached {WSF_STRING} request.form_parameter ("head-name")as a_head_name and then

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
				proceed_s1_general (request)
				proceed_s2_courses(request)
			else
				is_correct := False
			end


		end

feature -- Attributes

	is_correct: BOOLEAN
		-- True if the submitted form is correct

	s1_general: detachable TUPLE[STRING, STRING, STRING, STRING]
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


feature -- Queries

feature -- Commands

	proceed_into_tuple(request: WSF_REQUEST; param_name: STRING; tuple: TUPLE; index: INTEGER)
		require
			request_exists: request /= Void
			param_name_exists: param_name /= Void
			tuple_exists: tuple /= Void
		do
			if
				attached {WSF_STRING} request.form_parameter (param_name) as value
			then
				tuple.put(value.value.as_string_8, index)
			end
		end

	proceed_s1_general(request: WSF_REQUEST)
		-- Proceeds data from Section #1 General
		do
			create s1_general.default_create
			proceed_into_tuple (request, "unit-name", s1_general, 0)
			proceed_into_tuple (request, "head-name", s1_general, 1)
			proceed_into_tuple (request, "reporting-period-start", s1_general, 2)
			proceed_into_tuple (request, "reporting-period-end", s1_general, 3)
		end

	proceed_s2_courses(request: WSF_REQUEST)
		-- Proceeds data from Section #2 Courses
		local
			data: TUPLE[STRING, STRING, STRING, STRING]
			values: HASH_TABLE[WSF_VALUE, STRING_32]
			i: INTEGER
			ccn, cs, cl, csn: STRING
			a_ccn, a_cs, a_cl, a_csn: STRING
		do
			create s2_courses.make (2)
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
				create data.default_create
				proceed_into_tuple (request, a_ccn, data, 0)
				proceed_into_tuple (request, a_cs, data, 1)
				proceed_into_tuple (request, a_cl, data, 2)
				proceed_into_tuple (request, a_csn, data, 3)
				if attached {ARRAYED_LIST[TUPLE[STRING, STRING, STRING, STRING]]} s2_courses as a_courses then
					a_courses.put (data)
				end
				i := i + 1
				a_ccn := ccn + i.out
				a_cs := cs + i.out
				a_cl := cl + i.out
				a_csn := csn + i.out
			end
		end

invariant
	is_correct implies (
	attached s1_general and
	attached s2_courses)
end
