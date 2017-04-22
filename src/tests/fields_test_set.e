class
	FIELDS_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	field_unit_test1
			-- Correct unit creation
		local
			j_obj: JSON_OBJECT
			unit: UNIT
		do
			create j_obj.make_with_capacity (4)
			j_obj.put (create {JSON_STRING}.make_from_string ("Robotics Lab"), "unit_name")
			j_obj.put (create {JSON_STRING}.make_from_string ("Kolya Mavridis"), "head_name")
			j_obj.put (create {JSON_STRING}.make_from_string ("2016-01-01"), "reporting_period_start")
			j_obj.put (create {JSON_STRING}.make_from_string ("2016-12-31"), "reporting_period_end")
			create unit.make_from_json (j_obj)
			assert ("Unit created correctly", unit.is_correct)
		end


	field_unit_test2
			-- Incorrect unit creation
		local
			j_obj: JSON_OBJECT
			unit: UNIT
		do
			create j_obj.make_with_capacity (4)
			j_obj.put (create {JSON_STRING}.make_from_string ("Robotics Lab"), "unit_name")
			j_obj.put (create {JSON_STRING}.make_from_string ("Kolya Mavridis"), "head_name")
			j_obj.put (create {JSON_STRING}.make_from_string ("Today"), "reporting_period_start")
			j_obj.put (create {JSON_STRING}.make_from_string ("2016-12-31"), "reporting_period_end")
			create unit.make_from_json (j_obj)
			assert ("Unit created incorrectly", not unit.is_correct)
		end

end


