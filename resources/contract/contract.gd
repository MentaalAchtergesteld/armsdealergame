class_name Contract
extends Resource

enum ContractType { Buy, Sell };

signal has_expired;

@export var issuer: Country;
@export var type: ContractType = ContractType.Buy;
@export var issue_time: float = 0.0;
@export var bid_deadline: float = 0.0;
@export var deliver_deadline: float = 0.0;
@export var base_price: float = 0.0;
@export var items: Dictionary[Item, int] = {};

var bids: Array[Bid] = [];

var is_expired: bool = false;

func add_bid(bid: Bid) -> bool:
	if bid.offer < base_price: return false;
	bids.append(bid);
	return true;

@warning_ignore("shadowed_variable")
static func create(
	issuer: Country,
	type: ContractType,
	bid_deadline: float,
	deliver_deadline: float,
	base_price: float,
	items: Dictionary[Item, int]
) -> Contract:
	var contract = Contract.new();
	contract.issuer = issuer;
	contract.type = type;
	contract.bid_deadline = bid_deadline;
	contract.deliver_deadline = deliver_deadline;
	contract.base_price = base_price;
	contract.items = items;
	contract.issue_time = 0;
	return contract;
