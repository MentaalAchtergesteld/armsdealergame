extends Node

const COUNTRY_DIR: String = "res://Resources/Country";
const DEFAULT_FLAG: Texture2D = preload("res://Assets/default.svg");

var player_country: Country;

var countries: Dictionary[String, Country] = {};
var controllers: Array[CountryController] = [];

func _ready() -> void:
	#load_countries();
	GameTime.time_changed.connect(_on_time_changed);
	
	player_country = Country.create("Player", DEFAULT_FLAG, Country.RegimeType.Democracy);
	countries[player_country.name] = player_country;

func _on_time_changed(current_time: float) -> void:
	for controller in controllers:
		controller.update();

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

func create_ai_country_controller(country: Country) -> AICountryController:
	return AICountryController.create(country);

func create_country_from_map_data(data: Dictionary):
	var country_name = data.get("Name", "CountryName");
	var flag_path = "res://Assets/" + data.get("FlagPath", "default.svg");
	
	var country_flag;
	if ResourceLoader.exists(flag_path):
		country_flag = load(flag_path);
	else:
		country_flag = DEFAULT_FLAG;
	
	var country_regime;
	match data.get("Regime", "Democracy"):
		"Democracy":
			country_regime = Country.RegimeType.Democracy;
		"Autocracy":
			country_regime = Country.RegimeType.Autocracy;
		"Oligarchy":
			country_regime = Country.RegimeType.Oligarchy;
	
	var country = Country.create(country_name, country_flag, country_regime);
	country.stability = data.get("Stability", 0.5);
	
	return country;

func create_country_region(feature: Dictionary, polygon_multiplier: float) -> CountryRegion:
		var properties: Dictionary = feature.get("properties", {});
		var country_name: String = properties.get("Name", "");
		
		var country = countries.get(country_name);
		if country == null:
			country = create_country_from_map_data(properties);
			var controller = create_ai_country_controller(country);
			
			countries[country.name] = country;
			controllers.append(controller);
		
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
		var region = create_country_region(feature, polygon_multiplier);
		if region: regions.append(region);
	
	return regions;
