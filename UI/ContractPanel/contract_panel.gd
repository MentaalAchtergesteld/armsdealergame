@tool
class_name ContractPanel
extends BasePanel

@onready var contracts_list: VBoxContainer = %Contracts

var listings: Array[ContractListing] = [];

func sort_listings():
	listings.sort_custom(func(a, b):
		
		if a.contract.expired != b.contract.expired:
			return b.contract.expired
		
		return a.contract.deadline < b.contract.deadline
	);
	
	for i in listings.size():
		contracts_list.move_child(listings[i], i);

func update_contract_listings(contracts: Array[Contract]):
	for listing in listings:
		if not contracts.has(listing.contract):
			listing.queue_free();
			listings.erase(listing);
	
	var existing_contracts = listings.map(func(listing): return listing.contract);
	for contract in contracts:
		if not existing_contracts.has(contract):
			var listing = ContractListing.create(contract);
			listings.append(listing);
			contracts_list.add_child(listing);
	
	sort_listings();

func setup(data: Dictionary = {}) -> void:
	update_contract_listings(GlobalMarket.contracts);

func _on_contracts_changed() -> void:
	if is_open:
		update_contract_listings(GlobalMarket.contracts);

func _ready() -> void:
	GlobalMarket.contracts_changed.connect(_on_contracts_changed);
