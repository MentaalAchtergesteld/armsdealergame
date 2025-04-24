class_name Country
extends Resource


@export var name: String;
@export var funds: float = 100.0;
@export var stockpile: Dictionary[String, int] = {};
@export var tarrifs: Dictionary[String, float] = {};
@export var government: Government;

var resource_locator: ResourceLocator;

func _on_decision_made(decision: Decision) -> void:
	decision.execute(self, resource_locator);

func setup(resource_locator: ResourceLocator) -> void:
	self.resource_locator = resource_locator;
	if government != null:
		government.setup(resource_locator);
		government.decision_made.connect(_on_decision_made);
