class_name Map
extends Node2D

@export_file("*.json") var map_path: String = "res://Assets/Maps/BENELUX.json";
@export var polygon_multiplier: int = 10;

@onready var regions_node: Node2D = $Regions;

func _ready() -> void:
	var regions = CountryManager.generate_country_regions(map_path, polygon_multiplier);
	
	for region in regions:
		regions_node.add_child(region);
