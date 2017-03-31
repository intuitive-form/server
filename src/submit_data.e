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

			else
				is_correct := False
			end


		end

feature -- Attributes

	is_correct: BOOLEAN
		-- True if the submitted form is correct

	unit_name: STRING
		-- Name of the unit

	head_name: STRING
		-- Head of the unit

	reporting_period_start: STRING
		-- Start date

	reporting_period_end: STRING
		-- End date

	course_names: ARRAY[STRING]
		-- All names of the courses

	couses_semesters: ARRAY[STRING]
		-- All selected semesters for the courses

	courses_level: ARRAY[STRING]
		-- All selected levels for the couses

	courses_students_number: ARRAY[STRING]
		-- Number of students on the course

	examinations_course_name: ARRAY[STRING]
		-- Name of the course
		-- TODO

feature -- Commands

end
