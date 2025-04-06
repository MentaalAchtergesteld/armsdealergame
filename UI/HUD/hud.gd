class_name HUD
extends CanvasLayer

func _on_contracts_button_pressed() -> void:
	UIEventBus.toggle_panel.emit("contract", {});

func _on_sell_contract_pressed() -> void:
	var country = CountryManager.countries.values().pick_random();
	
	var contract = Contract.create(
		country,
		Contract.ContractType.Sell,
		[],
		randi_range(10, 1000)
	);
	
	GlobalMarket.add_contract(contract);

func _on_buy_contract_pressed() -> void:
	var country = CountryManager.countries.values().pick_random();
	
	var contract = Contract.create(
		country,
		Contract.ContractType.Buy,
		[],
		randi_range(10, 1000)
	);
	
	GlobalMarket.add_contract(contract);
