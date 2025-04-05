class_name HUD
extends CanvasLayer

func _on_contracts_button_pressed() -> void:
	UIEventBus.toggle_panel.emit("contract", {});
