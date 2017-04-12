class
	INTUITIVE_SERVER_EXECUTION

inherit
	WSF_ROUTED_EXECUTION

create
	make

feature {NONE}
	db: DB_HANDLER

feature -- Router

	setup_router
			-- Setup `router'
		local
			fhdl: WSF_FILE_SYSTEM_HANDLER
		do
			io.put_string ("Setup router%N")
			create db
			create fhdl.make_hidden ("www")
			fhdl.set_directory_index (<<"index.html">>)

			router.handle ("/submit", create {POST_SUBMIT}.make(db), router.methods_post)
			router.handle ("/pub", create {POST_PUBLICATIONS}.make(db), router.methods_post)
			router.handle ("/unit", create {POST_UNIT_INFO}.make(db), router.methods_post)
			router.handle ("", fhdl, router.methods_get)
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
end
