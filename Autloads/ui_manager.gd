extends Node

signal panel_opened(panel: BasePanel);
signal panel_closed(panel: BasePanel);

var COUNTRY_PANEL = preload("res://UI/CountryPanel/country_panel.tscn").instantiate();
var CONTRACT_PANEL = preload("res://UI/ContractPanel/contract_panel.tscn").instantiate();

var current_panel: BasePanel;

var ui_parent: Control;

func open_panel(panel: BasePanel, data: Dictionary) -> void:
	if ui_parent != null: return;
	close_panel();
	
	current_panel = panel;
	ui_parent.add_child(current_panel);
	current_panel.open(data);
	panel_opened.emit(current_panel);

func close_panel() -> void:
	if ui_parent != null: return;
	if current_panel:
		current_panel.close();
		ui_parent.remove_child(current_panel);
		panel_closed.emit(current_panel);
		current_panel = null;
