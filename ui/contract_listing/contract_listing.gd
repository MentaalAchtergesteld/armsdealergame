@tool
class_name ContractListing
extends PanelContainer

@onready var country_flag: TextureRect = %CountryFlag;
@onready var type_bar: Panel = %TypeBar
@onready var deadline: LabeledValue = %Deadline;
@onready var price: LabeledValue = %Price
@onready var is_expired: Label = %IsExpired

@export var contract: Contract:
	set(value):
		if contract:
			contract.contract_expired.disconnect(update_listing);
		contract = value;
		if contract:
			contract.contract_expired.connect(update_listing);
		update_listing();

func update_listing() -> void:
	if !is_inside_tree(): return;
	if contract == null: return;
	
	country_flag.texture = contract.issuer.flag;
	
	match contract.type:
		Contract.ContractType.Sell:
			type_bar.self_modulate = Color.RED;
		Contract.ContractType.Buy:
			type_bar.self_modulate = Color.GREEN;
	
	deadline.set_value(int(contract.bid_deadline));
	price.set_value(int(contract.base_price));
	
	if contract.is_expired:
		is_expired.visible = true;
	else:
		is_expired.visible = false;

func _ready() -> void:
	update_listing();

const CONTRACT_LISTING = preload("res://ui/contract_listing/contract_listing.tscn")
static func create(contract: Contract) -> ContractListing:
	var listing = CONTRACT_LISTING.instantiate();
	listing.contract = contract;
	return listing;
