class_name PlayerCamera
extends Camera2D

@export var max_speed: float = 100.0;

@export_group("Zoom Settings")
@export var min_zoom: float = 0.1; 
@export var max_zoom: float = 4.0; 
@export var zoom_speed: float = 0.05;

var is_zooming: bool = false;

var is_dragging: bool = false;
var drag_mouse_start_position: Vector2 = Vector2.ZERO;
var drag_camera_start_position: Vector2 = Vector2.ZERO;

func zoom_at_point(zoom_factor: float, zoom_anchor: Vector2) -> void:
	var old_zoom = zoom;
	zoom = (zoom * zoom_factor)\
		.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom));
	
	var mouse_world_before = zoom_anchor;
	
	var relative_mouse = mouse_world_before - position;
	var scaled_relative = relative_mouse * (zoom / old_zoom);
	var mouse_world_after = scaled_relative + position;
	
	position +=  mouse_world_after - mouse_world_before;

func drag_camera(event: InputEvent) -> void:
	if event.is_action_pressed("drag_camera"):
		is_dragging = true;
		drag_mouse_start_position = get_viewport().get_mouse_position();
		drag_camera_start_position = position;
	
	if event.is_action_released("drag_camera"):
		is_dragging = false;
	
	if is_dragging and event is InputEventMouseMotion:
		var current_mouse_position = get_viewport().get_mouse_position();
		var drag_delta = drag_mouse_start_position - current_mouse_position;
		
		position = drag_camera_start_position + drag_delta * 1/zoom;

func _input(event: InputEvent) -> void:
	drag_camera(event);
	
	if event.is_action_pressed("zoom_in"):
		zoom_at_point(1 + zoom_speed, get_global_mouse_position());
	elif event.is_action_pressed("zoom_out"):
		zoom_at_point(1 - zoom_speed, get_global_mouse_position());

func _process(delta: float) -> void:
	if not is_dragging:
		var movement_vector = Input.get_vector(
			"move_left", "move_right",
			"move_up", "move_down"
		);
		
		position += movement_vector * max_speed * delta;
