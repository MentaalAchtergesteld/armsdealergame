class_name Country
extends Resource

const DEFAULT_FLAG_PATH: String = "res://assets/flags/default.svg";
const DEFAULT_FLAG := preload(DEFAULT_FLAG_PATH);

enum RegimeType {
	Democracy,
	Autocracy,
	Oligarchy,
	Corporatocracy,
	Monarchy,
};

@export var name: String = "CountryName";
@export var flag: Texture2D = DEFAULT_FLAG;

@export_range(0.0, 1.0, 0.01) var stability: float = 0.5;
@export var regime: RegimeType = RegimeType.Democracy;

@export var funds: float = 100.0;
@export var inventory: Dictionary[Item, int] = {};

var regions: Array[CountryRegion];

static func load_flag_from_path(path: String) -> Texture2D:
	var flag_image := load(path);
	if flag_image:
		return flag_image;
	else:
		push_error("Couldn't load flag image at: " + path);
		return DEFAULT_FLAG;

@warning_ignore("shadowed_variable")
static func create(
	name: String       = "CountryName",
	flag_path: String  = DEFAULT_FLAG_PATH,
	regime: RegimeType = RegimeType.Democracy,
	stability: float   = 0.5,
) -> Country:
	var country = Country.new();
	
	country.name = name;
	country.flag = load_flag_from_path(flag_path);
	country.regime = regime;
	country.stability = stability;
	
	return country;

static func create_from_feature(properties: Dictionary) -> Country:
	var country = Country.new();
	country.name = properties.get("Name", "CountryName");
	
	var flag_path = "res://assets/" + properties.get("FlagPath", "");
	country.flag = load_flag_from_path(flag_path);
	
	var regime = RegimeType[properties.get("Regime", "Democracy")];
	if regime == null:
		regime = RegimeType.Democracy;
	country.regime = regime;
	
	country.stability = properties.get("Stability", 0.5);
	
	return country;
	
