class_name Government
extends Resource

signal decision_made(decision: Decision);

@export var name: String = "Government";
@export var politicians: Array[Politician];
@export var possible_decisions: Array[Decision];

var resource_locator: ResourceLocator;
var scheduler: Scheduler;

func get_corruption_map() -> Dictionary[Company, float]:
	var total := {};
	for politician in politicians:
		for company in politician.corruption.keys():
			total[company] = total.get(company, 0.0) + politician.corruption[company];
	
	return Utils.normalize_dictionary(total);

func make_decision() -> void:
	var decision: Decision = possible_decisions.pick_random();
	if decision == null: return;
	decision_made.emit(decision);

func setup(resource_locator: ResourceLocator) -> void:
	self.resource_locator = resource_locator;
	self.scheduler = resource_locator.get_resource(Scheduler);

func process() -> void:
	if randf() < 0.1:
		make_decision();
