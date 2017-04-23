class
	DATA_PARSING_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	data_parsing_test1
			-- Test parsinf data from 'test1.json'
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

end


