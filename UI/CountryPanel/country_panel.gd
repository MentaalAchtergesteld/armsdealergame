@tool
class_name CountryPanel
extends BasePanel

const DEFAULT: Texture2D = preload("res://Assets/default.svg")

@onready var flag: TextureRect = %Flag;
@onready var country_name: Label = %CountryName;
@onready var regime: LabeledField = %Regime;
@onready var stability: LabeledField = %Stability;
@onready var population: LabeledField = %Population;
@onready var gdp: LabeledField = %GDP;
@onready var military_power: LabeledField = %MilitaryPower;

func update_country(country: Country):
	if country == null:
		country = Country.new();
	
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
	gdp.set_field(100);
	military_power.set_field(100);

func setup(data: Dictionary = {}):
	var new_country: Country = data.get("country");
	if new_country == null: return;
	update_country(new_country);
