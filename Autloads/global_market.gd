extends Node

signal contract_added(contract: Contract);
signal contract_removed(contract: Contract);
signal contracts_changed();

var contracts: Array[Contract] = [];

func add_contract(contract: Contract) -> void:
	contracts.append(contract);
	
	contract_added.emit(contract);
	contracts_changed.emit();

func remove_contract(contract: Contract) -> void:
	contracts.erase(contract);
	
	contract_removed.emit(contract);
	contracts_changed.emit();
