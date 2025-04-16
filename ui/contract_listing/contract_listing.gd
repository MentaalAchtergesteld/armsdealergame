@tool
class_name ContractsListing
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
	
	print(contract.issuer.flag);
	
	country_flag.texture = contract.issuer.flag;
	type.text = Utils.enum_value_to_string(contract.ContractType, contract.type);
	deadline.set_value(contract.bid_deadline);

func _ready() -> void:
	update_listing();
