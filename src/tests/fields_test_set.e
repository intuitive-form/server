class
	FIELDS_TEST_SET

inherit
	EQA_TEST_SET

feature -- Sub routines

	create_json(a_keys, a_values: ARRAY[STRING]): JSON_OBJECT
		require
			fields_exist: a_keys /= Void and a_values /= Void
			same_count: a_keys.count = a_values.count
		local
			i: INTEGER
		do
			create Result.make_with_capacity (a_keys.count)
			from
				i := 1
			until
				i > a_keys.count
			loop
				Result.put (create {JSON_STRING}.make_from_string (a_values.at (i)), a_keys.at (i))
				i := i + 1
			end
		end

feature -- Test UNIT routines

	field_unit_test1
			-- Correct UNIT creation
		local
			unit: UNIT
			keys, values: ARRAY[STRING]
		do
			keys := <<"unit_name", "head_name", "reporting_period_start", "reporting_period_end">>
			values := <<"Robotics Lab", "Nikolaos Mavridis", "2016-01-01", "2016-12-31">>
			create unit.make_from_json (create_json (keys, values))
			assert ("Unit created correctly", unit.is_correct)
		end

	field_unit_test2
			-- Correct UNIT creation
		local
			unit: UNIT
			keys, values: ARRAY[STRING]
		do
			keys := <<"reporting_period_end", "unit_name", "head_name", "reporting_period_start">>
			values := <<"2016-12-31", "Robotics Lab", "Nikolaos Mavridis", "2016-01-01">>
			create unit.make_from_json (create_json (keys, values))
			assert ("Unit created correctly", unit.is_correct)
		end

	field_unit_test3
			-- Incorrect UNIT creation {INVALID_DATE}
		local
			unit: UNIT
			keys, values: ARRAY[STRING]
		do
			keys := <<"unit_name", "head_name", "reporting_period_start", "reporting_period_end">>
			values := <<"Robotics Lab", "Nikolaos Mavridis", "Yesterday", "Tomorrow">>
			create unit.make_from_json (create_json (keys, values))
			assert ("Unit created incorrectly. {INVALID_DATE}", not unit.is_correct)
		end

	field_unit_test4
			-- Incorrect UNIT creation {WRONG_DATE_PERIOD}
		local
			unit: UNIT
			keys, values: ARRAY[STRING]
		do
			keys := <<"unit_name", "head_name", "reporting_period_start", "reporting_period_end">>
			values := <<"Robotics Lab", "Nikolaos Mavridis", "2016-12-31", "2016-01-01">>
			create unit.make_from_json (create_json (keys, values))
			assert ("Unit created incorrectly. {WRONG_DATE_PERIOD}", not unit.is_correct)
		end

	field_unit_test5
			-- Incorrect UNIT creation {EMPTY_FIELD}
		local
			unit: UNIT
			keys, values: ARRAY[STRING]
		do
			keys := <<"unit_name", "head_name", "reporting_period_start", "reporting_period_end">>
			values := <<"Robotics Lab", "", "2016-01-01", "2016-12-31">>
			create unit.make_from_json (create_json (keys, values))
			assert ("Unit created incorrectly. {EMPTY_FIELD}", not unit.is_correct)
		end

	field_unit_test6
			-- Incorrect UNIT creation {NOT_PARSED}
		local
			unit: UNIT
			keys, values: ARRAY[STRING]
		do
			keys := <<"unit", "head_name", "reporting_period_start", "reporting_period_end">>
			values := <<"Robotics Lab", "Nikolaos Mavridis", "2016-01-01", "2016-12-31">>
			create unit.make_from_json (create_json (keys, values))
			assert ("Unit created incorrectly. {NOT_PARSED}", not unit.is_correct)
		end

feature -- Test COURSE routines

	field_course_test1
			-- Correct COURSE creation
		local
			course: COURSE
			keys, values: ARRAY[STRING]
		do
			keys := <<"name", "semester", "level", "students_number", "start_date", "end_date">>
			values := <<"Computer Architecture", "Fall", "Bachelor", "129",  "2016-09-01", "2016-11-20">>
			create course.make_from_json (create_json (keys, values))
			assert("Course created correctly", course.is_correct)
		end

	field_course_test2
			-- Correct COURSE creation
		local
			course: COURSE
			keys, values: ARRAY[STRING]
		do
			keys := <<"end_date", "name", "semester", "level", "students_number", "start_date">>
			values := <<"2016-11-20", "Computer Architecture", "Fall", "Bachelor", "129",  "2016-09-01">>
			create course.make_from_json (create_json (keys, values))
			assert("Course created correctly", course.is_correct)
		end

	field_course_test3
			-- Correct COURSE creation
		local
			course: COURSE
			keys, values: ARRAY[STRING]
		do
			keys := <<"name", "semester", "level", "students_number", "start_date", "end_date">>
			values := <<"Computer Architecture", "Spring", "Bachelor", "129",  "2016-09-01", "2016-11-20">>
			create course.make_from_json (create_json (keys, values))
			assert("Course created correctly", course.is_correct)
		end

	field_course_test4
			-- Correct COURSE creation
		local
			course: COURSE
			keys, values: ARRAY[STRING]
		do
			keys := <<"name", "semester", "level", "students_number", "start_date", "end_date">>
			values := <<"Computer Architecture", "Fall", "Master", "129",  "2016-09-01", "2016-11-20">>
			create course.make_from_json (create_json (keys, values))
			assert("Course created correctly", course.is_correct)
		end


	field_course_test5
			-- Incorrect COURSE creation {INVALID_SEMESTER}
		local
			course: COURSE
			keys, values: ARRAY[STRING]
		do
			keys := <<"name", "semester", "level", "students_number", "start_date", "end_date">>
			values := <<"Computer Architecture", "Summer", "Bachelor", "129",  "2016-09-01", "2016-11-20">>
			create course.make_from_json (create_json (keys, values))
			assert("Course created incorrectly. {INVALID_SEMESTER}", not course.is_correct)
		end

	field_course_test6
			-- Incorrect COURSE creation {INVALID_LEVEL}
		local
			course: COURSE
			keys, values: ARRAY[STRING]
		do
			keys := <<"name", "semester", "level", "students_number", "start_date", "end_date">>
			values := <<"Computer Architecture", "Fall", "Student", "129",  "2016-09-01", "2016-11-20">>
			create course.make_from_json (create_json (keys, values))
			assert("Course created incorrectly. {INVALID_LEVEL}", not course.is_correct)
		end

	field_course_test7
			-- Incorrect COURSE creation {INVALID_NUMBER}
		local
			course: COURSE
			keys, values: ARRAY[STRING]
		do
			keys := <<"name", "semester", "level", "students_number", "start_date", "end_date">>
			values := <<"Computer Architecture", "Fall", "Bachelor", "Number",  "2016-09-01", "2016-11-20">>
			create course.make_from_json (create_json (keys, values))
			assert("Course created incorrectly. {INVALID_NUMBER}", not course.is_correct)
		end

	field_course_test8
			-- Incorrect COURSE creation {INVALID_NEGATIVE_NUMBER}
		local
			course: COURSE
			keys, values: ARRAY[STRING]
		do
			keys := <<"name", "semester", "level", "students_number", "start_date", "end_date">>
			values := <<"Computer Architecture", "Fall", "Bachelor", "-129",  "2016-09-01", "2016-11-20">>
			create course.make_from_json (create_json (keys, values))
			assert("Course created incorrectly. {INVALID_NEGATIVE_NUMBER}", not course.is_correct)
		end

	field_course_test9
			-- Incorrect COURSE creation {INVALID_DATE}
		local
			course: COURSE
			keys, values: ARRAY[STRING]
		do
			keys := <<"name", "semester", "level", "students_number", "start_date", "end_date">>
			values := <<"Computer Architecture", "Fall", "Bachelor", "129",  "Yesterday", "Tomorrow">>
			create course.make_from_json (create_json (keys, values))
			assert("Course created incorrectly. {INVALID_DATE}", not course.is_correct)
		end

	field_course_test10
			-- Incorrect COURSE creation {WRONG_DATE_PERIOD}
		local
			course: COURSE
			keys, values: ARRAY[STRING]
		do
			keys := <<"name", "semester", "level", "students_number", "start_date", "end_date">>
			values := <<"Computer Architecture", "Fall", "Bachelor", "129",  "2016-11-20", "2016-09-01">>
			create course.make_from_json (create_json (keys, values))
			assert("Course created incorrectly. {WRONG_DATE_PERIOD}", not course.is_correct)
		end

	field_course_test11
			-- Incorrect COURSE creation {EMPTY_FIELD}
		local
			course: COURSE
			keys, values: ARRAY[STRING]
		do
			keys := <<"name", "semester", "level", "students_number", "start_date", "end_date">>
			values := <<"Computer Architecture", "Fall", "", "129",  "2016-09-01", "2016-11-20">>
			create course.make_from_json (create_json (keys, values))
			assert("Course created incorrectly. {EMPTY_FIELD}", not course.is_correct)
		end

	field_course_test12
			-- Incorrect COURSE creation {NOT_PARSED}
		local
			course: COURSE
			keys, values: ARRAY[STRING]
		do
			keys := <<"not name", "semester", "level", "students_number", "start_date", "end_date">>
			values := <<"Computer Architecture", "Fall", "Bachelor", "129",  "2016-09-01", "2016-11-20">>
			create course.make_from_json (create_json (keys, values))
			assert("Course created incorrectly. {NOT_PARSED}", not course.is_correct)
		end

