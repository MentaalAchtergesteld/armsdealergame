class_name PanelManager
extends Control

var panels: Dictionary[String, BasePanel] = {};

var open_panel: BasePanel = null;

func load_panels() -> void:
	for child in get_children():
		if child is not BasePanel: continue;
		panels[child.panel_name] = child;
		child.panel_closed.connect(_on_panel_closed.bind(child));
		child.panel_opened.connect(_on_panel_opened.bind(child));

func _ready() -> void:
	load_panels();
	
	UIEventBus.toggle_panel.connect(_on_toggle_panel);
	UIEventBus.open_panel.connect(_on_open_panel);
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
	if open_panel == panels.get(panel_name):
		open_panel.close();
		open_panel = null;

func _on_panel_closed(panel: BasePanel) -> void:
	if open_panel == panel:
		open_panel = null;
	UIEventBus.closed_panel.emit(panel);

func _on_panel_opened(panel: BasePanel) -> void:
	UIEventBus.opened_panel.emit(panel);
