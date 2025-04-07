class_name HUD
extends CanvasLayer

func _on_contracts_button_pressed() -> void:
	UIEventBus.toggle_panel.emit("contract", {});

func _on_sell_contract_pressed() -> void:
	var country = CountryManager.countries.values().pick_random();
	
	var contract = Contract.create(
		country,
		Contract.ContractType.Sell,
		{},
		GameTime.current_time + randf_range(10, 1000),
		randi_range(20, 300),
	);
	
	GlobalMarket.add_contract(contract);

func _on_buy_contract_pressed() -> void:
	var country = CountryManager.countries.values().pick_random();
	
	var contract = Contract.create(
		country,
		Contract.ContractType.Buy,
		{},
		GameTime.current_time + randf_range(10, 1000),
		randi_range(20, 300),
	);
	
	GlobalMarket.add_contract(contract);
