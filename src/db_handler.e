note
	description: "Summary description for {DB_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DB_HANDLER

create
	make

feature {NONE}
	db: SQLITE_DATABASE

feature {NONE}
	make
		do
			if (create {RAW_FILE}.make_with_name("db.sqlite")).exists then
				init_db
			else
				create db.make_open_read_write ("db.sqlite")
			end
		end

	init_db
		do
			create db.make_create_read_write ("db.sqlite")
		end

feature
	insert(data: SUBMIT_DATA)
		require
			data.is_correct
		do

		end
end
