class
	DATA_PARSING_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	data_parsing_test1
			-- Test parsing data from 'test1.json'
		local
			file: PLAIN_TEXT_FILE
			data: SUBMIT_DATA
			json: STRING
			read: INTEGER
		do
			create file.make_open_read ("tests/test1.json")
			assert ("file opened", file.file_readable and file.count > 0)
			create json.make_filled ('0', file.count)
			read := file.read_to_string (json, 1, file.count)
			create data.make (json)
			assert ("Data parsed", data.is_correct)
		end

	data_parsing_test2
			-- Test parsing data from 'test2.json'
		local
			file: PLAIN_TEXT_FILE
			data: SUBMIT_DATA
			json: STRING
			read: INTEGER
		do
			create file.make_open_read ("tests/test2.json")
			assert ("file opened", file.file_readable and file.count > 0)
			create json.make_filled ('0', file.count)
			read := file.read_to_string (json, 1, file.count)
			io.put_string (json)
			create data.make (json)
			assert ("Data parsed", data.is_correct)
		end

end


