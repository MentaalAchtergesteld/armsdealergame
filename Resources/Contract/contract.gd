class_name Contract
extends Resource

enum ContractType { Buy, Sell };

@export var type: ContractType = ContractType.Buy;
@export var issuer: Country;
@export var goods: Array = [];
@export var deadline: int = 0;
@export var bids: Array = [];

func get_winning_bid() -> Bid:
	if bids.is_empty(): return null;
	
	if type == ContractType.Buy:
		bids.sort_custom(func(a, b): return a.offer < b.offer);
	else:
		bids.sort_custom(func(a, b): return a.offer > b.offer);
	
	return bids[0];

@warning_ignore("shadowed_variable")
static func create(issuer: Country, type: ContractType, goods: Array, deadline: int) -> Contract:
	var contract: Contract = Contract.new();
	
	contract.issuer = issuer;
	contract.type = type;
	contract.goods = goods;
	contract.deadline = deadline;
	
	return contract;
