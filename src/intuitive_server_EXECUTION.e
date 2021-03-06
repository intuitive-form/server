class
	INTUITIVE_SERVER_EXECUTION

inherit
	WSF_ROUTED_EXECUTION

create
	make

feature {NONE}
	db: DB_HANDLER
		once
			create Result.make ("db.sqlite")
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

			router.handle ("/pub", create {POST_PUBLICATIONS}.make(db), router.methods_post) -- query 1
			router.handle ("/unit", create {POST_UNIT_INFO}.make(db), router.methods_post) -- query 2
			router.handle ("/courses", create {POST_COURSES}.make(db), router.methods_post) -- query 3
			router.handle ("/supervisions", create {POST_SUPERVISIONS}.make(db), router.methods_post) -- query 4
			router.handle ("/res_collabs", create {POST_RESEARCH_COLLABS}.make(db), router.methods_post) -- query 5
			router.handle ("/exams", create {POST_EXAMS}.make(db), router.methods_post) -- query 6
			router.handle ("/grants", create {POST_GRANTS}.make(db), router.methods_post) -- query 7

			router.handle ("/units", create {GET_UNITS}.make(db), router.methods_get)
			router.handle ("/courses", create {GET_COURSES}.make(db), router.methods_get)
			router.handle ("", fhdl, router.methods_get)
		end
end
