@tool
class_name ContractListing
extends PanelContainer

@export var contract: Contract:
	set(value):
		contract = value;
		if is_inside_tree(): update_listing();

@onready var issuer_flag: TextureRect = %IssuerFlag
@onready var type: Label = %Type
@onready var deadline: Label = %Deadline

func update_listing():
	issuer_flag.texture = contract.issuer.flag;
	type.text = "Type: ";
	
	match contract.type:
		Contract.ContractType.Buy:
			type.text += "Buy";
		Contract.ContractType.Sell:
			type.text += "Sell";
	
	deadline.text = str(contract.deadline);

func _ready() -> void:
	update_listing();

const scene: PackedScene = preload("res://UI/ContractPanel/ContractListing/contract_listing.tscn");

static func create(contract: Contract) -> ContractListing:
	var listing: ContractListing = scene.instantiate();
	listing.contract = contract;
	return listing;
