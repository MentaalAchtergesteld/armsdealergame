class_name Map
extends Node2D

signal region_added(region: CountryRegion);

var selected_region: CountryRegion;
var regions: Array[CountryRegion] = [];

func add_region(region: CountryRegion) -> bool:
	if regions.has(region):
		push_warning("Tried adding an already existing country region: " + region.country.name);
		return false;
	
	region.region_clicked.connect(_on_region_clicked);
	regions.append(region);
	add_child(region);
	region_added.emit(region);
	return true;

func _on_region_clicked(region: CountryRegion) -> void:
	if selected_region and selected_region != region:
		selected_region.selected = false;
	selected_region = region;
