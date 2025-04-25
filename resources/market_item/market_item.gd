class_name MarketItem
extends Resource

var item: String;
var count: int;
var price: float;

var owner: Country;

func _init(item: String, count: int, price: float, owner: Country) -> void:
	self.item = item;
	self.count = count;
	self.price = price;
	self.owner = owner;
