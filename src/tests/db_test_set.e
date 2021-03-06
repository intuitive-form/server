class
	DB_TEST_SET

inherit
	EQA_TEST_SET

feature {NONE}

	get_test_data (path: STRING): SUBMIT_DATA
		local
			file: PLAIN_TEXT_FILE
			data: SUBMIT_DATA
			json: STRING
			db: DB_HANDLER
			read: INTEGER
		do
			create file.make_with_path (create {PATH}.make_from_string (path))
			file.open_read
			assert ("file opened", file.file_readable and file.count > 0)
			create json.make_filled ('0', file.count)
			read := file.read_to_string (json, 1, file.count)
			json.remove_tail (json.count - read)
			assert ("Not empty", json.count > 0)
			create Result.make (json)
		ensure
			Result.is_correct
		end

feature

	db_insert_test
		local
			data: SUBMIT_DATA
			db: DB_HANDLER
		do
			create db.make ("")
			data := get_test_data ("tests/test1.json")
			db.insert (data)
			assert ("Course inserted",
				across data.s2_courses as iter all db.selector.get_course_id (iter.item.name, iter.item.semester) /= -1 end and
				data.s2_courses.count = db.selector.courses.count and
				data.s2_examinations.count = db.selector.exams_between_dates (create {DATE}.make (1600, 1, 1), create {DATE}.make (3000, 1, 1)).count
			)
		end

	db_insert_test2
		local
			data: SUBMIT_DATA
			db: DB_HANDLER
		do
			create db.make ("")
			data := get_test_data ("tests/test2.json")
			db.insert (data)
			assert ("Course inserted",
				across data.s2_courses as iter all db.selector.get_course_id (iter.item.name, iter.item.semester) /= -1 end and
				data.s2_courses.count = db.selector.courses.count and
				data.s2_examinations.count = db.selector.exams_between_dates (create {DATE}.make (1600, 1, 1), create {DATE}.make (3000, 1, 1)).count
			)
		end

	db_insert_test3
		local
			data1, data2: SUBMIT_DATA
			db: DB_HANDLER
		do
			create db.make ("")
			data1 := get_test_data ("tests/test1.json")
			data2 := get_test_data ("tests/test2.json")
			db.insert (data1)
			db.insert (data2)
			assert ("Course inserted", data1.s2_courses.count + data2.s2_courses.count = db.selector.courses.count)
		end

end
