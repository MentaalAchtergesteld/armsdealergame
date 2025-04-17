@tool
class_name ContractsPanel
extends BasePanel

@onready var contracts: VBoxContainer = %Contracts

@export var global_market: GlobalMarket;

var listings: Array[ContractListing];

func add_listing(contract: Contract) -> void:
	var listing = ContractListing.create(contract);
	contracts.add_child(listing);

func remove_listing(contract: Contract) -> void:
	var listing_index = listings.find_custom(func(listing):
		listing.contract == contract
	);
	
	if listing_index > -1:
		listings.get(listing_index).queue_free();
		listings.remove_at(listing_index);

func _on_contract_added(contract: Contract) -> void:
	add_listing(contract);

func _on_contract_removed(contract: Contract) -> void:
	remove_listing(contract);

func load_all_contracts() -> void:
	for contract in global_market.contracts:
		add_listing(contract);

func _ready() -> void:
	global_market.contract_added.connect(_on_contract_added);
	global_market.contract_removed.connect(_on_contract_removed);
	
	load_all_contracts();