feature -- Test EXAM routines

	field_exam_test1
			-- Correct EXAM creation
		local
			exam: EXAM
			keys, values: ARRAY[STRING]
		do
			keys := <<"course_name", "semester", "kind", "students_number", "date">>
			values := <<"Computer Architecture", "Fall", "Final exam", "125", "2016-11-20">>
			create exam.make_from_json (create_json (keys, values))
			assert("Exam created correctly", exam.is_correct)
		end

	field_exam_test2
			-- Correct EXAM creation
		local
			exam: EXAM
			keys, values: ARRAY[STRING]
		do
			keys := <<"date", "course_name", "semester", "kind", "students_number">>
			values := <<"2016-11-20", "Computer Architecture", "Fall", "Final exam", "125">>
			create exam.make_from_json (create_json (keys, values))
			assert("Exam created correctly", exam.is_correct)
		end

	field_exam_test3
			-- Correct EXAM creation
		local
			exam: EXAM
			keys, values: ARRAY[STRING]
		do
			keys := <<"course_name", "semester", "kind", "students_number", "date">>
			values := <<"Computer Architecture", "Spring", "Final exam", "125", "2016-11-20">>
			create exam.make_from_json (create_json (keys, values))
			assert("Exam created correctly", exam.is_correct)
		end

	field_exam_test4
			-- Correct EXAM creation
		local
			exam: EXAM
			keys, values: ARRAY[STRING]
		do
			keys := <<"course_name", "semester", "kind", "students_number", "date">>
			values := <<"Computer Architecture", "Fall", "Repetition exam", "125", "2016-11-20">>
			create exam.make_from_json (create_json (keys, values))
			assert("Exam created correctly", exam.is_correct)
		end

	field_exam_test5
			-- Correct EXAM creation
		local
			exam: EXAM
			keys, values: ARRAY[STRING]
		do
			keys := <<"course_name", "semester", "kind", "students_number", "date">>
			values := <<"Computer Architecture", "Fall", "Midterm exam", "125", "2016-11-20">>
			create exam.make_from_json (create_json (keys, values))
			assert("Exam created correctly", exam.is_correct)
		end

	field_exam_test6
			-- Incorrect EXAM creation {INVALID_SEMESTER}
		local
			exam: EXAM
			keys, values: ARRAY[STRING]
		do
			keys := <<"course_name", "semester", "kind", "students_number", "date">>
			values := <<"Computer Architecture", "Summer", "Final exam", "125", "2016-11-20">>
			create exam.make_from_json (create_json (keys, values))
			assert("Exam created incorrectly {INVALID_SEMESTER}", not exam.is_correct)
		end

	field_exam_test7
			-- Incorrect EXAM creation {INVALID_KIND}
		local
			exam: EXAM
			keys, values: ARRAY[STRING]
		do
			keys := <<"course_name", "semester", "kind", "students_number", "date">>
			values := <<"Computer Architecture", "Fall", "Not Final exam", "125", "2016-11-20">>
			create exam.make_from_json (create_json (keys, values))
			assert("Exam created incorrectly {INVALID_KIND}", not exam.is_correct)
		end

	field_exam_test8
			-- Incorrect EXAM creation {INVALID_NEGATIVE_NUMBER}
		local
			exam: EXAM
			keys, values: ARRAY[STRING]
		do
			keys := <<"course_name", "semester", "kind", "students_number", "date">>
			values := <<"Computer Architecture", "Fall", "Final exam", "-125", "2016-11-20">>
			create exam.make_from_json (create_json (keys, values))
			assert("Exam created incorrectly {INVALID_NEGATIVE_NUMBER}", not exam.is_correct)
		end

	field_exam_test9
			-- Incorrect EXAM creation {INVALID_NUMBER}
		local
			exam: EXAM
			keys, values: ARRAY[STRING]
		do
			keys := <<"course_name", "semester", "kind", "students_number", "date">>
			values := <<"Computer Architecture", "Fall", "Final exam", "Number", "2016-11-20">>
			create exam.make_from_json (create_json (keys, values))
			assert("Exam created incorrectly {INVALID_NUMBER}", not exam.is_correct)
		end

	field_exam_test10
			-- Incorrect EXAM creation {INVALID_SEMESTER}
		local
			exam: EXAM
			keys, values: ARRAY[STRING]
		do
			keys := <<"course_name", "semester", "kind", "students_number", "date">>
			values := <<"Computer Architecture", "Fall", "Final exam", "125", "Today">>
			create exam.make_from_json (create_json (keys, values))
			assert("Exam created incorrectly {INVALID_NUMBER}", not exam.is_correct)
		end

	field_exam_test11
			-- Incorrect EXAM creation {EMPTY_FIELD}
		local
			exam: EXAM
			keys, values: ARRAY[STRING]
		do
			keys := <<"course_name", "semester", "kind", "students_number", "date">>
			values := <<"Computer Architecture", "", "Final exam", "125", "2016-11-20">>
			create exam.make_from_json (create_json (keys, values))
			assert("Exam created incorrectly {EMPTY_FIELD}", not exam.is_correct)
		end

	field_exam_test12
			-- Incorrect EXAM creation {NOT_PARSED}
		local
			exam: EXAM
			keys, values: ARRAY[STRING]
		do
			keys := <<"course", "semester", "kind", "students_number", "date">>
			values := <<"Computer Architecture", "Fall", "Final exam", "125", "2016-11-20">>
			create exam.make_from_json (create_json (keys, values))
			assert("Exam created incorrectly {NOT_PARSED}", not exam.is_correct)
		end

