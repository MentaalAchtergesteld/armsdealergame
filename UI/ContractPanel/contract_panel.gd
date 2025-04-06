@tool
class_name ContractPanel
extends BasePanel

@onready var contracts: VBoxContainer = %Contracts

func update_contract_listings():
	for listing in contracts.get_children():
		listing.queue_free();
	
	for contract in GlobalMarket.contracts:
		var listing = ContractListing.create(contract);
		contracts.add_child(listing);

func setup(data: Dictionary = {}) -> void:
	update_contract_listings();

func _on_contracts_changed() -> void:
	update_contract_listings();

func _ready() -> void:
	GlobalMarket.contracts_changed.connect(_on_contracts_changed);
