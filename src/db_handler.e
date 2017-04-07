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
				create db.make_open_read_write ("db.sqlite")
			else
				init_db
			end
		end

	init_db
		local
			q_modify: SQLITE_MODIFY_STATEMENT
		do
			create db.make_create_read_write ("db.sqlite")
			create q_modify.make("CREATE TABLE units (id INTEGER PRIMARY KEY, name TEXT UNIQUE, head TEXT, start_date TEXT, end_date TEXT);", db)
			q_modify.execute
		end

feature
	insert(data: SUBMIT_DATA)
		require
			data.is_correct
		local
			q_insert: SQLITE_INSERT_STATEMENT
		do
			create q_insert.make ("INSERT INTO units (name, head, start_date, end_date) VALUES (?1, ?2, ?3, ?4);", db)
			q_insert.execute_with_arguments (<<data.unit_name, data.head_name, data.reporting_period_start, data.reporting_period_end>>)
		end

	unit_names: ITERABLE[STRING]
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create q_select.make ("SELECT name FROM units;", db)
			create {LINKED_LIST[STRING]} Result.make
			if attached {LINKED_LIST[STRING]} Result as list then --pure beauty
				across q_select.execute_new as it loop
					list.put_front (it.item.string_value(1))
				end
			end
		end
end
