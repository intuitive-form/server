class
	CHECKER

feature -- Queries

	valid_correlation(values: ARRAYED_LIST[STRING]; keys: ARRAY[TUPLE[STRING, BOOLEAN]]): BOOLEAN
		-- Returns true if 'values' and 'keys' are correlated
		do
			Result := values.count <= keys.count and values.count >= (keys.count - number_of_non_compulsory_fields (keys))
		end

feature {NONE} -- Private queries

	number_of_non_compulsory_fields(keys: ARRAY[TUPLE[STRING, BOOLEAN]]): INTEGER
		-- Returns number of fields in 'keys' with true parameter
		local
			i: INTEGER
		do
			from
				i := 1
				Result := 0
			until
				i > keys.count
			loop
				if
					attached {BOOLEAN} keys.at(i).at(2) as parameter and then
					parameter
				then
					Result := Result + 1
				end
				i := i + 1
			end
		end
end
