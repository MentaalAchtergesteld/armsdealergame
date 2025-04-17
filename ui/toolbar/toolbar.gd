class_name Toolbar
extends PanelContainer

@export var country_manager: CountryManager;
@export var global_market: GlobalMarket;

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
