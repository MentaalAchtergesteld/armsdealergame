class_name GameTime
extends Node

var time: float = 0;
var time_speed: float = 1.0;
var paused: bool = true;

func _on_set_time(time_: float) -> void:
	time = time_;
	UIEventBus.time_updated.emit(time);

func _on_set_time_speed(speed: float) -> void:
	time_speed = speed;
	UIEventBus.time_speed_changed.emit(time_speed);

func _on_pause_time() -> void:
	paused = true;
	UIEventBus.time_paused.emit();

func _on_resume_time() -> void:
	paused = false;
	UIEventBus.time_resumed.emit();

func _ready() -> void:
	EventBus.set_time.connect(_on_set_time);
	EventBus.set_time_speed.connect(_on_set_time_speed);
	EventBus.pause_time.connect(_on_pause_time);
	EventBus.resume_time.connect(_on_resume_time);

func _process(delta: float) -> void:
	if paused: return;
	time += delta * time_speed;
	UIEventBus.time_changed.emit(time);
	EventBus.time_changed.emit(time);
