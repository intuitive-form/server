class
	PARSER

feature	-- Fields

	parsed: BOOLEAN
		-- True if the parser is parsed without problems

feature -- Queries

	parse_json_object(json_value: JSON_VALUE; a_keys: ARRAY[TUPLE[STRING, BOOLEAN]]): ARRAYED_LIST[STRING]
		-- Extracts values form 'json_object' by 'a_keys'
		local
			i: INTEGER
		do
			if
				parsed = True
			then
				parsed := False
			end

			if
				attached {JSON_OBJECT} json_value as json_object
			then
				create Result.make(1)
				from
					i := 1
				until
					i > a_keys.count
				loop
					if
						attached {STRING} a_keys.at(i).at(1) as string_value and then
						attached {BOOLEAN} a_keys.at(i).at(2) as boolean_value and then
						attached {JSON_STRING} json_object.item(string_value) as json_string
					then
						if
							boolean_value implies json_string.item.is_empty
						then
							parsed := True
							Result.sequence_put(json_string.item)
						end
					end
					i := i + 1
				end
			end
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
