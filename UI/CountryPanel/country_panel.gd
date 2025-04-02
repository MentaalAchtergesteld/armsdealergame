@tool
class_name CountryPanel
extends PanelContainer

@export_tool_button("Close") var close_panel_button = close;
@export_tool_button("Open") var open_panel_button = open;

@export var country: Country:
	set(value):
		if is_inside_tree():
			country = value;
			update_panel();

@onready var flag_texture: TextureRect = %Flag;
@onready var name_label: Label = %Name;
@onready var regime_type_label: Label = %RegimeType;
@onready var stability_label: Label = %Stability;

@onready var animation_player: AnimationPlayer = $AnimationPlayer;

var is_open = false;

func close():
	if is_open:
		animation_player.play("close");
		is_open = false;

func open():
	if not is_open:
		animation_player.play("open");
		is_open = true;

func update_panel():
	if country == null:
		flag_texture.texture = null;
		name_label.text = "Country";
		regime_type_label.text = "Regime Type";
		stability_label.text = "Stability: 50.0";
	else:
		flag_texture.texture = country.flag;
		name_label.text = country.name;
		
		match country.regime:
			Country.RegimeType.Democracy:
				regime_type_label.text = "Democracy";
			Country.RegimeType.Autocracy:
				regime_type_label.text = "Autocracy";
			Country.RegimeType.Oligarchy:
				regime_type_label.text = "Oligarchy";
		
		stability_label.text = "Stability: " + str(country.stability*100);

func _ready() -> void:
	if Engine.is_editor_hint(): return;
	
	animation_player.play("RESET");
	EventBus.ui_open_country_panel.connect(_on_open);
	EventBus.ui_close_country_panel.connect(_on_close);
	update_panel();

func _on_open(new_country: Country):
	country = new_country;
	open();

func _on_close():
	close();

func _on_close_pressed() -> void:
	close();
