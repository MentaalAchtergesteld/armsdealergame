@tool
class_name CountryPanel
extends BasePanel

const DEFAULT: Texture2D = preload("res://Assets/default.svg")

@export var country: Country: set = update_country;

@onready var flag: TextureRect = %Flag;
@onready var country_name: Label = %CountryName;
@onready var regime: LabeledField = %Regime;
@onready var stability: LabeledField = %Stability;
@onready var population: LabeledField = %Population;
@onready var funds: LabeledField = %Funds;
@onready var military_power: LabeledField = %MilitaryPower;
@onready var inventory_list: InventoryList = %InventoryList

func update_country(new_country: Country):
	if new_country == null:
		new_country = Country.new();
	
	country = new_country;
	if !is_inside_tree(): return;
	
	flag.texture = country.flag;
	country_name.text = country.name;
	
	match country.regime:
		Country.RegimeType.Democracy:
			regime.set_field("Democratic");
		Country.RegimeType.Autocracy:
			regime.set_field("Autocratic");
		Country.RegimeType.Oligarchy:
			regime.set_field("Oligarchic");
	
	stability.set_field(country.stability * 100);
	population.set_field(100);
	funds.set_field(country.funds);
	military_power.set_field(100);
	
	inventory_list.update_list(country.inventory);

func setup(data: Dictionary = {}):
	var new_country: Country = data.get("country");
	if new_country == null: return;
	update_country(new_country);

func get_close_data() -> Dictionary:
	return {country=country};
