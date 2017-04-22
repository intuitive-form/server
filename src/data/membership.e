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
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		do
			key := "memberships"
			keys := <<["name", False],["organization", False],["date", False]>>
			if
				attached {JSON_OBJECT} json_value as json_object
			then
				parse_json_object (json_object)
				is_correct := parsed
				if is_correct then
					make (
						parsed_string_array.at (1),
						parsed_string_array.at (2),
						parsed_string_array.at (3)
					)
				end
			else
				is_correct := False
			end
		end

	make(p_name, p_organization, p_date: STRING)
		require
			fields_exist:	(p_name /= Void) and then (p_organization /= Void) and then
							(p_date /= Void)
		local
			checker: DATE_VALIDITY_CHECKER
		do
			create checker
			is_correct := checker.date_valid (p_date, "yyyy-[0]mm-[0]dd")
			if is_correct then
				name := p_name
				organization := p_organization
				create date.make_from_string(p_date, "yyyy-[0]mm-[0]dd")
			end
		end

invariant
	is_correct implies (name /= Void and then organization /= Void and then
						date /= Void)
end
