class
	SERVICE_EXECUTION_TEST_SET

inherit
	EQA_TEST_SET

create
	default_create

feature

	test1
		local
			service: INTUITIVE_SERVER
		do
			create service.make_and_launch
		end

end

