class_name ResourceLocator
extends Node

var resources: Dictionary = {};

func register_resource(resource: Node) -> void:
	var resource_type = resource.get_script();
	
	resources[resource_type] = resource;

func get_resource(type: Script) -> Node:
	return resources.get(type, null);
