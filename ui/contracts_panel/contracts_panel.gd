@tool
class_name ContractsPanel
extends BasePanel

@onready var contracts: VBoxContainer = %Contracts

var global_market: GlobalMarket;

var listings: Array[ContractListing];

func add_listing(contract: Contract) -> void:
	var listing = ContractListing.create(contract);
	contracts.add_child(listing);
	listings.append(listing);

func remove_listing(contract: Contract) -> void:
	for listing in listings:
		if listing.contract == contract:
			listing.queue_free();
			listings.erase(listing);

func _on_contract_added(contract: Contract) -> void:
	add_listing(contract);

func _on_contract_removed(contract: Contract) -> void:
	remove_listing(contract);

func load_all_contracts() -> void:
	for contract in global_market.contracts:
		add_listing(contract);

func init(provider_manager: UIProviderManager) -> void:
	global_market = provider_manager.get_provider(GlobalMarket);
	if global_market:
		global_market.contract_added.connect(_on_contract_added);
		global_market.contract_removed.connect(_on_contract_removed);
		load_all_contracts();
