extends Node

signal toggle_panel(panel_name: String, data: Dictionary);
signal open_panel(panel_name: String, data: Dictionary);
signal close_panel(panel_name: String);

signal opened_panel(panel: BasePanel);
signal closed_panel(panel: BasePanel);

signal time_updated(time: float);
signal time_speed_changed(speed: float);
signal time_paused;
signal time_resumed;