feature -- Test STUDENT routines

	field_student_test1
			-- Correct STUDENT creation
		local
			student: STUDENT
			keys, values: ARRAY[STRING]
		do
			keys := <<"name", "nature_of_work">>
			values := <<"Ivan Ivanov", "summer internship">>
			create student.make_from_json (create_json (keys, values))
			assert("Student created correctly", student.is_correct)
		end

	field_student_test2
			-- Correct STUDENT creation
		local
			student: STUDENT
			keys, values: ARRAY[STRING]
		do
			keys := <<"nature_of_work", "name">>
			values := <<"summer internship", "Ivan Ivanov">>
			create student.make_from_json (create_json (keys, values))
			assert("Student created correctly", student.is_correct)
		end

	field_student_test3
			-- Incorrect STUDENT creation {EMPTY_FIELD}
		local
			student: STUDENT
			keys, values: ARRAY[STRING]
		do
			keys := <<"name", "nature_of_work">>
			values := <<"", "summer internship">>
			create student.make_from_json (create_json (keys, values))
			assert("Student created incorrectly. {EMPTY_FIELD}", not student.is_correct)
		end

	field_student_test4
			-- Incorrect STUDENT creation {NOT_PARSED}
		local
			student: STUDENT
			keys, values: ARRAY[STRING]
		do
			keys := <<"not name", "nature_of_work">>
			values := <<"Ivan Ivanov", "summer internship">>
			create student.make_from_json (create_json (keys, values))
			assert("Student created incorrectly. {NOT_PARSED}", not student.is_correct)
		end

feature -- Test STUDENT_REPORT creation

	field_student_report_test1
			-- Correct STUDENT_REPORT creation
		local
			student_report: STUDENT_REPORT
			keys, values: ARRAY[STRING]
		do
			keys := <<"student_name", "title", "plans">>
			values := <<"Ivan Ivanov", "A parallelized and streamlined vision front-end for tabletop robots", "Maybe">>
			create student_report.make_from_json (create_json (keys, values))
			assert("Student report created correctly", student_report.is_correct)
		end

	field_student_report_test2
			-- Correct STUDENT_REPORT creation
		local
			student_report: STUDENT_REPORT
			keys, values: ARRAY[STRING]
		do
			keys := <<"plans", "student_name", "title">>
			values := <<"Maybe", "Ivan Ivanov", "A parallelized and streamlined vision front-end for tabletop robots">>
			create student_report.make_from_json (create_json (keys, values))
			assert("Student report created correctly", student_report.is_correct)
		end

	field_student_report_test3
			-- Correct STUDENT_REPORT creation
		local
			student_report: STUDENT_REPORT
			keys, values: ARRAY[STRING]
		do
			keys := <<"student_name", "title", "plans">>
			values := <<"Ivan Ivanov", "A parallelized and streamlined vision front-end for tabletop robots", "">>
			create student_report.make_from_json (create_json (keys, values))
			assert("Student report created correctly", student_report.is_correct)
		end

	field_student_report_test4
			-- Incorrect STUDENT_REPORT creation {EMPTY_FIELD}
		local
			student_report: STUDENT_REPORT
			keys, values: ARRAY[STRING]
		do
			keys := <<"student_name", "title", "plans">>
			values := <<"", "A parallelized and streamlined vision front-end for tabletop robots", "Maybe">>
			create student_report.make_from_json (create_json (keys, values))
			assert("Student report created incorrectly. {EMPTY_FIELD}", not student_report.is_correct)
		end

	field_student_report_test5
			-- Incorrect STUDENT_REPORT creation {NOT PARSED}
		local
			student_report: STUDENT_REPORT
			keys, values: ARRAY[STRING]
		do
			keys := <<"student", "title", "plans">>
			values := <<"Ivan Ivanov", "A parallelized and streamlined vision front-end for tabletop robots", "Maybe">>
			create student_report.make_from_json (create_json (keys, values))
			assert("Student report created incorrectly. {NOT_PARSED}", not student_report.is_correct)
		end

feature -- Test PHD_THESIS routines

	field_phd_thesis_test1
			-- Correct PHD_THESIS creation
		local
			phd_thesis: PHD_THESIS
			keys, values: ARRAY[STRING]
		do
			keys := <<"student_name", "title", "plans">>
			values := <<"Ivan Ivanov", "A parallelized and streamlined vision front-end for tabletop robots", "Maybe">>
			create phd_thesis.make_from_json (create_json (keys, values))
			assert("Phd thesis created correctly", phd_thesis.is_correct)
		end

	field_phd_thesis_test2
			-- Correct PHD_THESIS creation
		local
			phd_thesis: PHD_THESIS
			keys, values: ARRAY[STRING]
		do
			keys := <<"plans", "student_name", "title">>
			values := <<"Maybe", "Ivan Ivanov", "A parallelized and streamlined vision front-end for tabletop robots">>
			create phd_thesis.make_from_json (create_json (keys, values))
			assert("Phd thesis created correctly", phd_thesis.is_correct)
		end

	field_phd_thesis_test3
			-- Correct PHD_THESIS creation
		local
			phd_thesis: PHD_THESIS
			keys, values: ARRAY[STRING]
		do
			keys := <<"student_name", "title", "plans">>
			values := <<"Ivan Ivanov", "A parallelized and streamlined vision front-end for tabletop robots", "">>
			create phd_thesis.make_from_json (create_json (keys, values))
			assert("Phd thesis created correctly", phd_thesis.is_correct)
		end

	field_phd_thesis_test4
			-- Incorrect PHD_THESIS creation {EMPTY_FIELD}
		local
			phd_thesis: PHD_THESIS
			keys, values: ARRAY[STRING]
		do
			keys := <<"student_name", "title", "plans">>
			values := <<"", "A parallelized and streamlined vision front-end for tabletop robots", "Maybe">>
			create phd_thesis.make_from_json (create_json (keys, values))
			assert("Phd thesis created incorrectly. {EMPTY_FIELD}", not phd_thesis.is_correct)
		end

	field_phd_thesis_test5
			-- Incorrect PHD_THESIS creation {NOT_PARSED}
		local
			phd_thesis: PHD_THESIS
			keys, values: ARRAY[STRING]
		do
			keys := <<"student", "title", "plans">>
			values := <<"Ivan Ivanov", "A parallelized and streamlined vision front-end for tabletop robots", "Maybe">>
			create phd_thesis.make_from_json (create_json (keys, values))
			assert("Phd thesis created incorrectly. {NOT_PARSED}", not phd_thesis.is_correct)
		end

