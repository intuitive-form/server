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

	field_unit_test3
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

	field_unit_test4
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

	field_unit_test5
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
			keys := <<"name", "semester", "level", "students_number", "start_date", "end_date">>
			values := <<"Computer Architecture", "Spring", "Bachelor", "129",  "2016-09-01", "2016-11-20">>
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
			values := <<"Computer Architecture", "Fall", "Master", "129",  "2016-09-01", "2016-11-20">>
			create course.make_from_json (create_json (keys, values))
			assert("Course created correctly", course.is_correct)
		end


	field_course_test4
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

	field_course_test5
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

	field_course_test6
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

	field_course_test7
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

	field_course_test8
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

	field_course_test9
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

	field_course_test10
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

	field_course_test11
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
			keys := <<"course_name", "semester", "kind", "students_number", "date">>
			values := <<"Computer Architecture", "Spring", "Final exam", "125", "2016-11-20">>
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
			values := <<"Computer Architecture", "Fall", "Repetition exam", "125", "2016-11-20">>
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
			values := <<"Computer Architecture", "Fall", "Midterm exam", "125", "2016-11-20">>
			create exam.make_from_json (create_json (keys, values))
			assert("Exam created correctly", exam.is_correct)
		end

	field_exam_test5
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

	field_exam_test6
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

	field_exam_test7
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

	field_exam_test8
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

	field_exam_test9
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

	field_exam_test10
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

	field_exam_test11
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

	field_student_test3
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
			keys := <<"student_name", "title", "plans">>
			values := <<"Ivan Ivanov", "A parallelized and streamlined vision front-end for tabletop robots", "">>
			create student_report.make_from_json (create_json (keys, values))
			assert("Student report created correctly", student_report.is_correct)
		end

	field_student_report_test3
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

	field_student_report_test4
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
			keys := <<"student_name", "title", "plans">>
			values := <<"Ivan Ivanov", "A parallelized and streamlined vision front-end for tabletop robots", "">>
			create phd_thesis.make_from_json (create_json (keys, values))
			assert("Phd thesis created correctly", phd_thesis.is_correct)
		end

	field_phd_thesis_test3
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

	field_phd_thesis_test4
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
			keys := <<"title", "agency", "period_start", "period_end", "continuation", "amount">>
			values := <<"Verifying Deep Mathematical Properties of AI Systems", "USAID",
				"2016-04-02" , "2017-10-11", "", "100">>
			create grant.make_from_json (create_json (keys, values))
			assert("Grant created correctly", grant.is_correct)
		end

	field_grant_test3
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

	field_grant_test4
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

	field_grant_test5
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

	field_grant_test6
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

	field_grant_test7
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

	field_grant_test8
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

	field_researh_project_test3
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

	field_researh_project_test4
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

	field_researh_project_test5
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

	field_researh_project_test6
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

	field_researh_project_test7
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

end


