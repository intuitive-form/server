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
