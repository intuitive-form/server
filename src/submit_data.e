class
	SUBMIT_DATA
create
	make

feature {NONE} -- Initialization

	make(request: WSF_REQUEST)
		-- Constructor
		do
			if attached {WSF_STRING} request.form_parameter ("name") as name and then
			attached {WSF_STRING} request.form_parameter ("surname") as surname and then
			attached {WSF_STRING} request.form_parameter("kek") as kek then
				is_correct := true
			else
				is_correct := false
			end
		end

feature -- Attributes

	is_correct: BOOLEAN
		-- True if the submitted form is correct


feature -- Commands
	build_sql_insert: STRING
		do
			create Result.make_empty
		end
end
