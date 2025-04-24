extends Node2D

@onready var game_time: GameTime = $GameTime;
@onready var scheduler: Scheduler = $Scheduler;

@onready var date_label: Label = $CanvasLayer/VBoxContainer/Date
@onready var week_day: Label = $CanvasLayer/VBoxContainer/WeekDay
@onready var month: Label = $CanvasLayer/VBoxContainer/Month
@onready var total_days: Label = $CanvasLayer/VBoxContainer/TotalDays

func _on_day_passed(date: Dictionary) -> void:
	date_label.text = str(date["day"]) + " - " + str(date["month_index"]) + " - " + str(date["year"]);
	week_day.text = date["weekday_name"];
	month.text = date["month_name"];
	total_days.text = str(date["total_days"]);

func _ready() -> void:
	ResourceLocator.clear();
	ResourceLocator.register_resource(game_time);
	ResourceLocator.register_resource(scheduler);
	ResourceLocator.register_resource($GlobalMarket);
	
	game_time.day_passed.connect(_on_day_passed);
	game_time.resume();
