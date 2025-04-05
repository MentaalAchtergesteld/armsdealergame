@tool
class_name LabeledField
extends HBoxContainer

@export var label: String = "Label":
	set(value):
		label = value;
		if is_inside_tree():
			$Label.text = label + ":";

func _ready() -> void:
	if is_inside_tree():
		$Label.text = label + ":";

func set_field(value) -> void:
	$Field.text = str(value);
