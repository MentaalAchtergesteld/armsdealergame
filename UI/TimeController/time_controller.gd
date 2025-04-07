@tool
extends HBoxContainer

@onready var time_speed: ProgressBar = %TimeSpeed
@onready var current_time: Label = %CurrentTime

func _ready() -> void:
	time_speed.self_modulate = Color.from_hsv(0, 100, 100);
	current_time.text = "%.2f" % GameTime.current_time;
	
	GameTime.time_changed.connect(_on_time_changed);
	GameTime.time_paused.connect(_on_time_paused);
	GameTime.time_resumed.connect(_on_time_resumed);

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_time"):
		if GameTime.paused:
			GameTime.resume();
		else:
			GameTime.pause();
	
	if event.is_action_pressed("increase_time_speed"):
		time_speed.value += 1;
	elif event.is_action_pressed("decrease_time_speed"):
		time_speed.value -= 1;

func _on_time_changed(new_time: float) -> void:
	current_time.text = "%.2f" % new_time

func _on_time_paused() -> void:
	time_speed.self_modulate = Color.from_hsv(0.0, 1.0, 1.0)

func _on_time_resumed() -> void:
	time_speed.self_modulate = Color.from_hsv(0.33, 1.0, 1.0)
 
func _on_decrease_speed_pressed() -> void:
	time_speed.value -= 1;

func _on_increase_speed_pressed() -> void:
	time_speed.value += 1;

func _on_pause_time_pressed() -> void:
	GameTime.pause();

func _on_resume_time_pressed() -> void:
	GameTime.resume();

func _on_time_speed_value_changed(value: float) -> void:
	GameTime.time_speed = pow(value, 2);
