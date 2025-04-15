@tool
class_name LabeledValue
extends HBoxContainer

@export var label: String = "Label":
	set(value):
		label = value;
		if is_inside_tree():
			$Label.text = label + ":";

@export var value: String = "Value":
	set(new_value):
		value = new_value;
		$Value.text = value;

func _ready() -> void:
	if is_inside_tree():
		$Label.text = label + ":";

func set_value(new_value) -> void:
	value = str(new_value);
