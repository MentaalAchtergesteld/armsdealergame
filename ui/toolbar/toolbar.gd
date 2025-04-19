class_name Toolbar
extends PanelContainer

var country_manager: CountryManager;
var global_market: GlobalMarket;

func _on_contracts_pressed() -> void:
	UIEventBus.toggle_panel.emit("contracts", {});
	
const GUN = preload("res://resources/item/gun.tres")
func _on_add_random_contract_pressed() -> void:
	if country_manager.player_country == null: return;
	
	var contract = Contract.create(
		country_manager.player_country,
		randi_range(0, 1),
		randf_range(100, 1000),
		randf_range(1000, 5000),
		randf_range(10, 500),
		{GUN: 5},
	);
	
	global_market.add_contract(contract);

func setup_providers() -> void:
	var manager = UIProviderManager.manager;
	if manager == null:
		push_error("Provider manager not found!");
		return;
	
	country_manager = manager.get_provider(CountryManager);
	global_market = manager.get_provider(GlobalMarket);

func _ready() -> void:
	setup_providers();
