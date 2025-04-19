class_name UIProviderManager
extends Node

static var manager: UIProviderManager = null;

@export var providers: Array[Node] = [];

func get_provider(provider_class: Script) -> Node:
	for provider in providers:
		if provider.get_script() == provider_class:
			return provider;
	return null; 

func _enter_tree() -> void:
	add_to_group("UIProviderManager", true);
	manager = self;

func _exit_tree() -> void:
	if UIProviderManager.manager == self:
		UIProviderManager.manager = null;
