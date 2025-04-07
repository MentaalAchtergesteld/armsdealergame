class_name PlayerCountryButton
extends TextureRect

var is_open: bool = false;

func _ready() -> void:
	UIEventBus.closed_panel.connect(_on_closed_panel);
	texture = CountryManager.player_country.flag

func _on_closed_panel(panel_name: String, data: Dictionary):
	if data.get("country") == CountryManager.player_country:
		is_open = false;


func _on_button_pressed() -> void:
	is_open = !is_open;
	
	if is_open:
		UIEventBus.open_panel.emit("country", {country=CountryManager.player_country});
	else:
		UIEventBus.close_panel.emit("country");
