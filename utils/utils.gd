class_name Utils
extends RefCounted

static func enum_value_to_string(enum_dict: Dictionary, value: int) -> String:
	for key in enum_dict.keys():
		if enum_dict[key] == value:
			return str(key)
	return "Unknown"

static func normalize_dictionary(dictionary: Dictionary) -> Dictionary:
	var max_val := 0.0;
	for v in dictionary.values():
		max_val = max(max_val, v);
	
	var normalized := {};
	for key in dictionary.keys():
		if max_val > 0.0:
			normalized[key] = dictionary[key] / max_val;
		else:
			normalized[key] = 0.0;
	
	return normalized;

static func truncate(value: float, decimals: int) -> float:
	var factor = pow(10, decimals);
	return floor(value * factor) / factor;
