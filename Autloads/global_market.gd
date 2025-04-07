extends Node

signal contract_added(contract: Contract);
signal contract_removed(contract: Contract);
signal contracts_changed();

var contracts: Array[Contract] = [];

func finalize_transaction(contract: Contract, winning_bid: Bid) -> void:
	match contract.type:
		Contract.ContractType.Sell:
			var buyer = winning_bid.bidder;
			
			if buyer.funds < winning_bid.offer:
				print("Buyer " + buyer.name + " does not have enough funds");
				return;
			
			buyer.funds -= winning_bid.offer;
			
			for item in contract.goods.keys():
				var quantity = contract.goods[item];
				contract.issuer.inventory[item] -= quantity;
				buyer.inventory[item] = buyer.inventory.get(item, 0) + quantity;
				print(
					"Transaction complete: " +
					buyer.name + " bought from " + 
					contract.issuer.name
				);
		Contract.ContractType.Buy:
			pass;

func add_contract(contract: Contract) -> void:
	contracts.append(contract);
	
	contract_added.emit(contract);
	contracts_changed.emit();
	
	var process_expired_contract = func(bids: Array[Bid]):
		var winning_bid = contract.get_winning_bid();
		
		if winning_bid:
			finalize_transaction(contract, winning_bid);
		else:
			GameTime.add_alarm(GameTime.current_time + randf_range(10.0, 70.0), func():
				remove_contract(contract);
			);
	
	contract.contract_expired.connect(process_expired_contract);

func remove_contract(contract: Contract) -> void:
	contracts.erase(contract);
	
	contract_removed.emit(contract);
	contracts_changed.emit();

func get_buy_contracts() -> Array[Contract]:
	return contracts.filter(func(contract):
		return contract.type == Contract.ContractType.Buy && !contract.expired;
	);

func get_sell_contracts() -> Array[Contract]:
	return contracts.filter(func(contract):
		return contract.type == Contract.ContractType.Sell && !contract.expired
	);
