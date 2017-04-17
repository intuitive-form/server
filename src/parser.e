class
	PARSER

feature	-- Fields

	parsed: BOOLEAN
		-- True if the parser is parsed without problems

	parsed_string_array: ARRAYED_LIST[STRING]
		-- Parsed array of strings

	keys: ARRAY[TUPLE[STRING, BOOLEAN]]
		-- Keys to for 'parse_json_value'

feature -- Queries

	parse_json_object(json_value: JSON_VALUE)
		-- Extracts values from 'json_value' by 'keys' into 'parsed_string_array'
		local
			i: INTEGER
		do
			parsed := True
			if
				attached {JSON_OBJECT} json_value as json_object
			then
				create parsed_string_array.make(1)
				from
					i := 1
				until
					not parsed or else
					i > keys.count or else
					not attached {STRING} keys.at(i).at(1) as string_value or else
					not attached {BOOLEAN} keys.at(i).at(2) as boolean_value
				loop
					if
						attached {JSON_STRING} json_object.item(string_value) as json_string
					then
						if
							not boolean_value and json_string.item.is_empty
						then
							parsed := False
						else
							parsed_string_array.sequence_put(json_string.item)
						end
					else
						if
							not boolean_value
						then
							parsed := False
						else
							parsed_string_array.sequence_put("")
						end
					end
					i := i + 1
				variant
					keys.count - i + 1
				end
			else
				parsed := False
			end
		ensure
			parsed implies parsed_string_array /= Void
			parsed implies across parsed_string_array as s all s.item /= Void end
			parsed implies (parsed_string_array.count = keys.count)
		end

	parse_json_array(json_value: JSON_VALUE)
		-- Extacts data from 'json_array' into 'parsed_string_value'
		local
			json_temp: ARRAYED_LIST[JSON_VALUE]
		do
			parsed := True
			if
				attached {JSON_ARRAY} json_value as json_array
			then
				create parsed_string_array.make(1)
				json_temp := json_array.array_representation
				across json_temp as iter
				loop
					if
						attached {JSON_STRING} iter.item as value and then
						not value.item.is_empty
					then
						parsed_string_array.sequence_put(value.item)
					end
				end
			else
				parsed := False
			end
		ensure
			parsed implies parsed_string_array /= Void
			parsed implies across parsed_string_array as s all s.item /= Void end
		end

end
