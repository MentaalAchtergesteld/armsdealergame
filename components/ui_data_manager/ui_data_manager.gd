class_name UIProviderManager
extends Node

@export var providers: Array[Node] = [];

func get_provider(provider_class: Script) -> Node:
	for provider in providers:
		if provider.get_script() == provider_class:
			return provider;
	return null; 
