class
	PARSER

feature	-- Fields

	parsed: BOOLEAN
		-- True if the parser is parsed without problems

	parsed_string_array: ARRAYED_LIST[STRING]

feature -- Queries

	parse_json_object(json_value: JSON_VALUE; a_keys: ARRAY[TUPLE[STRING, BOOLEAN]])
		-- Extracts values form 'json_object' by 'a_keys'
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
					i > a_keys.count or else
					not attached {STRING} a_keys.at(i).at(1) as string_value or else
					not attached {BOOLEAN} a_keys.at(i).at(2) as boolean_value
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
						if not boolean_value then
							parsed := False
						else
							parsed_string_array.sequence_put("")
						end
					end
					i := i + 1
				variant
					a_keys.count - i + 1
				end
			else
				parsed := False
			end
		ensure
			parsed implies parsed_string_array /= Void
			parsed implies across parsed_string_array as s all s.item /= Void end
			parsed implies (parsed_string_array.count = a_keys.count)
		end

	parse_json_array(json_value: JSON_VALUE): ARRAYED_LIST[STRING]
		-- Extacts data from 'json_array'
		local
			json_temp: ARRAYED_LIST[JSON_VALUE]
		do
			if
				parsed = True
			then
				parsed := False
			end

			create Result.make(1)
			if
				attached {JSON_ARRAY} json_value as json_array
			then
				json_temp := json_array.array_representation
				across json_temp as iter
				loop
					if
						attached {JSON_STRING} iter.item as value and then
						not value.item.is_empty
					then
						Result.sequence_put(value.item)
					end
				end
				parsed := True
			end
		end

	parse_json_arrays(json_value: JSON_VALUE; a_keys: ARRAY[STRING]): ARRAYED_LIST[ARRAYED_LIST[STRING]]
		-- Extracts all arrays from 'json_valued' by 'a_keys'
		local
			i: INTEGER
			values: ARRAYED_LIST[STRING]
		do
			create Result.make(1)
			if
				attached {JSON_OBJECT} json_value as json_arrays
			then
				from
					i := 1
				until
					i > a_keys.count
				loop
					Result.sequence_put (parse_json_array (json_arrays.item (a_keys.at (i))))
					i := i + 1
				end
			end
		end

end
