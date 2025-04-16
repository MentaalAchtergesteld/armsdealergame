@tool
class_name ItemListing
extends HBoxContainer

@onready var icon: TextureRect = %Icon
@onready var quantity_label: Label = %Quantity
@onready var item_label: Label = %Item

@export var item: Item:
	set(value):
		item = value;
		update_listing();
@export var quantity: int = 0:
	set(value):
		quantity = value;
		update_listing();

func update_listing():
	if !is_inside_tree(): return;
	if item == null: return;
	icon.texture = item.icon;
	quantity_label.text = str(quantity) + "x";
	item_label.text = item.plural;

func _ready() -> void:
	update_listing();

const ITEM_LISTING = preload("res://ui/item_listing/item_listing.tscn")
static func create(item: Item, quantity: int) -> ItemListing:
	var listing = ITEM_LISTING.instantiate();
	listing.item = item;
	listing.quantity = quantity;
	return listing;