feature -- Test GRANT routines

	field_grant_test1
			-- Correct GRANT creation
		local
			grant: GRANT
			keys, values: ARRAY[STRING]
		do
			keys := <<"title", "agency", "period_start", "period_end", "continuation", "amount">>
			values := <<"Verifying Deep Mathematical Properties of AI Systems", "USAID",
				"2016-04-02" , "2017-10-11", "1 year", "100">>
			create grant.make_from_json (create_json (keys, values))
			assert("Grant created correctly", grant.is_correct)
		end

	field_grant_test2
			-- Correct GRANT creation
		local
			grant: GRANT
			keys, values: ARRAY[STRING]
		do
			keys := <<"amount", "title", "agency", "period_start", "period_end", "continuation">>
			values := <<"100", "Verifying Deep Mathematical Properties of AI Systems", "USAID",
				"2016-04-02" , "2017-10-11", "1 year">>
			create grant.make_from_json (create_json (keys, values))
			assert("Grant created correctly", grant.is_correct)
		end

	field_grant_test3
			-- Correct GRANT creation
		local
			grant: GRANT
			keys, values: ARRAY[STRING]
		do
			keys := <<"title", "agency", "period_start", "period_end", "continuation", "amount">>
			values := <<"Verifying Deep Mathematical Properties of AI Systems", "USAID",
				"2016-04-02" , "2017-10-11", "", "100">>
			create grant.make_from_json (create_json (keys, values))
			assert("Grant created correctly", grant.is_correct)
		end

	field_grant_test4
			-- Incorrect GRANT creation {INVALID_DATE}
		local
			grant: GRANT
			keys, values: ARRAY[STRING]
		do
			keys := <<"title", "agency", "period_start", "period_end", "continuation", "amount">>
			values := <<"Verifying Deep Mathematical Properties of AI Systems", "USAID",
				"Yesterday" , "Tomorrow", "1 year", "100">>
			create grant.make_from_json (create_json (keys, values))
			assert("Grant created incorrectly. {INVALID_DATE}", not grant.is_correct)
		end

	field_grant_test5
			-- Incorrect GRANT creation {WRONG_DATE_PERIOD}
		local
			grant: GRANT
			keys, values: ARRAY[STRING]
		do
			keys := <<"title", "agency", "period_start", "period_end", "continuation", "amount">>
			values := <<"Verifying Deep Mathematical Properties of AI Systems", "USAID",
				"2017-10-11" , "2016-04-02", "1 year", "100">>
			create grant.make_from_json (create_json (keys, values))
			assert("Grant created incorrectly. {WRONG_DATE_PERIOD}", not grant.is_correct)
		end

	field_grant_test6
			-- Incorrect GRANT creation {INVALID_NUMBER}
		local
			grant: GRANT
			keys, values: ARRAY[STRING]
		do
			keys := <<"title", "agency", "period_start", "period_end", "continuation", "amount">>
			values := <<"Verifying Deep Mathematical Properties of AI Systems", "USAID",
				"2016-04-02" , "2017-10-11", "1 year", "Number">>
			create grant.make_from_json (create_json (keys, values))
			assert("Grant created incorrectly. {INVALID_NUMBER}", not grant.is_correct)
		end

	field_grant_test7
			-- Incorrect GRANT creation {INVALID_NEGATIVE_NUMBER}
		local
			grant: GRANT
			keys, values: ARRAY[STRING]
		do
			keys := <<"title", "agency", "period_start", "period_end", "continuation", "amount">>
			values := <<"Verifying Deep Mathematical Properties of AI Systems", "USAID",
				"2016-04-02" , "2017-10-11", "1 year", "-100">>
			create grant.make_from_json (create_json (keys, values))
			assert("Grant created incorrectly. {INVALID_NEGATIVE_NUMBER}", not grant.is_correct)
		end

	field_grant_test8
			-- Incorrect GRANT creation {EMPTY_FIELD}
		local
			grant: GRANT
			keys, values: ARRAY[STRING]
		do
			keys := <<"title", "agency", "period_start", "period_end", "continuation", "amount">>
			values := <<"Verifying Deep Mathematical Properties of AI Systems", "",
				"2016-04-02" , "2017-10-11", "1 year", "100">>
			create grant.make_from_json (create_json (keys, values))
			assert("Grant created incorrectly. {EMPTY_FIELD}", not grant.is_correct)
		end

	field_grant_test9
			-- Incorrect GRANT creation {NOT_PARSED}
		local
			grant: GRANT
			keys, values: ARRAY[STRING]
		do
			keys := <<"not title", "agency", "period_start", "period_end", "continuation", "amount">>
			values := <<"Verifying Deep Mathematical Properties of AI Systems", "USAID",
				"2016-04-02" , "2017-10-11", "1 year", "100">>
			create grant.make_from_json (create_json (keys, values))
			assert("Grant created incorrectly. {NOT_PARSED}", not grant.is_correct)
		end

