class_name CountryManager
extends Node

signal country_added(country: Country);
signal player_country_created(country: Country);

@export var base_funds: float = 0.0;
@export var base_inventory: Dictionary[Item, int] = {};

var player_country: Country;
var countries: Array[Country] = [];

func add_country(country: Country) -> bool:
	if countries.has(country):
		push_warning("Tried adding an already existing country: " + country.name);
		return false;
	
	country.funds += base_funds;
	
	for item in base_inventory.keys():
		var item_count = country.inventory.get(item, 0);
		country.inventory[item] = item_count + base_inventory[item];
	
	countries.append(country);
	country_added.emit(country);
	return true;

func create_player_country() -> void:
	var country = Country.create(
		"Player",
		"res://assets/flags/default.svg",
		Country.RegimeType.Democracy,
		1.0,
	);
	
	add_country(country);
	player_country = country;
	player_country_created.emit(player_country);
	EventBus.player_country_created.emit(player_country);

func _ready() -> void:
	create_player_country();
