class_name PanelManager
extends Control

@export var panels: Dictionary[String, BasePanel] = {};

var open_panel: BasePanel = null;

func _ready() -> void:
	UIEventBus.open_panel.connect(_on_open_panel);
	UIEventBus.toggle_panel.connect(_on_toggle_panel);
	UIEventBus.close_panel.connect(_on_close_panel);

func _on_toggle_panel(panel_name: String, data: Dictionary) -> void:
	var panel: BasePanel = panels.get(panel_name);
	if open_panel == panel:
		_on_close_panel(panel_name);
	else:
		_on_open_panel(panel_name, data);

func _on_open_panel(panel_name: String, data: Dictionary) -> void:
	var panel: BasePanel = panels.get(panel_name);
	
	if panel:
		if open_panel != null:
			open_panel.close();
		
		open_panel = panel;
		open_panel.open(data);

func _on_close_panel(panel_name: String) -> void:
	var panel: BasePanel = panels.get(panel_name);
	
	if panel and panel == open_panel:
		open_panel.close();
		open_panel = null;