feature -- Test RESEARCH_PROJECT routines

	field_researh_project_test1
			-- Correct RESEARCH_PROJECT creation
		local
			researh_project: RESEARCH_PROJECT
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array_1, json_array_2: JSON_ARRAY
		do
			keys := <<"title", "start_date", "end_date", "financing">>
			values := <<"Smart MutHaf: 3D Models, Motion Capture, and Animations towards an Interactive Online Museum of the UAE",
				"2016-03-16", "2016-09-10", "UAEU">>
			json_object := create_json (keys, values)

			create json_array_1.make (2)
			json_array_1.add (create {JSON_STRING}.make_from_string ("Hend Al Tair"))
			json_array_1.add (create {JSON_STRING}.make_from_string ("Amna Yammahi"))

			create json_array_2.make (2)
			json_array_2.add (create {JSON_STRING}.make_from_string ("Vasya"))
			json_array_2.add (create {JSON_STRING}.make_from_string ("Petya"))

			json_object.put (json_array_1, "personnel")
			json_object.put (json_array_2, "extra_personnel")
			create researh_project.make_from_json (json_object)
			assert("Research project created correctly", researh_project.is_correct)
		end

	field_researh_project_test2
			-- Correct RESEARCH_PROJECT creation
		local
			researh_project: RESEARCH_PROJECT
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array_1, json_array_2: JSON_ARRAY
		do
			keys := <<"financing", "title", "start_date", "end_date">>
			values := <<"UAEU", "Smart MutHaf: 3D Models, Motion Capture, and Animations towards an Interactive Online Museum of the UAE",
				"2016-03-16", "2016-09-10">>
			json_object := create_json (keys, values)

			create json_array_1.make (2)
			json_array_1.add (create {JSON_STRING}.make_from_string ("Hend Al Tair"))
			json_array_1.add (create {JSON_STRING}.make_from_string ("Amna Yammahi"))

			create json_array_2.make (2)
			json_array_2.add (create {JSON_STRING}.make_from_string ("Vasya"))
			json_array_2.add (create {JSON_STRING}.make_from_string ("Petya"))

			json_object.put (json_array_1, "personnel")
			json_object.put (json_array_2, "extra_personnel")
			create researh_project.make_from_json (json_object)
			assert("Research project created correctly", researh_project.is_correct)
		end

	field_researh_project_test3
			-- Correct RESEARCH_PROJECT creation
		local
			researh_project: RESEARCH_PROJECT
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array_1, json_array_2: JSON_ARRAY
		do
			keys := <<"title", "start_date", "end_date", "financing">>
			values := <<"Smart MutHaf: 3D Models, Motion Capture, and Animations towards an Interactive Online Museum of the UAE",
				"2016-03-16", "2016-09-10", "UAEU">>
			json_object := create_json (keys, values)

			create json_array_1.make (2)
			json_array_1.add (create {JSON_STRING}.make_from_string ("Hend Al Tair"))
			json_array_1.add (create {JSON_STRING}.make_from_string ("Amna Yammahi"))

			create json_array_2.make_empty

			json_object.put (json_array_1, "personnel")
			json_object.put (json_array_2, "extra_personnel")
			create researh_project.make_from_json (json_object)
			assert("Research project created correctly", researh_project.is_correct)
		end

	field_researh_project_test4
			-- Incorrect RESEARCH_PROJECT creation {INVALID_DATE}
		local
			researh_project: RESEARCH_PROJECT
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array_1, json_array_2: JSON_ARRAY
		do
			keys := <<"title", "start_date", "end_date", "financing">>
			values := <<"Smart MutHaf: 3D Models, Motion Capture, and Animations towards an Interactive Online Museum of the UAE",
				"Yesterday", "Tomorrow", "UAEU">>
			json_object := create_json (keys, values)

			create json_array_1.make (2)
			json_array_1.add (create {JSON_STRING}.make_from_string ("Hend Al Tair"))
			json_array_1.add (create {JSON_STRING}.make_from_string ("Amna Yammahi"))

			create json_array_2.make (2)
			json_array_1.add (create {JSON_STRING}.make_from_string ("Vasya"))
			json_array_1.add (create {JSON_STRING}.make_from_string ("Petya"))

			json_object.put (json_array_1, "personnel")
			json_object.put (json_array_2, "extra_personnel")
			create researh_project.make_from_json (json_object)
			assert("Research project created incorrectly. {INVALID_DATE}", not researh_project.is_correct)
		end

	field_researh_project_test5
			-- Incorrect RESEARCH_PROJECT creation {WRONG_DATE_PERIOD}
		local
			researh_project: RESEARCH_PROJECT
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array_1, json_array_2: JSON_ARRAY
		do
			keys := <<"title", "start_date", "end_date", "financing">>
			values := <<"Smart MutHaf: 3D Models, Motion Capture, and Animations towards an Interactive Online Museum of the UAE",
				"2016-09-10", "2016-03-16", "UAEU">>
			json_object := create_json (keys, values)

			create json_array_1.make (2)
			json_array_1.add (create {JSON_STRING}.make_from_string ("Hend Al Tair"))
			json_array_1.add (create {JSON_STRING}.make_from_string ("Amna Yammahi"))

			create json_array_2.make (2)
			json_array_2.add (create {JSON_STRING}.make_from_string ("Vasya"))
			json_array_2.add (create {JSON_STRING}.make_from_string ("Petya"))

			json_object.put (json_array_1, "personnel")
			json_object.put (json_array_2, "extra_personnel")
			create researh_project.make_from_json (json_object)
			assert("Research project created incorrectly. {WRONG_DATE_PERIOD}", not researh_project.is_correct)
		end

	field_researh_project_test6
			-- Incorrect RESEARCH_PROJECT creation {EMPTY_ARRAY}
		local
			researh_project: RESEARCH_PROJECT
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array_1, json_array_2: JSON_ARRAY
		do
			keys := <<"title", "start_date", "end_date", "financing">>
			values := <<"Smart MutHaf: 3D Models, Motion Capture, and Animations towards an Interactive Online Museum of the UAE",
				"2016-03-16", "2016-09-10", "UAEU">>
			json_object := create_json (keys, values)

			create json_array_1.make_empty

			create json_array_2.make (2)
			json_array_2.add (create {JSON_STRING}.make_from_string ("Vasya"))
			json_array_2.add (create {JSON_STRING}.make_from_string ("Petya"))

			json_object.put (json_array_1, "personnel")
			json_object.put (json_array_2, "extra_personnel")
			create researh_project.make_from_json (json_object)
			assert("Research project created incorrectly. {EMPTY_ARRAY}", not researh_project.is_correct)
		end

	field_researh_project_test7
			-- Incorrect RESEARCH_PROJECT creation {EMPTY_FIELD}
		local
			researh_project: RESEARCH_PROJECT
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array_1, json_array_2: JSON_ARRAY
		do
			keys := <<"title", "start_date", "end_date", "financing">>
			values := <<"Smart MutHaf: 3D Models, Motion Capture, and Animations towards an Interactive Online Museum of the UAE",
				"2016-03-16", "2016-09-10", "">>
			json_object := create_json (keys, values)

			create json_array_1.make (2)
			json_array_1.add (create {JSON_STRING}.make_from_string ("Hend Al Tair"))
			json_array_1.add (create {JSON_STRING}.make_from_string ("Amna Yammahi"))

			create json_array_2.make (2)
			json_array_2.add (create {JSON_STRING}.make_from_string ("Vasya"))
			json_array_2.add (create {JSON_STRING}.make_from_string ("Petya"))

			json_object.put (json_array_1, "personnel")
			json_object.put (json_array_2, "extra_personnel")
			create researh_project.make_from_json (json_object)
			assert("Research project created incorrectly. {EMPTY_FIELD}", not researh_project.is_correct)
		end

	field_researh_project_test8
			-- Incorrect RESEARCH_PROJECT creation {NOT_PARSED}
		local
			researh_project: RESEARCH_PROJECT
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array_1, json_array_2: JSON_ARRAY
		do
			keys := <<"not title", "start_date", "end_date", "financing">>
			values := <<"Smart MutHaf: 3D Models, Motion Capture, and Animations towards an Interactive Online Museum of the UAE",
				"2016-03-16", "2016-09-10", "UAEU">>
			json_object := create_json (keys, values)

			create json_array_1.make (2)
			json_array_1.add (create {JSON_STRING}.make_from_string ("Hend Al Tair"))
			json_array_1.add (create {JSON_STRING}.make_from_string ("Amna Yammahi"))

			create json_array_2.make (2)
			json_array_2.add (create {JSON_STRING}.make_from_string ("Vasya"))
			json_array_2.add (create {JSON_STRING}.make_from_string ("Petya"))

			json_object.put (json_array_1, "personnel")
			json_object.put (json_array_2, "extra_personnel")
			create researh_project.make_from_json (json_object)
			assert("Research project created incorrectly. {NOT_PARSED}", not researh_project.is_correct)
		end

