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

	kek
		local
			file: PLAIN_TEXT_FILE
			data: SUBMIT_DATA
			json: STRING
		do
			create file.make_open_read ("tests/test1.json")
			assert ("file opened", file.is_readable and file.count > 0)
			from
				create json.make (file.count)
			until
				file.exhausted
			loop
				file.read_line
				json.append (file.last_string)
			end
			create data.make (json)
			assert ("Data parsed", data.is_correct)
		end

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
end


