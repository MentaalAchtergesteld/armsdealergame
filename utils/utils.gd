class_name Utils
extends Node

static func enum_value_to_string(enum_dict: Dictionary, value: int) -> String:
	for key in enum_dict.keys():
		if enum_dict[key] == value:
			return str(key)
	return "Unknown"
