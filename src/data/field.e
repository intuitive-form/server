class
	FIELD

inherit
	PARSER

create
	make_from_json

feature	-- Fields

	key: STRING
		-- Key of the field at the page

	is_correct: BOOLEAN
		-- If the object parsed properly

feature {NONE} -- Constructors

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from json_value
		do
		end

end
