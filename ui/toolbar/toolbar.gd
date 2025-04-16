class_name Toolbar
extends PanelContainer

func _on_contracts_pressed() -> void:
	UIEventBus.toggle_panel.emit("contracts", {});
