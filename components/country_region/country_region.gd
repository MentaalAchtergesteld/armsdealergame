class_name CountryRegion
extends Area2D

signal region_clicked(region: CountryRegion);

@export var country: Country;

@export_group("Outline Settings")
@export_color_no_alpha var default_outline_color: Color = Color.BLACK;
@export_color_no_alpha var selected_outline_color: Color = Color.SEA_GREEN;

@export var default_outline_width: float = 2.0;
@export var selected_outline_width: float = 4.0;

var outlines: Array[Line2D] = [];

var selected: bool = false: set = set_selected;

func set_selected(value: bool) -> void:
	if selected == value: return;
	selected = value;
	
	if selected:
		for outline in outlines:
			outline.default_color = selected_outline_color;
			outline.z_index = 100;
			outline.width = selected_outline_width;
	else:
		for outline in outlines:
			outline.default_color = default_outline_color;
			outline.z_index = 0;
			outline.width = default_outline_width;

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("ui_click"):
		selected = !selected;
		region_clicked.emit(self);

@warning_ignore("shadowed_variable")
static func create(country: Country, polygons: Array[PackedVector2Array]) -> CountryRegion:
	var region: CountryRegion = CountryRegion.new();
	region.country = country;
	
	for polygon in polygons:
		var collision_shape = CollisionPolygon2D.new();
		var visual_shape = Polygon2D.new();
		var outline = Line2D.new();
		
		collision_shape.polygon = polygon;
		visual_shape.polygon = polygon;
		
		outline.points = polygon;
		outline.width = 1.5;
		outline.default_color = Color.BLACK;
		outline.antialiased = true;
		
		region.add_child(collision_shape);
		region.add_child(visual_shape);
		region.add_child(outline);
		
		region.outlines.append(outline);
	
	return region;

static func convert_points_to_vector2_array(points: Array, scale: float) -> PackedVector2Array:
	var array = [];
	
	for point in points:
		array.append(Vector2(point[0] * scale, point[1] * scale * -1));
	
	return array;

static func create_from_geometry(country: Country, geometry: Dictionary, scale: float) -> CountryRegion:
	var geometry_type = geometry.get("type", "");
	if geometry_type != "MultiPolygon":
		push_error("Unsupported geometry type for country region: " + geometry_type);
	
	var multipolygon: Array = geometry.get("coordinates", []);
	
	var polygons: Array[PackedVector2Array] = [];
	for polygon in multipolygon:
		if polygon.is_empty(): continue;
		
		var outer_ring = polygon[0];
		var polygon_vectors = convert_points_to_vector2_array(outer_ring, scale);
		polygons.append(polygon_vectors);
	
	var region = create(country, polygons);
	return region;
