class_name GlobalMarket
extends Node

signal contract_added(contract: Contract);
signal contract_removed(contract: Contract);

@export var game_time: GameTime;

var contracts: Array[Contract] = [];

func _on_time_changed(time: float) -> void:
	for contract in contracts:
		contract.check_expiration(time);

func _on_contract_expired(contract: Contract) -> void:
	print("contract expired");

func remove_contract(contract: Contract) -> bool:
	if !contracts.has(contract): return false;
	contract.has_expired.disconnect(_on_contract_expired.bind(contract));
	contracts.erase(contract);
	contract_removed.emit(contract);
	return true;

func add_contract(contract: Contract) -> bool:
	if contracts.has(contract): return false;
	contract.has_expired.connect(_on_contract_expired.bind(contract));
	contracts.append(contract);
	contract_added.emit(contract);
	return true;

func _ready() -> void:
	game_time.time_changed.connect(_on_time_changed);
