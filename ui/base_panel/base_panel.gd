@tool
class_name BasePanel
extends PanelContainer

signal panel_opened;
signal panel_closed;

@export_tool_button("Open") var open_button = open;
@export_tool_button("Close") var close_button = close;

@export var panel_name: String = "base_panel";

@onready var animation_player: AnimationPlayer = $AnimationPlayer;

func _ready() -> void:
	if Engine.is_editor_hint(): return;
	animation_player.play("RESET");

# Function to overwrite for inherited scenes.
func setup(data: Dictionary):
	pass

func open(data: Dictionary = {}):
	setup(data);
	animation_player.play("open");
	panel_opened.emit();

func close():
	animation_player.play("close");
	panel_closed.emit();

func _on_close_button_pressed() -> void:
	close();
