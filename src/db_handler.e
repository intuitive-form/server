class
	DB_HANDLER

feature {NONE}
	db: SQLITE_DATABASE
		local
			q: SQLITE_MODIFY_STATEMENT
		once
			if (create {RAW_FILE}.make_with_name("db.sqlite")).exists then
				create Result.make_open_read_write ("db.sqlite")
			else
				create Result.make_create_read_write ("db.sqlite")
				across db_schema as query loop
					create q.make (query.item, Result)
					q.execute
				end
			end
			Result.set_busy_handler (agent handler)
		end

	db_schema: ARRAY[STRING]
		once
			Result := <<
				"CREATE TABLE units (id INTEGER PRIMARY KEY, name TEXT UNIQUE, head TEXT, start_date INTEGER, end_date INTEGER);",
				"CREATE TABLE courses (id INTEGER PRIMARY KEY, unit INTEGER, name TEXT, semester TEXT, level TEXT, students INTEGER, start_date INTEGER, end_date INTEGER, CONSTRAINT course_unique UNIQUE (name, semester));",
				"CREATE TABLE exams (id INTEGER PRIMARY KEY, unit INTEGER, course INTEGER, type TEXT, students INTEGER);",
				"CREATE TABLE supervisions (id INTEGER PRIMARY KEY, unit INTEGER, student TEXT, work TEXT);",
				"CREATE TABLE reports (id INTEGER PRIMARY KEY, unit INTEGER, student TEXT, title TEXT, publication TEXT);",
				"CREATE TABLE phd_theses (id INTEGER PRIMARY KEY, unit INTEGER, student TEXT, title TEXT, publication TEXT);",
				"CREATE TABLE grants (id INTEGER PRIMARY KEY, unit INTEGER, title TEXT, granter TEXT, start_date INTEGER, end_date INTEGER, continuing TEXT, amount INTEGER);",
				"CREATE TABLE researches (id INTEGER PRIMARY KEY, unit INTEGER, title TEXT, start_date INTEGER, end_date INTEGER, financing TEXT);",
				"CREATE TABLE research_personnel (id INTEGER PRIMARY KEY, research INTEGER, name TEXT);",
				"CREATE TABLE research_extra_personnel (id INTEGER PRIMARY KEY, research INTEGER, name TEXT);",
				"CREATE TABLE research_collabs (id INTEGER PRIMARY KEY, unit INTEGER, country TEXT, institution TEXT, nature TEXT);",
				"CREATE TABLE collabs_contacts (id INTEGER PRIMARY KEY, collab INTEGER, name TEXT);",
				"CREATE TABLE conference_publications (id INTEGER PRIMARY KEY, unit INTEGER, title TEXT, date INTEGER);",
				"CREATE TABLE journal_publications (id INTEGER PRIMARY KEY, unit INTEGER, title TEXT, date INTEGER);",
				"CREATE TABLE conference_publications_authors (id INTEGER PRIMARY KEY, conf_pub INTEGER, name TEXT);",
				"CREATE TABLE journal_publications_authors (id INTEGER PRIMARY KEY, journal_pub INTEGER, name TEXT);"
			>>
		end

	handler(i: NATURAL): BOOLEAN
		do
			Result := true
		end

