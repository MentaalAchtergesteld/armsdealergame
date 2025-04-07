@tool
class_name ContractListing
extends PanelContainer

@export var contract: Contract: set = update_contract;
#	set(value):
#		contract = value;
#		if is_inside_tree(): update_listing();

@onready var issuer_flag: TextureRect = %IssuerFlag
@onready var type: LabeledField = %Type
@onready var deadline: LabeledField = %Deadline
@onready var is_expired: Label = %IsExpired
@onready var base_price: LabeledField = %BasePrice

func update_contract(new_contract: Contract):
	if contract != null:
		contract.contract_expired.disconnect(_on_contract_expired);
	
	if new_contract == null:
		new_contract = Contract.new();
	
	contract = new_contract;
	
	contract.contract_expired.connect(_on_contract_expired);
	
	if !is_inside_tree(): return;
	
	issuer_flag.texture = contract.issuer.flag;
	tooltip_text = contract.issuer.name;
	
	match contract.type:
		Contract.ContractType.Buy:
			type.set_field("Buy");
		Contract.ContractType.Sell:
			type.set_field("Sell");
	
	deadline.set_field(contract.deadline);
	
	if contract.expired:
		is_expired.text = "Expired";
	else:
		is_expired.text = "";
	
	base_price.set_field(contract.base_price);

func _on_contract_expired(bids: Array[Bid]) -> void:
	is_expired.text = "Expired";

func _ready() -> void:
	update_contract(contract);

const scene: PackedScene = preload("res://UI/ContractPanel/ContractListing/contract_listing.tscn");

static func create(contract: Contract) -> ContractListing:
	var listing: ContractListing = scene.instantiate();
	listing.contract = contract;
	return listing;
