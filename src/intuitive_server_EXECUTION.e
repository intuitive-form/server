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
		local
			db: DB_HANDLER
			path: STRING_8
			list: LINKED_LIST[STRING]
			params: LIST[STRING]
		do
			if request.is_get_request_method then
				path := request.path_info.as_string_8
				if path.starts_with ("/units/") then
					create db.make
					answer_with_array(db.unit_names)
				elseif path.starts_with ("/courses/") then
					create db.make
					params := path.substring (("/courses/").count + 1, path.count).split ('/')
					if path.count > ("/courses/").count then
						if params.count = 1 then
							answer_with_array(db.courses_of_unit (params.at (1)))
						elseif params.count = 3 then
							answer_with_array(db.courses_of_unit_between_dates (
								params.at (1),
								create {DATE}.make_from_string(params.at (2), "yyyy-[0]mm-[0]dd"),
								create {DATE}.make_from_string(params.at (3), "yyyy-[0]mm-[0]dd")
							))
						end
					else
						answer_with_array(db.courses)
					end
				elseif path.starts_with ("/grants/") then
					create db.make
					params := path.substring (("/grants/").count + 1, path.count).split ('/')
					if path.count > ("/grants/").count then
						if params.count = 1 then
							answer_with_array(db.grants_of_unit (params.at (1)))
						elseif params.count = 3 then
							answer_with_array(db.grants_of_unit_between_dates (
								params.at (1),
								create {DATE}.make_from_string(params.at (2), "yyyy-[0]mm-[0]dd"),
								create {DATE}.make_from_string(params.at (3), "yyyy-[0]mm-[0]dd")
							))
						end
					else
						answer_with_array(db.courses)
					end
				elseif path.starts_with ("/conference-pubs/") and attached path.substring (("/conference-pubs/").count + 1, path.count) as param and then param.is_integer then
					create db.make
					answer_with_array(db.conf_pubs (param.to_integer))
				elseif path.starts_with ("/head/") and attached path.substring (("/head/").count + 1, path.count) as param then
					create db.make
					create {ARRAYED_LIST[STRING]} params.make (1)
					params.sequence_put (db.head_name (path.substring (("/head/").count + 1, path.count)))
					answer_with_array(params)
				elseif path.starts_with ("/journal-pubs/") and attached path.substring (("/journal-pubs/").count + 1, path.count) as param and then param.is_integer then
					create db.make
					answer_with_array(db.journal_pubs (param.to_integer))
				elseif path.starts_with ("/pubs/") and attached path.substring (("/pubs/").count + 1, path.count) as param and then param.is_integer then
					create db.make
					list := db.journal_pubs (param.to_integer)
					list.append (db.conf_pubs (param.to_integer))
					answer_with_array(list)
				else
					answer_get
				end
			elseif request.is_post_request_method then
				process_data
			end
		end


feature {NONE}



	answer_with_array(arr: LIST[STRING])
		local
			mesg: WSF_PAGE_RESPONSE
		do
			create mesg.make
			mesg.header.put_content_type_text_plain
			mesg.set_body ("")
			mesg.set_status_code (200)
			across arr as s loop
				if s.item /= void then
					mesg.body.append (s.item)
					mesg.body.append ("%N")
				end
			end
			response.send (mesg)
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
			create mesg.make
			if not (create {RAW_FILE}.make_with_name(path)).exists then
				mesg.set_status_code (404)
				mesg.header.put_content_type_text_html
				mesg.set_body (get_404)
			else
				create reader.make_with_path (create {PATH}.make_from_string (path))
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
			db: DB_HANDLER
		do
			io.put_string ("Processing POST%N")
			create output.make_empty
			create lol.make(request)
			across request.form_parameters as ic
			loop
				output.append (ic.item.key)
				output.append ("%N")
			end
			output.append ("%N")

			create db.make
			if lol.is_correct then
				io.put_string ("Data is correct%N")
				db.insert (lol)
			end
			across db.unit_names as it
			loop
				output.append (it.item)
				output.append("%N")
			end
			response.put_string (output)
		end
end
