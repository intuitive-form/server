class
	DB_INSERTER

create
	make

feature {NONE}

	db: SQLITE_DATABASE

	q_unit, q_course, q_exam, q_supervision, q_report, q_phd, q_grant: SQLITE_INSERT_STATEMENT
	q_research, q_res_personnel, q_res_extra_personnel, q_res_collab, q_res_collab_contact: SQLITE_INSERT_STATEMENT
	q_conf_pub, q_conf_pub_author, q_journal_pub, q_journal_pub_author: SQLITE_INSERT_STATEMENT
	q_patent, q_ip_licence: SQLITE_INSERT_STATEMENT
	q_paper_award, q_paper_author, q_membership, q_prize: SQLITE_INSERT_STATEMENT

	make (p_handler: DB_HANDLER)
		require
			p_handler /= Void
			p_handler.db /= Void
			p_handler.db.is_writable
		do
			handler := p_handler
			db := handler.db
			create q_unit.make ("INSERT INTO units (name, head, start_date, end_date, misc_info) VALUES (?1, ?2, ?3, ?4, NULL);", db)
			create q_course.make ("INSERT INTO courses (unit, name, semester, level, students, start_date, end_date) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7);", db)
			create q_exam.make ("INSERT INTO exams (unit, course, type, students, date) VALUES (?1, ?2, ?3, ?4, ?5);", db)
			create q_supervision.make ("INSERT INTO supervisions (unit, student, work) VALUES (?1, ?2, ?3);", db);
			create q_report.make ("INSERT INTO reports (unit, student, title, publication) VALUES (?1, ?2, ?3, ?4);", db);
			create q_phd.make ("INSERT INTO phd_theses (unit, student, title, publication) VALUES (?1, ?2, ?3, ?4);", db);
			create q_grant.make ("INSERT INTO grants (unit, title, granter, start_date, end_date, continuing, amount) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7);", db);
			create q_research.make ("INSERT INTO researches (unit, title, start_date, end_date, financing) VALUES (?1, ?2, ?3, ?4, ?5);", db);
			create q_res_personnel.make ("INSERT INTO research_personnel (research, name) VALUES (?1, ?2);", db);
			create q_res_extra_personnel.make ("INSERT INTO research_extra_personnel (research, name) VALUES (?1, ?2);", db);
			create q_res_collab.make ("INSERT INTO research_collabs (unit, country, institution, nature) VALUES (?1, ?2, ?3, ?4);", db);
			create q_res_collab_contact.make ("INSERT INTO collabs_contacts (collab, name) VALUES (?1, ?2);", db);
			create q_conf_pub.make ("INSERT INTO conference_publications (unit, title, date) VALUES (?1, ?2, ?3);", db);
			create q_conf_pub_author.make ("INSERT INTO conference_publications_authors (conf_pub, name) VALUES (?1, ?2);", db);
			create q_journal_pub.make ("INSERT INTO journal_publications (unit, title, date) VALUES (?1, ?2, ?3);", db);
			create q_journal_pub_author.make ("INSERT INTO journal_publications_authors (journal_pub, name) VALUES (?1, ?2);", db);
			create q_patent.make ("INSERT INTO patents (unit, title, country) VALUES (?1, ?2, ?3);", db)
			create q_ip_licence.make ("INSERT INTO intellectual_propery_licences (unit, title) VALUES (?1, ?2);", db)
			create q_paper_award.make ("INSERT INTO paper_awards (unit, title, awarder, award_wording, date) VALUES (?1, ?2, ?3, ?4, ?5);", db)
			create q_paper_author.make ("INSERT INTO paper_authors (paper, name) VALUES (?1, ?2);", db)
			create q_membership.make ("INSERT INTO academia_memberships (unit, name, organization, date) VALUES (?1, ?2, ?3, ?4);", db)
			create q_prize.make ("INSERT INTO prizes (unit, recipient, name, granter, date) VALUES (?1, ?2, ?3, ?4, ?5);", db)

		end

