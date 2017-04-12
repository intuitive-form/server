class
	POST_SUBMIT

inherit
	WSF_STARTS_WITH_HANDLER

create
	make

feature {NONE} -- Initialization

	make (p_db: DB_HANDLER)
		do
			db := p_db
		end

	db: DB_HANDLER

feature -- Execution

	execute (a_start_path: READABLE_STRING_8; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			output: STRING
			data: SUBMIT_DATA
			msg: WSF_PAGE_RESPONSE
		do
			io.put_string ("Processing POST%N")
			create output.make_empty
			create data.make(req)
			across req.form_parameters as ic
			loop
				output.append (ic.item.key)
				output.append ("%N")
			end
			output.append ("%N")

			if data.is_correct then
				io.put_string ("Data is correct%N")
				db.insert (data)
			end
			across db.unit_names as it
			loop
				output.append (it.item)
				output.append("%N")
			end
			create msg.make_with_body (output)
			res.send (msg)
		end

end
