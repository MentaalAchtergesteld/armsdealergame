extends Node

signal toggle_panel(panel_name: String, data: Dictionary);
signal open_panel(panel_name: String, data: Dictionary);
signal close_panel(panel_name: String);

signal opened_panel(panel_name: String, data: Dictionary);
signal closed_panel(panel_name: String, data: Dictionary);
