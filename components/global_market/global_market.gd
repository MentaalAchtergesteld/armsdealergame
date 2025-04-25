class_name GlobalMarket
extends Node

var sell_offers: Array[MarketItem] = [];
var buy_offers: Array[MarketItem] = [];

func place_sell_offer(item: String, count: int, price: float, owner: Country) -> MarketItem:
	var market_item = MarketItem.new(item, count, price, owner);
	sell_offers.append(item);
	return market_item;

func place_buy_offer(item: String, count: int, price: float, owner: Country) -> MarketItem:
	var market_item = MarketItem.new(item, count, price, owner);
	buy_offers.append(item);
	return market_item;

func get_sell_offers_by_item(item: String) -> Array:
	return sell_offers.filter(func(mi): mi.item == item);

func get_buy_offers_by_item(item: String) -> Array:
	return buy_offers.filter(func(mi): mi.item == item);

func transfer_trade(
	market_item: MarketItem,
	price: float,
	seller: Country,
	buyer: Country
) -> bool:
	if buyer.funds < price:
		return false;
	if seller.stockpile.get(market_item.item, 0) < market_item.count:
		return false;
	
	buyer.funds -= price;
	seller.funds += price;
	
	seller.stockpile[market_item.item] -= market_item.count;
	buyer.stockpile[market_item.item] = buyer.stockpile.get(market_item.item, 0) + market_item.count;
	return true;

func buy(market_item: MarketItem, buyer: Country) -> bool:
	if !sell_offers.has(market_item): return false;
	var seller = market_item.owner;
	
	var tarrifs = seller.tarrifs.get(market_item.item, 0.0);
	var total_price = market_item.price + tarrifs;
	
	if transfer_trade(market_item, total_price, seller, buyer):
		sell_offers.erase(market_item);
		return true;
	else:
		return false;

func sell(market_item: MarketItem, seller: Country) -> bool:
	if !buy_offers.has(market_item): return false;
	var buyer = market_item.owner;
	
	var tarrifs = seller.tarrifs.get(market_item.item, 0.0);
	var total_price = market_item.price - tarrifs;
	
	transfer_trade(market_item, total_price, seller, buyer);
	
	if transfer_trade(market_item, total_price, seller, buyer):
		buy_offers.erase(market_item);
		return true;
	else:
		return false;
