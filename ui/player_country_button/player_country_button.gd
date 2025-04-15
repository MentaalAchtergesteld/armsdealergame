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

var open: bool = false;

func update_flag(flag: Texture2D) -> void:
	texture = flag;

func _on_player_country_created(country: Country) -> void:
	player_country = country;

func _on_panel_closed(panel: BasePanel) -> void:
	if not panel is CountryPanel: return;
	if panel.country != player_country: return;
	open = false;

func _ready() -> void:
	UIEventBus.closed_panel.connect(_on_panel_closed);
	EventBus.player_country_created.connect(_on_player_country_created);

func _on_button_pressed() -> void:
	open = !open;
	
	if open:
		UIEventBus.open_panel.emit("country", {country=player_country});
	else:
		UIEventBus.close_panel.emit("country");
