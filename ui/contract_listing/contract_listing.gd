@tool
class_name ContractListing
extends PanelContainer

@onready var country_flag: TextureRect = %CountryFlag;
@onready var type: Label = %Type;
@onready var deadline: LabeledValue = %Deadline;

@export var contract: Contract:
	set(value):
		contract = value;
		update_listing();

func update_listing() -> void:
	if !is_inside_tree(): return;
	if contract == null: return;
	
	country_flag.texture = contract.issuer.flag;
	type.text = Utils.enum_value_to_string(contract.ContractType, contract.type);
	deadline.set_value(contract.bid_deadline);

func _ready() -> void:
	update_listing();

const CONTRACT_LISTING = preload("res://ui/contract_listing/contract_listing.tscn")
static func create(contract: Contract) -> ContractListing:
	var listing = CONTRACT_LISTING.instantiate();
	listing.contract = contract;
	return listing;