feature {DB_HANDLER}
	handler: DB_HANDLER
	last_added_id: INTEGER_64

	insert_unit(p_unit: UNIT)
		require
			not handler.selector.unit_exists(p_unit.name)
		do
			q_unit.execute_with_arguments (<<p_unit.name, p_unit.head, p_unit.start_date.days, p_unit.end_date.days>>)
			last_added_id := q_unit.last_row_id
		ensure
			handler.selector.unit_exists(p_unit.name)
		end

	insert_course(p_course: COURSE; unit_id: INTEGER_64)
		require
			does_not_exist: handler.selector.get_course_id(p_course.name, p_course.semester) = -1
		do
			q_course.execute_with_arguments (<<unit_id, p_course.name, p_course.semester, p_course.level, p_course.students, p_course.start_date.days, p_course.end_date.days>>)
			last_added_id := q_course.last_row_id
		ensure
			exists: handler.selector.get_course_id(p_course.name, p_course.semester) /= -1
		end

	insert_exam(p_exam: EXAM; unit_id: INTEGER_64)
		require
			course_exists: handler.selector.get_course_id(p_exam.course_name, p_exam.semester) /= -1
		do
			q_exam.execute_with_arguments (<<unit_id, handler.selector.get_course_id(p_exam.course_name, p_exam.semester), p_exam.kind, p_exam.students, p_exam.date.days>>)
			last_added_id := q_exam.last_row_id
		end

	insert_supervision(p_student: STUDENT; unit_id: INTEGER_64)
		do
			q_supervision.execute_with_arguments (<<unit_id, p_student.name, p_student.nature_of_work>>)
			last_added_id := q_supervision.last_row_id
		end

	insert_report(p_rep: STUDENT_REPORT; unit_id: INTEGER_64)
		do
			q_report.execute_with_arguments (<<unit_id, p_rep.student_name, p_rep.title, p_rep.plans>>)
			last_added_id := q_report.last_row_id
		end

	insert_phd_thesis(p_phd: PHD_THESIS; unit_id: INTEGER_64)
		do
			q_phd.execute_with_arguments (<<unit_id, p_phd.student_name, p_phd.title, p_phd.plans>>)
			last_added_id := q_phd.last_row_id
		end

	insert_grant(p_grant: GRANT; unit_id: INTEGER_64)
		do
			q_grant.execute_with_arguments (<<unit_id, p_grant.title, p_grant.agency, p_grant.period_start.days, p_grant.period_end.days, p_grant.continuation, p_grant.amount>>)
			last_added_id := q_grant.last_row_id
		end

	insert_research(p_research: RESEARCH_PROJECT; unit_id: INTEGER_64)
		do
			q_research.execute_with_arguments (<<unit_id, p_research.title, p_research.date_start.days, p_research.date_end.days, p_research.sources_of_financing>>)
			last_added_id := q_research.last_row_id
			across p_research.personnel as p loop
				q_res_personnel.execute_with_arguments (<<last_added_id, p.item>>)
			end
			across p_research.extra_personnel as p loop
				q_res_extra_personnel.execute_with_arguments (<<last_added_id, p.item>>)
			end
		end

	insert_research_collab(p_collab: RESEARCH_COLLABORATION; unit_id: INTEGER_64)
		do
			q_res_collab.execute_with_arguments (<<unit_id, p_collab.institution_country, p_collab.institution_name, p_collab.nature>>)
			last_added_id := q_res_collab.last_row_id
			across p_collab.contracts as c loop
				q_res_collab_contact.execute_with_arguments (<<last_added_id, c.item>>)
			end
		end

	insert_conference_pub(p_pub: PUBLICATION; unit_id: INTEGER_64)
		do
			q_conf_pub.execute_with_arguments (<<unit_id, p_pub.title, p_pub.date.days>>)
			last_added_id := q_conf_pub.last_row_id
			across p_pub.authors as a loop
				q_conf_pub_author.execute_with_arguments (<<last_added_id, a.item>>)
			end
		end

	insert_journal_pub(p_pub: PUBLICATION; unit_id: INTEGER_64)
		do
			q_journal_pub.execute_with_arguments (<<unit_id, p_pub.title, p_pub.date.days>>)
			last_added_id := q_journal_pub.last_row_id
			across p_pub.authors as a loop
				q_journal_pub_author.execute_with_arguments (<<last_added_id, a.item>>)
			end
		end

	insert_patent(p_patent: PATENT; unit_id: INTEGER_64)
		do
			q_patent.execute_with_arguments (<<unit_id, p_patent.title, p_patent.country>>)
			last_added_id := q_patent.last_row_id
		end

	insert_ip_licence(p_licence: IP_LICENCE; unit_id: INTEGER_64)
		do
			q_ip_licence.execute_with_arguments (<<unit_id, p_licence.title>>)
			last_added_id := q_ip_licence.last_row_id
		end

	insert_paper_award(p_paper: PAPER_AWARD; unit_id: INTEGER_64)
		do
			q_paper_award.execute_with_arguments (<<unit_id, p_paper.title, p_paper.awarder, p_paper.award_wording, p_paper.date.days>>)
			last_added_id := q_paper_award.last_row_id
			across p_paper.authors as a loop
				q_paper_author.execute_with_arguments (<<last_added_id, a.item>>)
			end
		end
end
