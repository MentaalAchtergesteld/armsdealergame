@tool
class_name TimeControls
extends PanelContainer

@onready var time_speed: ProgressBar = %TimeSpeed
@onready var time_label: Label = %TimeLabel

@export var base_speed: float = 1.0;
@export var min_speed_multiplier: float = 1:
	set(value):
		min_speed_multiplier = value;
		time_speed.min_value = min_speed_multiplier;
@export var max_speed_multiplier: float = 5:
	set(value):
		max_speed_multiplier = value;
		time_speed.max_value = max_speed_multiplier;

@export var paused: bool = true:
	set(value):
		paused = value;
		if Engine.is_editor_hint():
			if paused:
				_on_time_paused();
			else:
				_on_time_resumed();

@export_color_no_alpha var paused_color: Color:
	set(value):
		paused_color = value;
		if is_inside_tree():
			time_speed.self_modulate = paused_color;
@export_color_no_alpha var resumed_color: Color;

func _on_time_updated(time: int) -> void:
	time_label.text = str(int(time));

func _on_time_speed_changed(speed: float) -> void:
	time_speed.value = speed/base_speed;

func _on_time_paused() -> void:
	time_speed.self_modulate = paused_color;

func _on_time_resumed() -> void:
	time_speed.self_modulate = resumed_color;

func _ready() -> void:
	UIEventBus.time_changed.connect(_on_time_updated);
	UIEventBus.time_speed_changed.connect(_on_time_speed_changed);
	UIEventBus.time_paused.connect(_on_time_paused);
	UIEventBus.time_resumed.connect(_on_time_resumed);

func _on_decrease_speed_pressed() -> void:
	if time_speed.value > min_speed_multiplier:
		EventBus.set_time_speed.emit(base_speed * (time_speed.value - 1));

func _on_increase_speed_pressed() -> void:
	if time_speed.value < max_speed_multiplier:
		EventBus.set_time_speed.emit(base_speed * (time_speed.value + 1));

func _on_pause_resume_pressed() -> void:
	paused = !paused;
	
	if paused:
		EventBus.pause_time.emit();
	else:
		EventBus.resume_time.emit();
