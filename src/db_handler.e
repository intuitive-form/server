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
			q: SQLITE_MODIFY_STATEMENT
		do
			create db.make_create_read_write ("db.sqlite")
			create q.make ("CREATE TABLE units (id INTEGER PRIMARY KEY, name TEXT, head TEXT, start-date INTEGER, end-date INTEGER);", db)
			q.execute
			create q.make ("CREATE TABLE courses (id INTEGER PRIMARY KEY, unit INTEGER, name TEXT UNIQUE, semester TEXT UNIQUE, level TEXT, students INTEGER);", db)
			q.execute
			create q.make ("CREATE TABLE exams (id INTEGER PRIMARY KEY, unit INTEGER UNIQUE, course INTEGER UNIQUE, type TEXT, students INTEGER);", db)
			q.execute
			create q.make ("CREATE TABLE supervisions (id INTEGER PRIMARY KEY, unit INTEGER, student TEXT, work TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE reports (id INTEGER PRIMARY KEY, unit INTEGER, student TEXT, title TEXT, publication TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE phd-theses (id INTEGER PRIMARY KEY, unit INTEGER, student TEXT, title TEXT, publication TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE grants (id INTEGER PRIMARY KEY, unit INTEGER, title TEXT, granter TEXT, start-date INTEGER, end-date INTEGER, continuing TEXT, amount INTEGER);", db)
			q.execute
			create q.make ("CREATE TABLE researches (id INTEGER PRIMARY KEY, unit INTEGER, title TEXT, start-date INTEGER, end-date INTEGER, financing TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE research-personnel (id INTEGER PRIMARY KEY, research INTEGER, name TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE research-extra-personnel (id INTEGER PRIMARY KEY, research INTEGER, name TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE research-collabs (id INTEGER PRIMARY KEY, unit INTEGER, country TEXT, institution TEXT, nature TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE collabs-contacts (id INTEGER PRIMARY KEY, collab INTEGER, name TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE conference-publications (id INTEGER PRIMARY KEY, unit INTEGER, title TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE journal-publications (id INTEGER PRIMARY KEY, unit INTEGER, title TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE conference-publications-authors (id INTEGER PRIMARY KEY, publication INTEGER, name TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE journal-publications-authors (id INTEGER PRIMARY KEY, journal INTEGER, name TEXT);", db)
			q.execute
		end

feature
	insert(data: SUBMIT_DATA)
		require
			data.is_correct
		local
			q_insert: SQLITE_INSERT_STATEMENT
		do
			create q_insert.make ("INSERT INTO units (name, head, start_date, end_date) VALUES (?1, ?2, ?3, ?4);", db)
			if attached data.s1_general as tuple and then
				attached {STRING} tuple.item (1) as i1 and then
				attached {STRING} tuple.item (2) as i2 and then
				attached {STRING} tuple.item (3) as i3 and then
				attached {STRING} tuple.item (4) as i4 then
				q_insert.execute_with_arguments (<<i1, i2, i3, i4>>)
			end
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
