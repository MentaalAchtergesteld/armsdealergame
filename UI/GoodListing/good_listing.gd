@tool
class_name GoodListing
extends HBoxContainer

@export var good: Good: set = update_good;
@export var quantity: int = 0: set = update_quantity;

func update_good(new_good: Good) -> void:
	if new_good == null:
		new_good = Good.new();
	
	good = new_good;
	
	if !is_inside_tree(): return;
	
	$Icon.texture = good.icon;
	$Name.text = good.plural;

func update_quantity(new_quantity: int) -> void:
	quantity = new_quantity;
	
	if !is_inside_tree(): return;
	
	$Quantity.text = str(quantity);

func set_good(new_good: Good, new_quantity: int) -> void:
	good = new_good;
	quantity = new_quantity;

func _ready() -> void:
	update_good(good);
	update_quantity(quantity);

const GOOD_LISTING = preload("res://UI/GoodListing/good_listing.tscn")

static func create(good: Good, quantity: int) -> GoodListing:
	var listing = GOOD_LISTING.instantiate();
	listing.set_good(good, quantity);
	return listing;
