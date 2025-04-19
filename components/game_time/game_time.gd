class_name GameTime
extends Node

signal time_changed(time: float);
signal speed_changed(speed: float);
signal paused;
signal resumed;

var time: float = 0:
	set(value):
		time = value;
		time_changed.emit(time);
var speed: float = 1.0:
	set(value):
		speed = value;
		speed_changed.emit(speed);
var is_paused: bool = true:
	set(value):
		if is_paused == value: return;
		is_paused = value;
		if is_paused:
			paused.emit();
		else:
			resumed.emit();

var alarms: Array[Dictionary] = [];

func add_alarm(time: float, callback: Callable) -> void:
	alarms.append({time=time,callback=callback});

func _process(delta: float) -> void:
	if is_paused: return;
	time += delta * speed;
	alarms = alarms.filter(func(alarm):
		if alarm.time < time:
			alarm.callback.call();
			return false;
		else:
			return true;
	);