feature {NONE}
	-- Insert helpers
	last_added_id: INTEGER_64

	insert_unit_query: SQLITE_INSERT_STATEMENT
		once
			create Result.make ("INSERT INTO units (name, head, start_date, end_date) VALUES (?1, ?2, ?3, ?4);", db)
		end

	insert_course_query: SQLITE_INSERT_STATEMENT
		once
			create Result.make ("INSERT INTO courses (unit, name, semester, level, students, start_date, end_date) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7);", db)
		end

	insert_exam_query: SQLITE_INSERT_STATEMENT
		once
			create Result.make ("INSERT INTO exams (unit, course, type, students) VALUES (?1, ?2, ?3, ?4);", db)
		end

	insert_unit(p_unit: UNIT)
		require
			not unit_exists(p_unit.name)
		do
			insert_unit_query.execute_with_arguments (<<p_unit.name, p_unit.head, p_unit.start_date.days, p_unit.end_date.days>>)
			last_added_id := insert_unit_query.last_row_id
		ensure
			unit_exists(p_unit.name)
		end

	insert_course(p_course: COURSE; unit_id: INTEGER_64)
		require
			does_not_exist: get_course_id(p_course.name, p_course.semester) = -1
		do
			insert_course_query.execute_with_arguments (<<unit_id, p_course.name, p_course.semester, p_course.level, p_course.students, p_course.start_date.days, p_course.end_date.days>>)
			last_added_id := insert_course_query.last_row_id
		ensure
			exists: get_course_id(p_course.name, p_course.semester) /= -1
		end

	insert_exam(p_exam: EXAM; unit_id: INTEGER_64)
		require
			course_exists: get_course_id(p_exam.course_name, p_exam.semester) /= -1
		do
			insert_exam_query.execute_with_arguments (<<unit_id, get_course_id(p_exam.course_name, p_exam.semester), p_exam.kind, p_exam.students>>)
			last_added_id := insert_exam_query.last_row_id
		end

	insert_supervision(p_student: STUDENT; unit_id: INTEGER_64)
		local
			q_insert: SQLITE_INSERT_STATEMENT
		do
			create q_insert.make ("INSERT INTO supervisions (unit, student, work) VALUES (?1, ?2, ?3);", db);
			q_insert.execute_with_arguments (<<unit_id, p_student.name, p_student.nature_of_work>>)
			last_added_id := q_insert.last_row_id
		end

	insert_report(p_rep: STUDENT_REPORT; unit_id: INTEGER_64)
		local
			q_insert: SQLITE_INSERT_STATEMENT
		do
			create q_insert.make ("INSERT INTO reports (unit, student, title, publication) VALUES (?1, ?2, ?3, ?4);", db);
			q_insert.execute_with_arguments (<<unit_id, p_rep.student_name, p_rep.title, p_rep.plans>>)
			last_added_id := q_insert.last_row_id
		end

	insert_phd_thesis(p_phd: PHD_THESIS; unit_id: INTEGER_64)
		local
			q_insert: SQLITE_INSERT_STATEMENT
		do
			create q_insert.make ("INSERT INTO phd_theses (unit, student, title, publication) VALUES (?1, ?2, ?3, ?4);", db);
			q_insert.execute_with_arguments (<<unit_id, p_phd.student_name, p_phd.title, p_phd.plans>>)
			last_added_id := q_insert.last_row_id
		end

	insert_grant(p_grant: GRANT; unit_id: INTEGER_64)
		local
			q_insert: SQLITE_INSERT_STATEMENT
		do
			create q_insert.make ("INSERT INTO grants (unit, title, granter, start_date, end_date, continuing, amount) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7);", db);
			q_insert.execute_with_arguments (<<unit_id, p_grant.title, p_grant.agency, p_grant.period_start.days, p_grant.period_end.days, p_grant.continuation, p_grant.amount>>)
			last_added_id := q_insert.last_row_id
		end

	insert_research(p_research: RESEARCH_PROJECT; unit_id: INTEGER_64)
		local
			q1, q2, q3: SQLITE_INSERT_STATEMENT
		do
			create q1.make ("INSERT INTO researches (unit, title, start_date, end_date, financing) VALUES (?1, ?2, ?3, ?4, ?5);", db);
			create q2.make ("INSERT INTO research_personnel (research, name) VALUES (?1, ?2);", db);
			create q3.make ("INSERT INTO research_extra_personnel (research, name) VALUES (?1, ?2);", db);
			q1.execute_with_arguments (<<unit_id, p_research.title, p_research.date_start.days, p_research.date_end.days, p_research.sources_of_financing>>)
			last_added_id := q1.last_row_id
			across p_research.personnel as p loop
				q2.execute_with_arguments (<<last_added_id, p.item>>)
			end
			across p_research.extra_personnel as p loop
				q3.execute_with_arguments (<<last_added_id, p.item>>)
			end
		end

	insert_research_collab(p_collab: RESEARCH_COLLABORATION; unit_id: INTEGER_64)
		local
			q1, q2: SQLITE_INSERT_STATEMENT
		do
			create q1.make ("INSERT INTO research_collabs (unit, country, institution, nature) VALUES (?1, ?2, ?3, ?4);", db);
			create q2.make ("INSERT INTO collabs_contacts (collab, name) VALUES (?1, ?2);", db);
			q1.execute_with_arguments (<<unit_id, p_collab.institution_country, p_collab.institution_name, p_collab.nature>>)
			last_added_id := q1.last_row_id
			across p_collab.contracts as c loop
				q2.execute_with_arguments (<<last_added_id, c.item>>)
			end
		end

	insert_conference_pub(p_pub: PUBLICATION; unit_id: INTEGER_64)
		local
			q1, q2: SQLITE_INSERT_STATEMENT
		do
			create q1.make ("INSERT INTO conference_publications (unit, title, date) VALUES (?1, ?2, ?3);", db);
			create q2.make ("INSERT INTO conference_publications_authors (conf_pub, name) VALUES (?1, ?2);", db);
			q1.execute_with_arguments (<<unit_id, p_pub.title, p_pub.date.days>>)
			last_added_id := q1.last_row_id
			across p_pub.authors as a loop
				q2.execute_with_arguments (<<last_added_id, a.item>>)
			end
		end

	insert_journal_pub(p_pub: PUBLICATION; unit_id: INTEGER_64)
		local
			q1, q2: SQLITE_INSERT_STATEMENT
		do
			create q1.make ("INSERT INTO journal_publications (unit, title, date) VALUES (?1, ?2, ?3);", db);
			create q2.make ("INSERT INTO journal_publications_authors (journal_pub, name) VALUES (?1, ?2);", db);
			q1.execute_with_arguments (<<unit_id, p_pub.title, p_pub.date.days>>)
			last_added_id := q1.last_row_id
			across p_pub.authors as a loop
				q2.execute_with_arguments (<<last_added_id, a.item>>)
			end
		end

