class_name GameDataLoader
extends Node

@export_file("*.json") var map_path: String;
@export var map_scale: float = 1.0;

@export var country_manager: CountryManager;
@export var map: Map;

func load_geojson(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ);
	
	if not file:
		push_error("Could not open GeoJSON file: " + path);
		return {};
	
	var content := file.get_as_text();
	file.close();
	
	var result = JSON.parse_string(content);
	
	if result:
		return result;
	else:
		push_error("JSON parse error: " + result.error_string);
		return {};

func parse_map_data(data: Dictionary) -> void:
	if data.get("type", "") != "FeatureCollection":
		push_error("Invalid GeoJSON format!");
		return;
	
	var features = data.get("features", {});
	
	for feature in features:
		var props = feature.get("properties", {});
		var geometry = feature.get("geometry", {});
		
		var country := Country.create_from_feature(props);
		var could_add = country_manager.add_country(country);
		
		if !could_add: continue;
		
		var region = CountryRegion.create_from_geometry(country, geometry, map_scale);
		map.add_region(region);

func load_map() -> void:
	var map_data = load_geojson(map_path);
	parse_map_data(map_data);

func _ready() -> void:
	load_map();
