class_name GameTime
extends Node

signal day_passed(date: Dictionary[String, int]);
signal week_passed(week_of_year: int, total_weeks: int);
signal month_passed(month_index: int, total_months: int, month: Month);
signal year_passed(year: int);

signal paused;
signal resumed;

@export var seconds_per_day: float = 1.0;
@export var speed_multiplier: float = 1.0;

@export var calender: Calendar;

@export var is_paused: bool = true:
	set(value):
		if is_paused == value: return;
		
		is_paused = value;
		if is_paused:
			paused.emit();
		else:
			resumed.emit();

var accumulated_time: float = 0.0;
var total_days: int = 0;
var total_weeks: int = 0;
var total_months: int = 0;

var day_in_month: int = 0;
var month_index: int = 0;
var year: int = 0;

var weekday_index: int = 0;
var week_of_year: int = 0;
var days_since_week_start: int = 0;

func current_date() -> Dictionary:
	return {
		"year": year,
		"month_index": month_index,
		"month_name": calender.months[month_index].name,
		"day": day_in_month,
		"weekday_index": weekday_index,
		"weekday_name": calender.week_days[weekday_index],
		"week_of_year": week_of_year,
		
		"total_days": total_days,
		"total_weeks": total_weeks,
		"total_months": total_months,
	}

func advance_year() -> void:
	year += 1;
	week_of_year = 0;
	
	year_passed.emit(year);

func advance_month() -> void:
	if day_in_month >= calender.months[month_index].days:
		day_in_month = 0;
		
		total_months += 1;
		month_index += 1;
		if month_index >= calender.months.size():
			month_index = 0;
			advance_year();
	
	month_passed.emit(month_index, total_months, calender.months[month_index]);

func advance_week() -> void:
	if calender.week_days.is_empty(): return;
	
	weekday_index += 1;
	if weekday_index >= calender.week_days.size():
		weekday_index = 0;
		total_weeks += 1;
		week_of_year += 1;
	
	week_passed.emit(week_of_year, total_weeks);

func advance_day() -> void:
	total_days += 1;
	advance_week();
	
	day_in_month += 1;
	advance_month();
	
	day_passed.emit(current_date());

func _process(delta: float) -> void:
	if is_paused: return;
	accumulated_time += delta * speed_multiplier;
	
	while accumulated_time >= seconds_per_day:
		accumulated_time -= seconds_per_day;
		advance_day();

func pause():
	is_paused = true;

func resume():
	is_paused = false;

func toggle():
	is_paused = !is_paused;
