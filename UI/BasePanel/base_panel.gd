@tool
class_name BasePanel
extends PanelContainer

@export_tool_button("Close") var close_panel_button = close;
@export_tool_button("Open") var open_panel_button = func(): open({});

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_open = false;

# Should be overwritten by inherited classes for UI setup.
func setup(data: Dictionary = {}) -> void:
	pass

func toggle(data: Dictionary = {}):
	if is_open:
		close();
	else:
		open(data);

func close():
	if is_open:
		animation_player.play("close");
		is_open = false;

func open(data: Dictionary = {}):
	if not is_open:
		setup(data);
		animation_player.play("open");
		is_open = true;

func _on_close_pressed() -> void:
	close();

func _on_ready() -> void:
	animation_player.play("close");
	is_open = false;
