class_name Country
extends Resource


@export var name: String;
@export var funds: float = 100.0;
@export var stockpile: Dictionary[String, int] = {};
@export var tarrifs: Dictionary[String, float] = {};
@export var government: Government;

func _on_decision_made(decision: Decision) -> void:
	decision.execute(self);

func setup() -> void:
	if government != null:
		government.decision_made.connect(_on_decision_made);

func process() -> void:
	government.process();
