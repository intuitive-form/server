class
	DB_HANDLER

create
	make

feature {DB_INSERTER, DB_SELECTOR}
	db: SQLITE_DATABASE

feature {NONE}
	inserter: DB_INSERTER

	make
		local
			q: SQLITE_MODIFY_STATEMENT
		do
			io.put_string ("Make DB_HANDLER%N")
			if (create {RAW_FILE}.make_with_name("db.sqlite")).exists then
				create db.make_open_read_write ("db.sqlite")
			else
				create db.make_create_read_write ("db.sqlite")
				across db_schema as query loop
					create q.make (query.item, db)
					q.execute
				end
			end
			db.set_busy_handler (agent handler)
			create inserter.make (Current)
			create selector.make (Current)
		ensure
			not db.is_closed
			db.is_readable
			db.is_writable
			db.is_accessible
		end

	db_schema: ARRAY[STRING]
		once
			Result := <<
				"CREATE TABLE units (id INTEGER PRIMARY KEY, name TEXT UNIQUE, head TEXT, start_date INTEGER, end_date INTEGER, misc_info TEXT);",
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
				"CREATE TABLE journal_publications_authors (id INTEGER PRIMARY KEY, journal_pub INTEGER, name TEXT);",
				"CREATE TABLE patents (id INTEGER PRIMARY KEY, unit INTEGER, title TEXT, country TEXT);",
				"CREATE TABLE intellectual_propery_licences (id INTEGER PRIMARY KEY, unit INTEGER, title TEXT);",
				"CREATE TABLE paper_awards (id INTEGER PRIMARY KEY, unit INTEGER, title TEXT, awarder TEXT, award_wording TEXT, date INTEGER);",
				"CREATE TABLE paper_authors (id INTEGER PRIMARY KEY, paper INTEGER, name TEXT);",
				"CREATE TABLE academia_memberships (id INTEGER PRIMARY KEY, unit INTEGER, name TEXT, organization TEXT, date INTEGER);",
				"CREATE TABLE prizes (id INTEGER PRIMARY KEY, unit INTEGER, recipient TEXT, name TEXT, granter TEXT, date INTEGER);",
				"CREATE TABLE industry_collabs (id INTEGER PRIMARY KEY, unit INTEGER, company TEXT, nature TEXT);"
			>>
		end

	handler(i: NATURAL): BOOLEAN
		do
			Result := true
		end

feature
	selector: DB_SELECTOR

	insert(data: SUBMIT_DATA)
		require
			data.is_correct
		local
			unit_id: INTEGER_64
		do
			io.put_string ("Inserting in DB%N")

			inserter.insert_unit(data.s1_general)
			unit_id := inserter.last_added_id

			across data.s2_courses as c loop
				inserter.insert_course(c.item, unit_id)
			end
			across data.s2_examinations as e loop
				inserter.insert_exam(e.item, unit_id)
			end
			across data.s2_students as sv loop
				inserter.insert_supervision(sv.item, unit_id)
			end
			across data.s2_student_reports as r loop
				inserter.insert_report(r.item, unit_id)
			end
			across data.s2_phd as t loop
				inserter.insert_phd_thesis(t.item, unit_id)
			end
			across data.s3_grants as g loop
				inserter.insert_grant(g.item, unit_id)
			end
			across data.s3_research_projects as r loop
				inserter.insert_research(r.item, unit_id)
			end
			across data.s3_research_collaborations as c loop
				inserter.insert_research_collab(c.item, unit_id)
			end
			across data.s3_conference_publications as p loop
				inserter.insert_conference_pub(p.item, unit_id)
			end
			across data.s3_journal_publications as p loop
				inserter.insert_journal_pub(p.item, unit_id)
			end

			io.put_string ("Inserted in DB%N")
		end

end
