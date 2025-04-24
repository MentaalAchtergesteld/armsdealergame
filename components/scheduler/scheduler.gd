class_name Scheduler
extends Node

@export var game_time: GameTime;

class ScheduledEvent:
	var conditions: Dictionary;
	var callback: Callable;
	
	func _init(conditions: Dictionary, callback: Callable) -> void:
		self.conditions = conditions;
		self.callback = callback;

var scheduled_events: Array[ScheduledEvent] = [];

func schedule(conditions: Dictionary, callback: Callable) -> ScheduledEvent:
	var event = ScheduledEvent.new(conditions, callback);
	scheduled_events.append(event);
	return event;

func schedule_in_days(days: int, callback: Callable) -> ScheduledEvent:
	var day = game_time.total_days + days;
	return schedule({"total_days": day}, callback);

func schedule_in_weeks(weeks: int, callback: Callable) -> ScheduledEvent:
	var week = game_time.total_weeks + weeks;
	return schedule({"total_weeks": week}, callback);

func schedule_in_months(months: int, callback: Callable) -> ScheduledEvent:
	var month = game_time.total_months + months;
	return schedule({"total_months": month}, callback);

func schedule_in_years(years: int, callback: Callable) -> ScheduledEvent:
	var year = game_time.year + years;
	return schedule({"year": year}, callback);

func cancel(event: ScheduledEvent) -> void:
	scheduled_events.erase(event);

func do_conditions_pass(date: Dictionary, conditions: Dictionary) -> bool:
	for key in conditions.keys():
		if not date.has(key): return false;
		if date[key] != conditions[key]: return false;
	
	return true;

func _on_day_passed(date: Dictionary) -> void:
	for i in range(scheduled_events.size()-1, -1, -1):
		if do_conditions_pass(date, scheduled_events[i].conditions):
			scheduled_events[i].callback.call();
			scheduled_events.remove_at(i);

func _ready() -> void:
	game_time.day_passed.connect(_on_day_passed);
