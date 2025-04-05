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
