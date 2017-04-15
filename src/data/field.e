class
	FIELD

create
	make_from_json

feature	-- Fields

	key: STRING
		-- Key of the field at the page

	is_correct: BOOLEAN
		-- If the object parsed properly

	exception_reason: STRING
		-- Reason of exception

	exception_reasons: ARRAY[STRING]
		-- Reasons of exceptions
		once
			 Result := << "json is not parsed", "values and keys are not correlated", "some values are not valid">>
		end

feature {NONE} -- Constructors

	make_from_json(json_value: JSON_VALUE)
		-- Constructs field from json_value
		do
		end

invariant
	is_correct = exception_reason.is_empty
end
