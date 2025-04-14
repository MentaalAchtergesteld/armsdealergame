class_name PlayerCountryButton
extends Button

@onready var texture_rect: TextureRect = $TextureRect;

var player_country: Country;

func update_country_data() -> void:
	texture_rect.texture = player_country.flag;

func _on_button_pressed() -> void:
	UIEventBus.toggle_panel.emit("country", {country=player_country});

func _on_update_player_country(country: Country) -> void:
	player_country = country;
	update_country_data();

func _on_update_country_data(country: Country) -> void:
	if country != player_country: return;
	update_country_data();

func _ready() -> void:
	UIEventBus.update_player_country.connect(_on_update_player_country);
	UIEventBus.update_country_data.connect(_on_update_country_data);