feature -- Test RESEARCH_COLLABORATION routines

	field_research_collaboration_test1
			-- Correct RESEARCH_COLLABORATION creation
		local
			research_collaboraion: RESEARCH_COLLABORATION
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"country", "name", "nature">>
			values := <<"USA", "Microsoft", "financing">>
			json_object := create_json (keys, values)

			create json_array.make (2)
			json_array.add (create {JSON_STRING}.make_from_string ("Head office: 555-55-5"))
			json_array.add (create {JSON_STRING}.make_from_string ("Russian office: 777-77-7"))

			json_object.put (json_array, "contacts")
			create research_collaboraion.make_from_json (json_object)
			assert("Research collaboration created correctly", research_collaboraion.is_correct)
		end

	field_research_collaboration_test2
			-- Correct RESEARCH_COLLABORATION creation
		local
			research_collaboraion: RESEARCH_COLLABORATION
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"nature", "country", "name">>
			values := <<"financing", "USA", "Microsoft">>
			json_object := create_json (keys, values)

			create json_array.make (2)
			json_array.add (create {JSON_STRING}.make_from_string ("Head office: 555-55-5"))
			json_array.add (create {JSON_STRING}.make_from_string ("Russian office: 777-77-7"))

			json_object.put (json_array, "contacts")
			create research_collaboraion.make_from_json (json_object)
			assert("Research collaboration created correctly", research_collaboraion.is_correct)
		end

	field_research_collaboration_test3
			-- Correct RESEARCH_COLLABORATION creation
		local
			research_collaboraion: RESEARCH_COLLABORATION
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"country", "name", "nature">>
			values := <<"USA", "Microsoft", "financing">>
			json_object := create_json (keys, values)

			create json_array.make_empty

			json_object.put (json_array, "contacts")
			create research_collaboraion.make_from_json (json_object)
			assert("Research collaboration created correctly", research_collaboraion.is_correct)
		end

	field_research_collaboration_test4
			-- Incorrect RESEARCH_COLLABORATION creation {EMPTY_FIELD}
		local
			research_collaboraion: RESEARCH_COLLABORATION
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"country", "name", "nature">>
			values := <<"", "Microsoft", "financing">>
			json_object := create_json (keys, values)

			create json_array.make (2)
			json_array.add (create {JSON_STRING}.make_from_string ("Head office: 555-55-5"))
			json_array.add (create {JSON_STRING}.make_from_string ("Russian office: 777-77-7"))

			json_object.put (json_array, "contacts")
			create research_collaboraion.make_from_json (json_object)
			assert("Research collaboration created incorrectly. {EMPTY_FIELD", not research_collaboraion.is_correct)
		end

	field_research_collaboration_test5
			-- Incorrect RESEARCH_COLLABORATION creation {NOT_PARSED}
		local
			research_collaboraion: RESEARCH_COLLABORATION
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"not country", "name", "nature">>
			values := <<"USA", "Microsoft", "financing">>
			json_object := create_json (keys, values)

			create json_array.make (2)
			json_array.add (create {JSON_STRING}.make_from_string ("Head office: 555-55-5"))
			json_array.add (create {JSON_STRING}.make_from_string ("Russian office: 777-77-7"))

			json_object.put (json_array, "contacts")
			create research_collaboraion.make_from_json (json_object)
			assert("Research collaboration created incorrectly. {NOT_PARSED", not research_collaboraion.is_correct)
		end

feature -- Test PUBLICATION routines

	field_publication_test1
			-- Correct PUBLICATION plans
		local
			publication: PUBLICATION
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"title", "date">>
			values := <<"AI", "2016-04-07">>
			json_object := create_json (keys, values)

			create json_array.make (2)
			json_array.add (create {JSON_STRING}.make_from_string ("Nickolaos Mavridis"))
			json_array.add (create {JSON_STRING}.make_from_string ("Ivan Ivanov"))

			json_object.put (json_array, "authors")
			create publication.make_from_json (json_object)
			assert("Publication created correctly", publication.is_correct)
		end

	field_publication_test2
			-- Correct PUBLICATION plans
		local
			publication: PUBLICATION
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"date", "title">>
			values := <<"2016-04-07", "AI">>
			json_object := create_json (keys, values)

			create json_array.make (2)
			json_array.add (create {JSON_STRING}.make_from_string ("Nickolaos Mavridis"))
			json_array.add (create {JSON_STRING}.make_from_string ("Ivan Ivanov"))

			json_object.put (json_array, "authors")
			create publication.make_from_json (json_object)
			assert("Publication created correctly", publication.is_correct)
		end

	field_publication_test3
			-- Incorrect PUBLICATION plans {EMPTY_ARRAY}
		local
			publication: PUBLICATION
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"title", "date">>
			values := <<"AI", "2016-04-07">>
			json_object := create_json (keys, values)

			create json_array.make_empty

			json_object.put (json_array, "authors")
			create publication.make_from_json (json_object)
			assert("Publication created incorrectly. {EMPTY_ARRAY}", not publication.is_correct)
		end

	field_publication_test4
			-- Incorrect PUBLICATION plans {INVALID_DATE}
		local
			publication: PUBLICATION
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"title", "date">>
			values := <<"AI", "Today">>
			json_object := create_json (keys, values)

			create json_array.make (2)
			json_array.add (create {JSON_STRING}.make_from_string ("Nickolaos Mavridis"))
			json_array.add (create {JSON_STRING}.make_from_string ("Ivan Ivanov"))

			json_object.put (json_array, "authors")
			create publication.make_from_json (json_object)
			assert("Publication created incorrectly. {INVALID_DATE}", not publication.is_correct)
		end

	field_publication_test5
			-- Incorrect PUBLICATION plans {EMPTY_FIELD}
		local
			publication: PUBLICATION
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"title", "date">>
			values := <<"", "2016-04-07">>
			json_object := create_json (keys, values)

			create json_array.make (2)
			json_array.add (create {JSON_STRING}.make_from_string ("Nickolaos Mavridis"))
			json_array.add (create {JSON_STRING}.make_from_string ("Ivan Ivanov"))

			json_object.put (json_array, "authors")
			create publication.make_from_json (json_object)
			assert("Publication created incorrectly. {EMPTY_FIELD}", not publication.is_correct)
		end

	field_publication_test6
			-- Incorrect PUBLICATION plans {NOT_PARSED}
		local
			publication: PUBLICATION
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"not title", "date">>
			values := <<"AI", "2016-04-07">>
			json_object := create_json (keys, values)

			create json_array.make (2)
			json_array.add (create {JSON_STRING}.make_from_string ("Nickolaos Mavridis"))
			json_array.add (create {JSON_STRING}.make_from_string ("Ivan Ivanov"))

			json_object.put (json_array, "authors")
			create publication.make_from_json (json_object)
			assert("Publication created incorrectly. {NOT_PARSED}", not publication.is_correct)
		end

