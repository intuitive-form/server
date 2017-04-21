class
	CONFERENCE_PUBLICATION
inherit
	PUBLICATION
	redefine
		default_create,
		make_from_json
	end

create
	default_create,
	make_from_json

feature {NONE} -- Constructors

	default_create
		-- Default constructor
		do
			Precursor
			key := "conference_publications"
		end

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from 'json_value' by 'keys'
		do
			Precursor(json_value)
			key := "conference_publications"
		end

end
