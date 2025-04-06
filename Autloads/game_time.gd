extends Node

signal time_changed(current_time: float);
signal time_speed_changed(new_speed: float);
signal time_started;
signal time_paused;
signal time_resumed;

var paused: bool = true;
var current_time: float = 0.0:
	set(value):
		current_time = value;
		time_changed.emit(current_time);
var time_speed: float = 1.0:
	set(value):
		time_speed = value;
		time_speed_changed.emit(time_speed);

var alarms: Array[Dictionary] = [];

func _process(delta: float) -> void:
	if paused: return;
	current_time += delta * time_speed;
	
	for alarm in alarms.duplicate():
		if current_time >= alarm["time"]:
			alarm["callback"].call();
			alarms.erase(alarm);

func start(from: float = 0.0) -> void:
	current_time = from;
	paused = false;
	time_started.emit();

func resume() -> void:
	if paused:
		paused = false;
		time_resumed.emit();

func pause() -> void:
	if !paused:
		paused = true;
		time_paused.emit();

func add_alarm(time: float, callback: Callable) -> bool:
	if time < current_time: return false;
	
	var alarm = {
		"time": time,
		"callback": callback
	};
	
	alarms.append(alarm);
	
	return true;
