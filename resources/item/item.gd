class_name Item
extends Resource

const DEFAULT_ICON = preload("res://assets/good_icons/default.svg");

@export var name: String = "Item";
@export var plural: String = "Items";

@export_multiline var description: String = "A Boring Item.";
@export var icon: Texture2D = DEFAULT_ICON;
