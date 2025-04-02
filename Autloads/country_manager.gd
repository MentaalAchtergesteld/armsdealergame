extends Node

const COUNTRY_DIR: String = "res://Resources/Country";

var countries: Dictionary[String, Country] = {};

func _ready() -> void:
	load_countries();

func load_countries():
	var dir := DirAccess.open(COUNTRY_DIR);
	
	for file in dir.get_files():
		if not file.ends_with(".tres"): continue;
		
		var country: Country = load("res://Resources/Country/" + file);
		countries.set(country.name, country);

func load_geojson(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ);
	if not file:
		push_error("Could not open map file: " + path);
		return {};
	
	var file_text := file.get_as_text();
	file.close();
	
	var json: Dictionary = JSON.parse_string(file_text);
	if json == null:
		push_error("Could not parse map file: " + path);
		return {};
	
	return json;

func parse_multipolygon(multipolygon: Array, multiplier: float) -> Array[PackedVector2Array]:
	var shape: Array[PackedVector2Array] = [];
	for polygon in multipolygon:
		if polygon.is_empty(): continue;
		var ring: Array = polygon[0];
		var coordinates: PackedVector2Array = [];
		for coord in ring:
			var vector = Vector2(coord[0], coord[1] * -1) * multiplier;
			coordinates.append(vector);
		shape.append(coordinates);
	return shape;

func fetch_country_flag(country_code: String) -> ImageTexture: 
	var url = "https://flagsapi.com/%s/flat/64.png" % country_code;
	var http_request = HTTPRequest.new();
	add_child(http_request);
	
	var error = http_request.request(url);
	if error != OK:
		push_error("Failed to request flag for " + country_code);
		http_request.queue_free();
		return;
	
	var result = await http_request.request_completed;
	http_request.queue_free();
	
	if result[0] != HTTPRequest.RESULT_SUCCESS or result[1] != 200:
		push_error("Failed to download flag for " + country_code);
		return;
	
	var image = Image.new();
	var err = image.load_png_from_buffer(result[3]);
	if err != OK:
		push_error("Failed to load flag image for " + country_code);
		return;
	
	var texture = ImageTexture.create_from_image(image);
	return texture;

func create_country_region(feature: Dictionary, polygon_multiplier: float) -> CountryRegion:
		var properties: Dictionary = feature.get("properties", {});
		var country_name: String = properties.get("NAME", "");
		
		var country = countries.get(country_name);
		if country == null:
			country = Country.new();
			country.name = country_name;
			
			var country_code = properties.get("ISO_A2_EH");
			if country_code != null:
				var flag_texture = await fetch_country_flag(country_code);
				country.flag = flag_texture;
		
		var geometry: Dictionary = feature.get("geometry", {});
		if geometry.get("type", "") != "MultiPolygon":
			return null;
		
		var multipolygon = geometry.get("coordinates", []);
		var shape = parse_multipolygon(multipolygon, polygon_multiplier);
		
		var region = CountryRegion.create(country, shape);
		return region;

func generate_country_regions(map_path: String, polygon_multiplier: float) -> Array[CountryRegion]:
	var json := load_geojson(map_path);
	
	var features: Array = json.get("features", []);
	var regions: Array[CountryRegion] = [];
	
	for feature in features:
		var region = await create_country_region(feature, polygon_multiplier);
		if region: regions.append(region);
	
	return regions;
