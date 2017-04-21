class
	MEMBERSHIP
inherit
	FIELD
	redefine
		default_create,
		make_from_json
	end

create
	default_create,
	make_from_json

feature -- Fields

	name: STRING
	organization: STRING
	date: DATE

feature {NONE} -- Constructors

	default_create
		-- Default constructor
		do
			key := "memberships"
			is_correct := False
			exception_reason := exception_reasons.at (1)
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		do
			key := "memberships"
			keys := <<["name", False],["organization", False],["date", False]>>
			parse_json_object (json_value)
			if
				not parsed
			then
				is_correct := False
				exception_reason := exception_reasons.at (2)
			else
				is_correct := True
				create exception_reason.make_empty
				make(parsed_string_array.at (1), parsed_string_array.at (2), parsed_string_array.at (3))
			end
		end

	make(p_name, p_organization, p_date: STRING)
		require
			fields_exist:	(p_name /= Void) and then (p_organization /= Void) and then
							(p_date /= Void)
		local
			checker: DATE_VALIDITY_CHECKER
		do
			if
				checker.date_valid (p_date, "yyyy-[0]mm-[0]dd")
			then
				name := p_name
				organization := p_organization
				create date.make_from_string(p_date, "yyyy-[0]mm-[0]dd")
			else
				is_correct := False
				exception_reason := exception_reasons.at (3)
			end
		end

invariant
	is_correct implies (name /= Void and then organization /= Void and then
						date /= Void)
end