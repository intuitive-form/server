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
		local
			reader: PLAIN_TEXT_FILE
			body: STRING
		do
			Precursor
			create response404.make
			response404.set_status_code (404)
			create reader.make_with_path (create {PATH}.make_from_string ("./www/404.html"))
			if not reader.exists then
				response404.set_body ("This web page does not exist, try harder")
			else
				reader.open_read
				create body.make_empty
				from
					reader.read_line
				until
					reader.exhausted
				loop
					body.append (reader.last_string)
					reader.read_line
				end
				response404.set_body (body)
			end
		end

feature -- Execution

	execute
		-- Use `request' to get data for the incoming http request
		-- and `response' to send response back to the client
		local
			mesg: WSF_HTML_PAGE_RESPONSE
			reader: PLAIN_TEXT_FILE
			body: STRING
		do
			--| As example, you can use {WSF_PAGE_RESPONSE}
			--| To send back easily a simple plaintext message.
			create reader.make_with_path (create {PATH}.make_from_string ("./www" + request.path_info))
			if not reader.exists then
				response.send (response404)
			else
				create mesg.make
				reader.open_read
				mesg.set_status_code (200)
				create body.make_empty
				from
					reader.read_line
				until
					reader.exhausted
				loop
					body.append (reader.last_string)
					reader.read_line
				end
				mesg.set_body (body)
				response.send (mesg)
			end
		end
end
