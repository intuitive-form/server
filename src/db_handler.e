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
			create q.make ("CREATE TABLE units (id INTEGER PRIMARY KEY, name TEXT UNIQUE, head TEXT, start_date INTEGER, end_date INTEGER);", db)
			q.execute
			create q.make ("CREATE TABLE courses (id INTEGER PRIMARY KEY, unit INTEGER, name TEXT UNIQUE, semester TEXT UNIQUE, level TEXT, students INTEGER);", db)
			q.execute
			create q.make ("CREATE TABLE exams (id INTEGER PRIMARY KEY, unit INTEGER UNIQUE, course INTEGER UNIQUE, type TEXT, students INTEGER);", db)
			q.execute
			create q.make ("CREATE TABLE supervisions (id INTEGER PRIMARY KEY, unit INTEGER, student TEXT, work TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE reports (id INTEGER PRIMARY KEY, unit INTEGER, student TEXT, title TEXT, publication TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE phd_theses (id INTEGER PRIMARY KEY, unit INTEGER, student TEXT, title TEXT, publication TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE grants (id INTEGER PRIMARY KEY, unit INTEGER, title TEXT, granter TEXT, start_date INTEGER, end_date INTEGER, continuing TEXT, amount INTEGER);", db)
			q.execute
			create q.make ("CREATE TABLE researches (id INTEGER PRIMARY KEY, unit INTEGER, title TEXT, start_date INTEGER, end_date INTEGER, financing TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE research_personnel (id INTEGER PRIMARY KEY, research INTEGER, name TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE research_extra_personnel (id INTEGER PRIMARY KEY, research INTEGER, name TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE research_collabs (id INTEGER PRIMARY KEY, unit INTEGER, country TEXT, institution TEXT, nature TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE collabs_contacts (id INTEGER PRIMARY KEY, collab INTEGER, name TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE conference_publications (id INTEGER PRIMARY KEY, unit INTEGER, title TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE journal_publications (id INTEGER PRIMARY KEY, unit INTEGER, title TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE conference_publications_authors (id INTEGER PRIMARY KEY, publication INTEGER, name TEXT);", db)
			q.execute
			create q.make ("CREATE TABLE journal_publications_authors (id INTEGER PRIMARY KEY, journal INTEGER, name TEXT);", db)
			q.execute
		end

feature
	insert(data: SUBMIT_DATA)
		require
			data.is_correct
		local
			q_insert: SQLITE_INSERT_STATEMENT
			q_select: SQLITE_QUERY_STATEMENT
			it: SQLITE_RESULT_ROW
			unit_id, course_id: INTEGER_64
		do
			io.put_string ("Inserting in DB%N")
			create q_insert.make ("INSERT INTO units (name, head, start_date, end_date) VALUES (?1, ?2, ?3, ?4);", db)
			check attached data.s1_general as tuple and then
				attached {STRING} tuple.item (1) as i1 and then
				attached {STRING} tuple.item (2) as i2 and then
				attached {DATE} tuple.item (3) as i3 and then
				attached {DATE} tuple.item (4) as i4 then
				q_insert.execute_with_arguments (<<i1, i2, i3.days, i4.days>>)
				unit_id := q_insert.last_row_id
			end

			create q_insert.make ("INSERT INTO courses (unit, name, semester, level, students) VALUES (?1, ?2, ?3, ?4, ?5);", db)
			check attached data.s2_courses as courses then
				across courses as c loop
					q_insert.execute_with_arguments (<<unit_id, c.item.name, c.item.semester, c.item.level, c.item.students>>)
				end
			end

			create q_insert.make ("INSERT INTO exams (unit, course, type, students) VALUES (?1, ?2, ?3, ?4);", db)
			create q_select.make ("SELECT id FROM courses WHERE (name = ?1 AND semester = ?2);", db)
			check attached data.s2_examinations as exams then
				across exams as e loop
					course_id := q_select.execute_new_with_arguments (<<e.item.course_name, e.item.semester>>).item.integer_64_value (1)
					q_insert.execute_with_arguments (<<unit_id, course_id, e.item.kind, e.item.students>>)
				end
			end

			create q_insert.make ("INSERT INTO supervisions (unit, student, work) VALUES (?1, ?2, ?3);", db);
			check attached data.s2_students as supervisions then
				across supervisions as sv loop
					q_insert.execute_with_arguments (<<unit_id, sv.item.name, sv.item.nature_of_work>>)
				end
			end

			create q_insert.make ("INSERT INTO reports (unit, student, title, publication) VALUES (?1, ?2, ?3, ?4);", db);
			check attached data.s2_student_reports as reports then
				across reports as r loop
					q_insert.execute_with_arguments (<<unit_id, r.item.student_name, r.item.title, r.item.plans>>)
				end
			end

			create q_insert.make ("INSERT INTO phd_theses (unit, student, title, publication) VALUES (?1, ?2, ?3, ?4);", db);
			check attached data.s2_phd as theses then
				across theses as t loop
					q_insert.execute_with_arguments (<<unit_id, t.item.student_name, t.item.title, t.item.plans>>)
				end
			end


			create q_insert.make ("INSERT INTO grants (unit, title, granter, start_date, end_date, continuing, amount VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7);", db);
			check attached data.s3_grants as grants then
				across grants as g loop
					q_insert.execute_with_arguments (<<unit_id, g.item.title, g.item.agency, g.item.period_start.days, g.item.period_end.day, g.item.continuation, g.item.amount>>)
				end
			end

			io.put_string ("Inserted in DB%N")
		end

	unit_names: ITERABLE[STRING]
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create q_select.make ("SELECT name FROM units;", db)
			create {LINKED_LIST[STRING]} Result.make
			check attached {LINKED_LIST[STRING]} Result as list then
				across q_select.execute_new as it loop
					list.put_front (it.item.string_value(1))
				end
			end
		end
end
