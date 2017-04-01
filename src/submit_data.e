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
				attached {WSF_STRING} request.form_parameter ("unit_name") as a_unit_name and then
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
				proceed_table_courses(request)
			else
				is_correct := False
			end


		end

feature -- Attributes

	is_correct: BOOLEAN
		-- True if the submitted form is correct

	unit_name: detachable STRING
		-- Name of the unit

	head_name: detachable STRING
		-- Head of the unit

	reporting_period_start: detachable STRING
		-- Start date

	reporting_period_end: detachable STRING
		-- End date

	courses: detachable ARRAYED_LIST[TUPLE[STRING, STRING, STRING, STRING]]
		-- Courses

feature -- Queries

feature -- Commands

	proceed_table_courses(request: WSF_REQUEST)
		-- Proceeds data from courses
		local
			data: TUPLE[STRING, STRING, STRING, STRING]
			values: HASH_TABLE[WSF_VALUE, STRING_32]
			i: INTEGER
			ccn, cs, cl, csn: STRING
			a_ccn, a_cs, a_cl, a_csn: STRING
		do
			create courses.make (2)
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
				if
					attached {WSF_STRING} request.form_parameter (a_ccn) as value
				then
					data.put (value, 0)
				end
				if
					attached {WSF_STRING} request.form_parameter (a_cs) as value
				then
					data.put (value, 1)
				end
				if
					attached {WSF_STRING} request.form_parameter (a_cl) as value
				then
					data.put (value, 2)
				end
				if
					attached {WSF_STRING} request.form_parameter (a_csn) as value
				then
					data.put (value, 3)
				end
				if attached {ARRAYED_LIST[TUPLE[STRING, STRING, STRING, STRING]]} courses as a_courses then
					a_courses.put (data)
				end
				i := i + 1
				a_ccn := ccn + i.out
				a_cs := cs + i.out
				a_cl := cl + i.out
				a_csn := csn + i.out
			end
		end
end
