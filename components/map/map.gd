class_name Map
extends Node2D

signal region_added(region: CountryRegion);

var selected_region: CountryRegion;
var regions: Array[CountryRegion] = [];

func _on_region_clicked(region: CountryRegion) -> void:
	if selected_region and selected_region != region:
		selected_region.selected = false;
	
	if region.selected:
		selected_region = region;
		UIEventBus.open_panel.emit("country", {country=region.country});
	else:
		selected_region = null;
		UIEventBus.close_panel.emit("country");

func add_region(region: CountryRegion) -> bool:
	if regions.has(region):
		push_warning("Tried adding an already existing country region: " + region.country.name);
		return false;
	
	region.region_clicked.connect(_on_region_clicked);
	regions.append(region);
	add_child(region);
	region_added.emit(region);
	return true;

func _on_panel_closed(panel: BasePanel) -> void:
	if not (panel is CountryPanel):
		return
	if not selected_region:
		return
	if panel.country != selected_region.country:
		return
	selected_region.selected = false

func _ready() -> void:
	UIEventBus.closed_panel.connect(_on_panel_closed);