feature -- Test PATENT routines

	field_patent_test1
			-- Correct PATENT creation
		local
			patent: PATENT
			keys, values: ARRAY[STRING]
		do
			keys := <<"title", "country">>
			values := <<"Gagarin", "Russia">>
			create patent.make_from_json (create_json (keys, values))
			assert("Patent created correctly", patent.is_correct)
		end

	field_patent_test2
			-- Correct PATENT creation
		local
			patent: PATENT
			keys, values: ARRAY[STRING]
		do
			keys := <<"country", "title">>
			values := <<"Russia", "Gagarin">>
			create patent.make_from_json (create_json (keys, values))
			assert("Patent created correctly", patent.is_correct)
		end

	field_patent_test3
			-- Incorrect PATENT creation {EMPTY_FIELD}
		local
			patent: PATENT
			keys, values: ARRAY[STRING]
		do
			keys := <<"country", "title">>
			values := <<"", "Gagarin">>
			create patent.make_from_json (create_json (keys, values))
			assert("Patent created incorrectly. {EMPTY_FIELD}", not patent.is_correct)
		end

	field_patent_test4
			-- Incorrect PATENT creation {NOT_PARSED}
		local
			patent: PATENT
			keys, values: ARRAY[STRING]
		do
			keys := <<"not country", "title">>
			values := <<"Russia", "Gagarin">>
			create patent.make_from_json (create_json (keys, values))
			assert("Patent created incorrectly. {NOT_PARSED}", not patent.is_correct)
		end

feature -- Test IP_LICENCE routines

	field_ip_licence_test1
			-- Correct IP_LICENCE
		local
			ip_licence: IP_LICENCE
			keys, values: ARRAY[STRING]
		do
			keys := <<"title">>
			values := <<"11-34">>
			create ip_licence.make_from_json (create_json (keys, values))
			assert("Ip licence created correctly", ip_licence.is_correct)
		end

	field_ip_licence_test2
			-- Incorrect IP_LICENCE {EMPTY_FIELD}
		local
			ip_licence: IP_LICENCE
			keys, values: ARRAY[STRING]
		do
			keys := <<"title">>
			values := <<"">>
			create ip_licence.make_from_json (create_json (keys, values))
			assert("Ip licence created correctly. {EMPTY_FIELD}", not ip_licence.is_correct)
		end

	field_ip_licence_test3
			-- Incorrect IP_LICENCE {NOT_PARSED}
		local
			ip_licence: IP_LICENCE
			keys, values: ARRAY[STRING]
		do
			keys := <<"not title">>
			values := <<"11-34">>
			create ip_licence.make_from_json (create_json (keys, values))
			assert("Ip licence created correctly. {NOT_PARSED}", not ip_licence.is_correct)
		end

feature -- Test PAPER_AWARD routines

	field_paper_award_test1
			-- Correct PAPER_AWARD creation
		local
			paper_award: PAPER_AWARD
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"title", "conference_journal", "wording", "date">>
			values := <<"Best Perfomance", "AWAE 2016", "Best Perfomance", "2016-06-10">>
			json_object := create_json (keys, values)

			create json_array.make (2)
			json_array.add (create {JSON_STRING}.make_from_string ("Nickolaos Mavridis"))
			json_array.add (create {JSON_STRING}.make_from_string ("Ivan Ivanov"))

			json_object.put (json_array, "authors")
			create paper_award.make_from_json (json_object)
			assert("Paper award created correctly", paper_award.is_correct)
		end

	field_paper_award_test2
			-- Correct PAPER_AWARD creation
		local
			paper_award: PAPER_AWARD
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"date", "title", "conference_journal", "wording">>
			values := <<"2016-06-10", "Best Perfomance", "AWAE 2016", "Best Perfomance">>
			json_object := create_json (keys, values)

			create json_array.make (2)
			json_array.add (create {JSON_STRING}.make_from_string ("Nickolaos Mavridis"))
			json_array.add (create {JSON_STRING}.make_from_string ("Ivan Ivanov"))

			json_object.put (json_array, "authors")
			create paper_award.make_from_json (json_object)
			assert("Paper award created correctly", paper_award.is_correct)
		end

	field_paper_award_test3
			-- Incorrect PAPER_AWARD creation {EMPTY_ARRAY}
		local
			paper_award: PAPER_AWARD
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"title", "conference_journal", "wording", "date">>
			values := <<"Best Perfomance", "AWAE 2016", "Best Perfomance", "2016-06-10">>
			json_object := create_json (keys, values)

			create json_array.make_empty

			json_object.put (json_array, "authors")
			create paper_award.make_from_json (json_object)
			assert("Paper award created incorrectly {EMPTY_ARRAY}", not paper_award.is_correct)
		end

	field_paper_award_test4
			-- Incorrect PAPER_AWARD creation {INVALID_DATE}
		local
			paper_award: PAPER_AWARD
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"title", "conference_journal", "wording", "date">>
			values := <<"Best Perfomance", "AWAE 2016", "Best Perfomance", "Today">>
			json_object := create_json (keys, values)


			create json_array.make (2)
			json_array.add (create {JSON_STRING}.make_from_string ("Nickolaos Mavridis"))
			json_array.add (create {JSON_STRING}.make_from_string ("Ivan Ivanov"))

			json_object.put (json_array, "authors")
			create paper_award.make_from_json (json_object)
			assert("Paper award created incorrectly {INVALID_DATE}", not paper_award.is_correct)
		end

	field_paper_award_test5
			-- Incorrect PAPER_AWARD creation {EMPTY_FIELD}
		local
			paper_award: PAPER_AWARD
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"title", "conference_journal", "wording", "date">>
			values := <<"Best Perfomance", "", "Best Perfomance", "2016-06-10">>
			json_object := create_json (keys, values)


			create json_array.make (2)
			json_array.add (create {JSON_STRING}.make_from_string ("Nickolaos Mavridis"))
			json_array.add (create {JSON_STRING}.make_from_string ("Ivan Ivanov"))

			json_object.put (json_array, "authors")
			create paper_award.make_from_json (json_object)
			assert("Paper award created incorrectly {EMPTY_FIELD}", not paper_award.is_correct)
		end

	field_paper_award_test6
			-- Incorrect PAPER_AWARD creation {NOT_PARSED}
		local
			paper_award: PAPER_AWARD
			keys, values: ARRAY[STRING]
			json_object: JSON_OBJECT
			json_array: JSON_ARRAY
		do
			keys := <<"not title", "conference_journal", "wording", "date">>
			values := <<"Best Perfomance", "AWAE 2016", "Best Perfomance", "2016-06-10">>
			json_object := create_json (keys, values)


			create json_array.make (2)
			json_array.add (create {JSON_STRING}.make_from_string ("Nickolaos Mavridis"))
			json_array.add (create {JSON_STRING}.make_from_string ("Ivan Ivanov"))

			json_object.put (json_array, "authors")
			create paper_award.make_from_json (json_object)
			assert("Paper award created incorrectly {EMPTY_FIELD}", not paper_award.is_correct)
		end

