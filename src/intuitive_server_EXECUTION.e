class
	INTUITIVE_SERVER_EXECUTION

inherit
	WSF_ROUTED_EXECUTION

create
	make

feature {NONE}
	db: DB_HANDLER
		once
			create Result.make
		end

feature -- Router

	setup_router
			-- Setup `router'
		local
			fhdl: WSF_FILE_SYSTEM_HANDLER
		do
			create fhdl.make_hidden ("www")
			fhdl.set_directory_index (<<"index.html">>)

			router.handle ("/submit", create {POST_SUBMIT}.make(db), router.methods_post)
			router.handle ("/pub", create {POST_PUBLICATIONS}.make(db), router.methods_post)
			router.handle ("/unit", create {POST_UNIT_INFO}.make(db), router.methods_post)
			router.handle ("/courses", create {POST_COURSES}.make(db), router.methods_post)
			router.handle ("", fhdl, router.methods_get)
		end
end
