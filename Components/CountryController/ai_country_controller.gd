class_name AICountryController
extends CountryController

@export var min_item_stock: int = 10;
@export var max_item_stock: int = 50;

var has_active_contract: bool = false;

func update() -> void:
	decide_actions();

func decide_actions() -> void:
	if not country: return;
	
	if randf() < 0.05:
		if randf() < 0.8:
			try_place_bid();
		else:
			try_create_contract();

func try_place_bid():
	# Only buy if base price isnt higher than 75% of country's funds.
	var active_contracts = GlobalMarket.get_sell_contracts()\
		.filter(func(contract): return contract.base_price < country.funds * 0.75);
	
	if active_contracts.is_empty(): return;
	
	var contract: Contract = active_contracts.pick_random();
	
	var offer = min(contract.base_price + randf_range(0.0, 10.0), country.funds);
	var bid = Bid.create(country, offer);
	
	contract.place_bid(bid);

func try_create_contract():
	if has_active_contract: return;
	
	var item_to_sell := pick_item_to_sell();
	if item_to_sell == null: return;
	
	var max_to_sell = country.inventory[item_to_sell] - min_item_stock;
	var amount_to_sell = randi_range(min(5.0, max_to_sell), max_to_sell);
	var price := calculate_good_price(item_to_sell, amount_to_sell);
	
	var deadline = GameTime.current_time + randf_range(300.0, 800.0);
	
	var contract = Contract.create(
		country,
		Contract.ContractType.Sell,
		{item_to_sell: amount_to_sell},
		deadline,
		price
	);
	
	GlobalMarket.add_contract(contract);
	has_active_contract = true;
	
	contract.contract_expired.connect(func(_bids): has_active_contract = false);

func pick_item_to_sell() -> Good:
	var options = country.inventory.keys().filter(func(key):
		return country.inventory[key] > max_item_stock;
	);
	
	if options.is_empty(): return null;
	return options.pick_random();

func calculate_good_price(item: Good, amount: int) -> float:
	var random = randf_range(1.0, 2.5);
	var limited = round(random * 100.0) / 100.0;
	return amount * limited;

func contract_expired() -> void:
	pass

static func create(country: Country) -> AICountryController:
	var controller = AICountryController.new();
	controller.country = country;
	return controller;
