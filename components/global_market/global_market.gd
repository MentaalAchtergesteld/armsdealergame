class_name GlobalMarket
extends Node

signal contract_added(contract: Contract);
signal contract_expired(contract: Contract);
signal contract_removed(contract: Contract);

@export var game_time: GameTime;

var contracts: Array[Contract] = [];

func _on_contract_expired(contract: Contract) -> void:
	game_time.add_alarm(
		game_time.time + randf_range(50, 100),
		remove_contract.bind(contract)
	);

func remove_contract(contract: Contract) -> bool:
	if !contracts.has(contract): return false;
	contracts.erase(contract);
	contract_removed.emit(contract);
	return true;

func add_contract(contract: Contract) -> bool:
	if contracts.has(contract): return false;
	contract.contract_expired.connect(_on_contract_expired.bind(contract));
	
	game_time.add_alarm(contract.bid_deadline, func():
		contract.is_expired = true;
	);
	
	contracts.append(contract);
	contract_added.emit(contract);
	
	return true;