feature

	insert(data: SUBMIT_DATA)
		require
			data.is_correct
		local
			unit_id: INTEGER_64
		do
			io.put_string ("Inserting in DB%N")

			insert_unit(data.s1_general)
			unit_id := last_added_id

			across data.s2_courses as c loop
				insert_course(c.item, unit_id)
			end
			across data.s2_examinations as e loop
				insert_exam(e.item, unit_id)
			end
			across data.s2_students as sv loop
				insert_supervision(sv.item, unit_id)
			end
			across data.s2_student_reports as r loop
				insert_report(r.item, unit_id)
			end
			across data.s2_phd as t loop
				insert_phd_thesis(t.item, unit_id)
			end
			across data.s3_grants as g loop
				insert_grant(g.item, unit_id)
			end
			across data.s3_research_projects as r loop
				insert_research(r.item, unit_id)
			end
			across data.s3_research_collaborations as c loop
				insert_research_collab(c.item, unit_id)
			end
			across data.s3_conference_publications as p loop
				insert_conference_pub(p.item, unit_id)
			end
			across data.s3_journal_publications as p loop
				insert_journal_pub(p.item, unit_id)
			end

			io.put_string ("Inserted in DB%N")
		end

feature
	-- Select Queries

	unit_exists(p_name: STRING): BOOLEAN
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create q_select.make ("SELECT id FROM units WHERE name = ?1;", db)
			Result := not q_select.execute_new_with_arguments (<<p_name>>).after
		end

	get_course_id(p_name: STRING; p_semester: STRING): INTEGER_64
		-- returns -1 if course does not exist or course id if it exists
		local
			q_select: SQLITE_QUERY_STATEMENT
			q_it: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			create q_select.make ("SELECT id FROM courses WHERE name = ?1 AND semester = ?2;", db)
			q_it := q_select.execute_new_with_arguments (<<p_name, p_semester>>)
			if q_it.after then
				Result := -1
			else
				Result := q_it.item.integer_value (1)
			end
		end

	unit_names: LINKED_LIST[STRING]
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create q_select.make ("SELECT name FROM units;", db)
			create Result.make

			across q_select.execute_new as it loop
				Result.put_front (it.item.string_value(1))
			end
		end

	head_name(unit: STRING): STRING
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create q_select.make ("SELECT head FROM units WHERE name = ?1;", db)
			check attached q_select.execute_new_with_arguments (<<unit>>) as it then
				if not it.after then
					Result := it.item.string_value(1)
				end
			end
		end

	conf_pubs(year: INTEGER): LINKED_LIST[STRING]
		local
			q_select: SQLITE_QUERY_STATEMENT
			date_1, date_2: DATE
		do
			create q_select.make ("SELECT title FROM conference_publications WHERE date BETWEEN ?1 AND ?2;", db)
			create date_1.make (year, 1, 1)
			create date_2.make (year + 1, 1, 1)
			date_2.day_back
			create Result.make
			across q_select.execute_new_with_arguments (<<date_1.days, date_2.days>>) as i loop
				Result.put_front(i.item.string_value (1))
			end
		end

	journal_pubs(year: INTEGER): LINKED_LIST[STRING]
		local
			q_select: SQLITE_QUERY_STATEMENT
			date_1, date_2: DATE
		do
			create q_select.make ("SELECT title FROM journal_publications WHERE date BETWEEN ?1 AND ?2;", db)
			create date_1.make (year, 1, 1)
			create date_2.make (year + 1, 1, 1)
			date_2.day_back
			create Result.make
			across q_select.execute_new_with_arguments (<<date_1.days, date_2.days>>) as i loop
				Result.put_front(i.item.string_value (1))
			end
		end

	courses: LINKED_LIST[STRING]
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create q_select.make ("SELECT name FROM courses;", db)
			create Result.make
			across q_select.execute_new as i loop
				Result.put_front(i.item.string_value (1))
			end
		end

	courses_of_unit(unit: STRING): LINKED_LIST[COURSE]
		local
			q_select: SQLITE_QUERY_STATEMENT
			it: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			io.put_string (unit)
			io.new_line
			create Result.make
			create q_select.make ("SELECT id FROM units WHERE name = ?1;", db)
			it := q_select.execute_new_with_arguments(<<unit>>)
			if not it.after and then attached it.item.integer_value (1) as unit_id then
				create q_select.make ("SELECT name, semester, level, students, start_date, end_date FROM courses WHERE unit = ?1 AND start_date >= ?2 AND end_date <= ?3;", db)
				across q_select.execute_new_with_arguments (<<unit_id>>) as i loop
					Result.put_front(create {COURSE}.make_ready (
						i.item.string_value(1),
						i.item.string_value(2),
						i.item.string_value(3),
						i.item.integer_value(4),
						create {DATE}.make_by_days (i.item.integer_value(5)),
						create {DATE}.make_by_days (i.item.integer_value(6))
					))
				end
			end
		end

	courses_of_unit_between_dates(unit: STRING; date1, date2: DATE): LINKED_LIST[COURSE]
		local
			q_select: SQLITE_QUERY_STATEMENT
			it: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			io.put_string (unit)
			io.new_line
			create Result.make
			create q_select.make ("SELECT id FROM units WHERE name = ?1;", db)
			it := q_select.execute_new_with_arguments(<<unit>>)
			if not it.after and then attached it.item.integer_value (1) as unit_id then
				create q_select.make ("SELECT name, semester, level, students, start_date, end_date FROM courses WHERE unit = ?1 AND start_date >= ?2 AND end_date <= ?3;", db)
				across q_select.execute_new_with_arguments (<<unit_id, date1.days, date2.days>>) as i loop
					Result.put_front(create {COURSE}.make_ready (
						i.item.string_value(1),
						i.item.string_value(2),
						i.item.string_value(3),
						i.item.integer_value(4),
						create {DATE}.make_by_days (i.item.integer_value(5)),
						create {DATE}.make_by_days (i.item.integer_value(6))
					))
				end
			end
		end

	grants_of_unit(unit: STRING): LINKED_LIST[GRANT]
		local
			q_select: SQLITE_QUERY_STATEMENT
			it: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			io.put_string (unit)
			io.new_line
			create Result.make
			create q_select.make ("SELECT id FROM units WHERE name = ?1;", db)
			it := q_select.execute_new_with_arguments(<<unit>>)
			if not it.after and then attached it.item.integer_value (1) as unit_id then
				create q_select.make ("SELECT title, granter, start_date, end_date, continuing, amount FROM grants WHERE unit = ?1;", db)
				across q_select.execute_new_with_arguments (<<unit_id>>) as i loop
					Result.put_front (create {GRANT}.make_ready (
						i.item.string_value(1),
						i.item.string_value(2),
						create {DATE}.make_by_days (i.item.integer_value(3)),
						create {DATE}.make_by_days (i.item.integer_value(4)),
						i.item.string_value(5),
						i.item.integer_value(6)
					))
				end
			end
		end
end
