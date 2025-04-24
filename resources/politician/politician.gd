class_name Politician
extends Resource

@export var name: String = "Politician";

@export var corruption: Dictionary[Company, float] = {};

func corrupt(company: Company, amount: float) -> void:
	corruption[company] = corruption.get(company, 0.0) + amount;
	corruption = Utils.normalize_dictionary(corruption);
