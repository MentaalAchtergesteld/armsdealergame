class_name PlayerCountryButton
extends TextureRect

@export var player_country: Country:
	set(value):
		if player_country and player_country.flag_changed:
			player_country.flag_changed.disconnect(update_flag);
		
		player_country = value;
		
		if player_country:
			player_country.flag_changed.connect(update_flag);
			update_flag(player_country.flag);

func update_flag(flag: Texture2D) -> void:
	texture = flag;

func _on_player_country_created(country: Country) -> void:
	player_country = country;

func _ready() -> void:
	EventBus.player_country_created.connect(_on_player_country_created);

func _on_button_pressed() -> void:
	UIEventBus.toggle_panel.emit("country", {country=player_country});
