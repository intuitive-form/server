class
	DB_SELECTOR

create
	make

feature {NONE}

	handler: DB_HANDLER
	db: SQLITE_DATABASE

	make (p_handler: DB_HANDLER)
		do
			handler := p_handler
			db := handler.db
		end

feature
	unit_exists(p_name: STRING): BOOLEAN
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create q_select.make ("SELECT id FROM units WHERE name = ?1;", db)
			Result := not q_select.execute_new_with_arguments (<<p_name>>).after
		end

	unit_id(p_name: STRING): INTEGER_64
		require
			unit_exists (p_name)
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create q_select.make ("SELECT id FROM units WHERE name = ?1;", db)
			Result := q_select.execute_new_with_arguments (<<p_name>>).item.integer_64_value (1)
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
		require
			unit_exists (unit)
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

	courses: LINKED_LIST[COURSE]
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create Result.make
			create q_select.make ("SELECT name, semester, level, students, start_date, end_date FROM courses;", db)
			across q_select.execute_new as i loop
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

	courses_of_unit(unit: STRING): LINKED_LIST[COURSE]
		require
			unit_exists (unit)
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create Result.make
			create q_select.make ("SELECT name, semester, level, students, start_date, end_date FROM courses WHERE unit = ?1 AND start_date >= ?2 AND end_date <= ?3;", db)
			across q_select.execute_new_with_arguments (<<unit_id (unit)>>) as i loop
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

	courses_of_unit_between_dates(unit: STRING; date1, date2: DATE): LINKED_LIST[COURSE]
		require
			unit_exists (unit)
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create Result.make
			create q_select.make ("SELECT name, semester, level, students, start_date, end_date FROM courses WHERE unit = ?1 AND start_date >= ?2 AND end_date <= ?3;", db)
			across q_select.execute_new_with_arguments (<<unit_id (unit), date1.days, date2.days>>) as i loop
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

	supervised_students(unit: STRING): LINKED_LIST[STUDENT]
		require
			unit_exists (unit)
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create Result.make
			create q_select.make ("SELECT student, work FROM supervisions WHERE unit = ?1;", db)
			across q_select.execute_new_with_arguments (<<unit_id (unit)>>) as iter loop
				Result.put_front (create {STUDENT}.make (
					iter.item.string_value (1),
					iter.item.string_value (2)
				))
			end
		end

	exams_between_dates(date1, date2: DATE): LINKED_LIST[EXAM]
		local
			q_select, q_course: SQLITE_QUERY_STATEMENT
			it: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			create Result.make
			create q_select.make ("SELECT course, type, students, date FROM exams WHERE date >= ?1 AND date <= ?2;", db)
			across q_select.execute_new_with_arguments (<<date1.days, date2.days>>) as iter loop
				create q_course.make ("SELECT name, semester FROM courses WHERE id = ?1;", db)
				it := q_course.execute_new_with_arguments (<<iter.item.integer_value(1)>>)
				if not it.after then
					Result.put_front (create {EXAM}.make_ready (
						it.item.string_value (1),
						it.item.string_value (2),
						iter.item.string_value (2),
						iter.item.integer_value (3),
						create {DATE}.make_by_days (iter.item.integer_value (4))
					))
				end
			end
		end

	grants_of_unit(unit: STRING): LINKED_LIST[GRANT]
		require
			unit_exists (unit)
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create Result.make
			create q_select.make ("SELECT title, granter, start_date, end_date, continuing, amount FROM grants WHERE unit = ?1;", db)
			across q_select.execute_new_with_arguments (<<unit_id (unit)>>) as i loop
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

	research_collaborations(unit: STRING): LINKED_LIST[RESEARCH_COLLABORATION]
		require
			unit_exists (unit)
		local
			q_select, q_select2: SQLITE_QUERY_STATEMENT
			contacts: ARRAYED_LIST[STRING]
		do
			create Result.make
			create q_select.make ("SELECT id, country, institution, nature FROM research_collabs WHERE unit = ?1;", db)
			across q_select.execute_new_with_arguments (<<unit_id (unit)>>) as i loop
				create contacts.make (1)
				create q_select2.make ("SELECT name FROM collabs_contacts WHERE collab = ?1;", db)
				across q_select2.execute_new_with_arguments (<<i.item.integer_value(1)>>) as i2 loop
					contacts.sequence_put (i2.item.string_value (1))
				end
				Result.put_front (create {RESEARCH_COLLABORATION}.make (
					i.item.string_value (2),
					i.item.string_value (3),
					i.item.string_value (4),
					contacts
				))
			end
		end

	paper_awards_of_unit(unit: STRING): LINKED_LIST[PAPER_AWARD]
		require
			unit_exists (unit)
		local
			q_select, q_select2: SQLITE_QUERY_STATEMENT
			authors: ARRAYED_LIST[STRING]
		do
			create Result.make
			create q_select.make ("SELECT id, title, awarder, award_wording, date FROM paper_awards WHERE unit = ?1;", db)
			across q_select.execute_new_with_arguments (<<unit_id (unit)>>) as i loop
				create authors.make (1)
				create q_select2.make ("SELECT name FROM paper_authors WHERE paper = ?1;", db)
				across q_select2.execute_new_with_arguments (<<i.item.integer_64_value (1)>>) as i2 loop
					authors.sequence_put (i2.item.string_value (1))
				end
				Result.put_front (create {PAPER_AWARD}.make_ready (
					i.item.string_value (2),
					i.item.string_value (3),
					i.item.string_value (4),
					create {DATE}.make_by_days (i.item.integer_value (5)),
					authors
				))
			end
		end

	phds_of_unit(unit: STRING): LINKED_LIST[PHD_THESIS]
		require
			unit_exists (unit)
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create Result.make
			create q_select.make ("SELECT student, title, publication FROM phd_theses WHERE unit = ?1;", db)
			across q_select.execute_new_with_arguments (<<unit_id (unit)>>) as iter loop
				Result.put_front (create {PHD_THESIS}.make (iter.item.string_value (1), iter.item.string_value (2), iter.item.string_value (3)))
			end
		end

	patents_of_unit (unit: STRING): LINKED_LIST[PATENT]
		require
			unit_exists (unit)
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create Result.make
			create q_select.make ("SELECT title, country FROM patents WHERE unit = ?1;", db)
			across q_select.execute_new_with_arguments (<<unit_id (unit)>>) as iter loop
				Result.put_front (create {PATENT}.make (iter.item.string_value (1), iter.item.string_value (2)))
			end
		end

	ip_licences_of_unit (unit: STRING): LINKED_LIST[IP_LICENCE]
		require
			unit_exists (unit)
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create Result.make
			create q_select.make ("SELECT title FROM intellectual_propery_licences WHERE unit = ?1;", db)
			across q_select.execute_new_with_arguments (<<unit_id (unit)>>) as iter loop
				Result.put_front (create {IP_LICENCE}.make (iter.item.string_value (1)))
			end
		end

	academia_members_of_unit (unit: STRING): LINKED_LIST[MEMBERSHIP]
		require
			unit_exists (unit)
		local
			q_select: SQLITE_QUERY_STATEMENT
		do
			create Result.make
			create q_select.make ("SELECT name, organization, date FROM academia_memberships WHERE unit = ?1;", db)
			across q_select.execute_new_with_arguments (<<unit_id (unit)>>) as iter loop
				Result.put_front (create {MEMBERSHIP}.make_ready (
					iter.item.string_value (1),
					iter.item.string_value (2),
					create {DATE}.make_by_days (iter.item.integer_value (3))
				))
			end
		end
end