feature -- Test MEMBERSHIP routines

	field_membership_test1
			-- Correct MEMBERSHIP creation
		local
			membership: MEMBERSHIP
			keys, values: ARRAY[STRING]
		do
			keys := <<"name", "organization", "date">>
			values := <<"WAT", "Microsoft", "2016-03-02">>
			create membership.make_from_json (create_json (keys, values))
			assert("Membership created correctly", membership.is_correct)
		end

	field_membership_test2
			-- Correct MEMBERSHIP creation
		local
			membership: MEMBERSHIP
			keys, values: ARRAY[STRING]
		do
			keys := <<"date", "name", "organization">>
			values := <<"2016-03-02", "WAT", "Microsoft">>
			create membership.make_from_json (create_json (keys, values))
			assert("Membership created correctly", membership.is_correct)
		end

	field_membership_test3
			-- Incorrect MEMBERSHIP creation {INVALID_DATE}
		local
			membership: MEMBERSHIP
			keys, values: ARRAY[STRING]
		do
			keys := <<"name", "organization", "date">>
			values := <<"WAT", "Microsoft", "Today">>
			create membership.make_from_json (create_json (keys, values))
			assert("Membership created incorrectly. {INVALID_DATE}", not membership.is_correct)
		end

	field_membership_test4
			-- Incorrect MEMBERSHIP creation {EMPTY_FIELD}
		local
			membership: MEMBERSHIP
			keys, values: ARRAY[STRING]
		do
			keys := <<"name", "organization", "date">>
			values := <<"", "Microsoft", "2016-03-02">>
			create membership.make_from_json (create_json (keys, values))
			assert("Membership created incorrectly. {EMPTY_FIELD}", not membership.is_correct)
		end

	field_membership_test5
			-- Incorrect MEMBERSHIP creation {NOT_PARSED}
		local
			membership: MEMBERSHIP
			keys, values: ARRAY[STRING]
		do
			keys := <<"not name", "organization", "date">>
			values := <<"WAT", "Microsoft", "2016-03-02">>
			create membership.make_from_json (create_json (keys, values))
			assert("Membership created incorrectly. {NOT_PARSED}", not membership.is_correct)
		end

feature -- Test PRIZE routines

	field_prize_test1
			-- Correct PRIZE creation
		local
			prize: PRIZE
			keys, values: ARRAY[STRING]
		do
			keys := <<"recipient", "name", "institution", "date">>
			values := <<"Nikolaos Mavridis", "Best Professor", "Innopolis", "2016-10-15">>
			create prize.make_from_json (create_json (keys, values))
			assert("Prize created correctly", prize.is_correct)
		end

	field_prize_test2
			-- Correct PRIZE creation
		local
			prize: PRIZE
			keys, values: ARRAY[STRING]
		do
			keys := <<"date", "recipient", "name", "institution">>
			values := <<"2016-10-15", "Nikolaos Mavridis", "Best Professor", "Innopolis">>
			create prize.make_from_json (create_json (keys, values))
			assert("Prize created correctly", prize.is_correct)
		end

	field_prize_test3
			-- Incorrect PRIZE creation {INVALID_DATE}
		local
			prize: PRIZE
			keys, values: ARRAY[STRING]
		do
			keys := <<"recipient", "name", "institution", "date">>
			values := <<"Nikolaos Mavridis", "Best Professor", "Innopolis", "Today">>
			create prize.make_from_json (create_json (keys, values))
			assert("Prize created incorrectly. {INVALID_DATE}", not prize.is_correct)
		end

	field_prize_test4
			-- Incorrect PRIZE creation {EMPTY_FIELD}
		local
			prize: PRIZE
			keys, values: ARRAY[STRING]
		do
			keys := <<"recipient", "name", "institution", "date">>
			values := <<"", "Best Professor", "Innopolis", "2016-10-15">>
			create prize.make_from_json (create_json (keys, values))
			assert("Prize created incorrectly. {EMPTY_FIELD}", not prize.is_correct)
		end

	field_prize_test5
			-- Incorrect PRIZE creation {NOT_PARSED}
		local
			prize: PRIZE
			keys, values: ARRAY[STRING]
		do
			keys := <<"recipient", "", "institution", "date">>
			values := <<"Nikolaos Mavridis", "Best Professor", "Innopolis", "2016-10-15">>
			create prize.make_from_json (create_json (keys, values))
			assert("Prize created incorrectly. {NOT_PARSED}", not prize.is_correct)
		end

feature -- Test COLLABORATION routines

	field_collaboration_test1
			-- Correct COLLABORATION creation
		local
			collaboration: COLLABORATION
			keys, values: ARRAY[STRING]
		do
			keys := <<"company", "nature">>
			values := <<"Microsoft", "financing">>
			create collaboration.make_from_json (create_json (keys, values))
			assert("Collaboration created correctly", collaboration.is_correct)
		end

	field_collaboration_test2
			-- Correct COLLABORATION creation
		local
			collaboration: COLLABORATION
			keys, values: ARRAY[STRING]
		do
			keys := <<"nature", "company">>
			values := <<"financing", "Microsoft">>
			create collaboration.make_from_json (create_json (keys, values))
			assert("Collaboration created correctly", collaboration.is_correct)
		end

	field_collaboration_test3
			-- Incorrect COLLABORATION creation {EMPTY_FIELD}
		local
			collaboration: COLLABORATION
			keys, values: ARRAY[STRING]
		do
			keys := <<"company", "nature">>
			values := <<"", "financing">>
			create collaboration.make_from_json (create_json (keys, values))
			assert("Collaboration created incorrectly. {EMPTY_FIELD}", not collaboration.is_correct)
		end

	field_collaboration_test4
			-- Incorrect COLLABORATION creation {NOT_PARSED}
		local
			collaboration: COLLABORATION
			keys, values: ARRAY[STRING]
		do
			keys := <<"not company", "nature">>
			values := <<"Microsoft", "financing">>
			create collaboration.make_from_json (create_json (keys, values))
			assert("Collaboration created incorrectly. {NOT_PARSED}", not collaboration.is_correct)
		end
end


