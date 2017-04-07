class
	INTUITIVE_SERVER_EXECUTION

inherit
	WSF_EXECUTION
		redefine
			initialize
		end

create
	make


feature {NONE} -- Local variables


feature {NONE} -- Initialization
	initialize
		do
			Precursor
		end

feature -- Execution

	execute
		-- Process and answer an inbound query
		do
			if request.is_get_request_method then
				answer_get
			elseif request.is_post_request_method then
				process_data
			end
		end

	answer_get
		local
			mesg: WSF_PAGE_RESPONSE
			reader: PLAIN_TEXT_FILE
			path: STRING
		do
			path := "./www" + request.path_info
			if path.at (path.count) = '/' then
				path := path + "index.html"
			end
			create reader.make_with_path (create {PATH}.make_from_string (path))
			create mesg.make
			if not reader.exists then
				mesg.set_status_code (404)
				mesg.header.put_content_type_text_html
				mesg.set_body (get_404)
			else
				if path.ends_with (".html") then
					mesg.header.put_content_type_text_html
				elseif path.ends_with (".js") then
					mesg.header.put_content_type_text_javascript
				else
					mesg.header.put_content_type_text_plain
				end
				mesg.set_status_code (200)
				mesg.set_body (read_from_file(reader))
			end
			response.send (mesg)
		end

feature {NONE} -- Queries

	read_from_file(file: PLAIN_TEXT_FILE): STRING
		-- Reads and returns the text
		require
			file_exists: file.exists
			is_file: file.is_plain_text
		do
			create Result.make_empty
			file.open_read
			from
				file.read_line
			until
				file.exhausted
			loop
				Result.append (file.last_string)
				Result.append ("%N")
				file.read_line
			end
			Result.append (file.last_string)
		end

	get_404: STRING
		-- Returns response body for 404 error
		local
			reader: PLAIN_TEXT_FILE
		do
			create reader.make_with_path (create {PATH}.make_from_string ("./www/404.html"))
			if not reader.exists then
				Result := "This web page does not exist, try harder"
			else
				Result := read_from_file (reader)
			end
		end

feature -- Commands

	process_data
		-- Extracts data from the request
		local
			output: STRING
			lol: SUBMIT_DATA
		do
			create output.make_empty
			create lol.make(request)
			output.append (lol.is_correct.out)
			output.append ("%N")
			across request.form_parameters as ic
			loop
				output.append (ic.item.key)
				output.append ("%N")
			end
			response.put_string (output)
		end
end
