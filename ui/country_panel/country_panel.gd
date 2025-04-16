@tool
class_name CountryPanel
extends BasePanel

@onready var country_flag: TextureRect = %CountryFlag
@onready var country_name: Label = %CountryName
@onready var regime_label: LabeledValue = %Regime
@onready var stability_label: LabeledValue = %Stability
@onready var funds_label: LabeledValue = %Funds
@onready var inventory_items: VBoxContainer = %InventoryItems

var country: Country;

func _on_flag_changed(flag: Texture2D) -> void:
	country_flag.texture = flag;

func _on_name_changed(name: String) -> void:
	country_name.text = name;

func _on_regime_changed(regime: Country.RegimeType) -> void:
	regime_label.set_value(
		Utils.enum_value_to_string(Country.RegimeType, regime)
	);

func _on_stability_changed(stability: float) -> void:
	stability_label.set_value(stability);

func _on_funds_changed(funds: float) -> void:
	funds_label.set_value(funds);

func _on_inventory_changed(inventory: Dictionary[Item, int]) -> void:
	for child in inventory_items.get_children():
		child.queue_free();
	
	for item in inventory:
		var label = Label.new();
		var quantity = inventory[item];
		label.text = str(quantity) + "x " + item.plural;
		inventory_items.add_child(label);

func update_all_data():
	if country == null: return;
	_on_flag_changed(country.flag);
	_on_name_changed(country.name);
	_on_regime_changed(country.regime);
	_on_stability_changed(country.stability);
	_on_funds_changed(country.funds);
	_on_inventory_changed(country.inventory);

func disconnect_signals() -> void:
	country.flag_changed.disconnect(_on_flag_changed);
	country.name_changed.disconnect(_on_name_changed);
	country.regime_changed.disconnect(_on_regime_changed);
	country.stability_changed.disconnect(_on_stability_changed);
	country.funds_changed.disconnect(_on_funds_changed);
	country.inventory_changed.disconnect(_on_inventory_changed);

func connect_signals() -> void:
	country.flag_changed.connect(_on_flag_changed);
	country.name_changed.connect(_on_name_changed);
	country.regime_changed.connect(_on_regime_changed);
	country.stability_changed.connect(_on_stability_changed);
	country.funds_changed.connect(_on_funds_changed);
	country.inventory_changed.connect(_on_inventory_changed);

func setup(data) -> void:
	if country:
		disconnect_signals();
	
	country = data.get("country");
	if country:
		connect_signals();
	
	update_all_data();
