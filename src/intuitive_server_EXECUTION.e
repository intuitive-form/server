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

	response404: WSF_HTML_PAGE_RESPONSE

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			initialize_404
		end

	initialize_404
		-- initializes 404 web page
		local
			reader: PLAIN_TEXT_FILE
		do
			create response404.make
			response404.set_status_code (404)
			create reader.make_with_path (create {PATH}.make_from_string ("./www/404.html"))
			if not reader.exists then
				response404.set_body ("This web page does not exist, try harder")
			else
				response404.set_body (read_from_file(reader))
			end
		end

feature -- Execution

	execute
		-- Process and answer an inbound query
		local
			mesg: WSF_HTML_PAGE_RESPONSE
			reader: PLAIN_TEXT_FILE
			path: STRING
		do
			path := "./www" + request.path_info
			if path.at (path.count) = '/' then
				path := path + "index.html"
			end
			create reader.make_with_path (create {PATH}.make_from_string (path))
			if not reader.exists then
				response.send (response404)
			else
				create mesg.make
				mesg.set_status_code (200)
				mesg.set_body (read_from_file(reader))
				response.send (mesg)
			end
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
				file.read_line
			end
		end
end
