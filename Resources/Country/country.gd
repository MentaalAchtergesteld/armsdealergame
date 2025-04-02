class_name Country
extends Resource

enum RegimeType {
	Democracy,
	Autocracy,
	Oligarchy
}

@export var name: String = "Country";
@export var flag: Texture2D;

@export_range(0, 1) var stability: float = 1.0;

@export var regime: RegimeType = RegimeType.Democracy;

@export var wars: Array[War];
