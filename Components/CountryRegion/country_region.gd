class_name CountryRegion
extends Area2D

@export var country: Country;
@export var neighbours: Array[CountryRegion];

@export_group("Outline Settings")
@export_color_no_alpha var default_outline_color: Color = Color.BLACK;
@export_color_no_alpha var selected_outline_color: Color = Color.SEA_GREEN;

@export var default_outline_width: float = 2.0;
@export var selected_outline_width: float = 4.0;

var selected: bool = false;

var outlines: Array[Line2D] = [];

func select():
	selected = true;
	for outline in outlines:
		outline.default_color = selected_outline_color;
		outline.z_index = 100;
		outline.width = selected_outline_width;

func deselect():
	for outline in outlines:
		outline.default_color = default_outline_color;
		outline.z_index = 0;
		outline.width = default_outline_width;
	selected = false;

func _ready() -> void:
	input_event.connect(_on_input_event);
	EventBus.ui_open_country_panel.connect(_on_ui_open_country_panel);
	EventBus.ui_close_country_panel.connect(_on_ui_close_country_panel);

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event.is_action_pressed("ui_click"):
		if not selected:
			EventBus.ui_open_country_panel.emit(country);
		else:
			EventBus.ui_close_country_panel.emit();

func _on_ui_open_country_panel(selected_country: Country):
	if selected_country == country:
		select();
	elif selected:
		deselect();

func _on_ui_close_country_panel():
	if selected:
		deselect();


static func create(country: Country, polygons: Array[PackedVector2Array]):
	var region = CountryRegion.new();
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
