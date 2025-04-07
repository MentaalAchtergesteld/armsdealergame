class_name Country
extends Resource

enum RegimeType {
	Democracy,
	Autocracy,
	Oligarchy
}

@export var name: String = "Country";
@export var flag: Texture2D = preload("res://Assets/default.svg");

@export_range(0, 1) var stability: float = 1.0;

@export var regime: RegimeType = RegimeType.Democracy;

@export var inventory: Dictionary = {"gun": 100};
@export var funds: float = 100.0;

@export var wars: Array[War];
