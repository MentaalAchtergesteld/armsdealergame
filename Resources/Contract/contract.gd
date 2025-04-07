class_name Contract
extends Resource

signal contract_expired(bids: Array[Bid]);

enum ContractType { Buy, Sell };

@export var type: ContractType = ContractType.Buy;
@export var issuer: Country;
@export var goods: Dictionary[String, int] = {};
@export var deadline: int = 0;
@export var base_price: float = 0;
@export var bids: Array[Bid] = [];

var expired: bool = false;

func place_bid(bid: Bid) -> bool:
	if expired: return false;
	bids.append(bid);
	return true;

func get_winning_bid() -> Bid:
	if bids.is_empty(): return null;
	
	if type == ContractType.Buy:
		bids.sort_custom(func(a, b): return a.offer < b.offer);
	else:
		bids.sort_custom(func(a, b): return a.offer > b.offer);
	
	return bids[0];

@warning_ignore("shadowed_variable")
static func create(
	issuer: Country,
	type: ContractType,
	goods: Dictionary[String, int],
	deadline: int,
	base_price: float,
) -> Contract:
	var contract: Contract = Contract.new();
	
	contract.issuer = issuer;
	contract.type = type;
	contract.goods = goods;
	contract.deadline = deadline;
	
	if GameTime.current_time < deadline:
		GameTime.add_alarm(contract.deadline, func():
			contract.contract_expired.emit(contract.bids);
			contract.expired = true;
		);
	else:
		contract.expired = true;
	
	contract.base_price = base_price;
	
	return contract;
