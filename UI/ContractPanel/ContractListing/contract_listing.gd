@tool
class_name ContractListing
extends PanelContainer

@export var contract: Contract: set = update_contract;

@export_tool_button("Toggle Details") var toggle_details = func():
	if show_details:
		collapse_details();
	else:
		expand_details();
pass

@onready var issuer_flag: TextureRect = %IssuerFlag
@onready var type: LabeledField = %Type
@onready var deadline: LabeledField = %Deadline
@onready var is_expired: Label = %IsExpired
@onready var base_price: LabeledField = %BasePrice

@onready var goods_list: VBoxContainer = %GoodsList
@onready var expanded_details: MarginContainer = %ExpandedDetails
@onready var expanded_wrapper: Control = %ExpandedWrapper

var show_details: bool = false;

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
	
	for child in goods_list.get_children():
		child.queue_free();
	
	for good in contract.goods.keys():
		var quantity = contract.goods[good];
		
		var listing = GoodListing.create(good, quantity);
		goods_list.add_child(listing);

func _on_contract_expired(bids: Array[Bid]) -> void:
	is_expired.text = "Expired";

func expand_details():
	expanded_wrapper.size.y = 0;
	expanded_wrapper.visible = true

	# Calculate target height based on combined minimum size of the details container.
	var target_height: float = expanded_details.get_combined_minimum_size().y
	target_height = max(target_height, 32);
	# Set initial height of wrapper to 0.
	expanded_wrapper.custom_minimum_size = Vector2(expanded_wrapper.custom_minimum_size.x, 0)
	
	var tween = create_tween()
	tween.tween_property(
		expanded_wrapper,
		"custom_minimum_size", 
		Vector2(expanded_wrapper.custom_minimum_size.x, target_height), 0.3
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT);
	show_details = true;

func collapse_details():
	var current_width: float = expanded_wrapper.custom_minimum_size.x
	var tween = create_tween()
	tween.tween_property(
		expanded_wrapper,
		"custom_minimum_size",
		Vector2(current_width, 0),
		0.3
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.finished.connect(_on_collapse_finished);
	#tween.connect("finished", Callable(self, "_on_collapse_finished"))

func _on_collapse_finished() -> void:
	expanded_wrapper.visible = false
	show_details = false;

func _on_details_button_pressed() -> void:
	show_details = !show_details;
	
	if show_details:
		expand_details();
	else:
		collapse_details();

func _ready() -> void:
	update_contract(contract);

const scene: PackedScene = preload("res://UI/ContractPanel/ContractListing/contract_listing.tscn");

static func create(contract: Contract) -> ContractListing:
	var listing: ContractListing = scene.instantiate();
	listing.contract = contract;
	return listing;
