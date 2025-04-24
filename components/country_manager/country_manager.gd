class_name CountryManager
extends Node

@export var resource_locator: ResourceLocator;
@export var game_time: GameTime;
@export var countries: Array[Country] = [];

func _on_day_passed(date: Dictionary) -> void:
	for country in countries:
		country.process();

func _ready() -> void:
	if game_time == null:
		game_time = resource_locator.get_resource(GameTime);
	game_time.day_passed.connect(_on_day_passed);
	
	for country in countries:
		country.setup(resource_locator);
