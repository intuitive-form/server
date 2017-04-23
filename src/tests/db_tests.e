class
	DB_TESTS

inherit
	EQA_TEST_SET

feature {NONE}
	empty_temp
		local
			dir: DIRECTORY
		do
			create dir.make ("test_temp")
			if not dir.exists then
				dir.create_dir
			end
			dir.delete_content
		end

	get_test_data (path: STRING): SUBMIT_DATA
		local
			file: PLAIN_TEXT_FILE
			data: SUBMIT_DATA
			json: STRING
			db: DB_HANDLER
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
			create Result.make (json)
		ensure
			Result.is_correct
		end

feature

	test1
		local
			data: SUBMIT_DATA
			db: DB_HANDLER
		do
			empty_temp
			create db.make ("test_temp/test.db")
			data := get_test_data ("tests/test1.json")
			db.insert (data)
			assert ("Course inserted", across data.s2_courses as iter all db.selector.get_course_id (iter.item.name, iter.item.semester) /= -1 end and
				data.s2_courses.count = db.selector.courses.count)
			empty_temp
		ensure
			(create {DIRECTORY}.make ("test_temp")).is_empty
		end

end
