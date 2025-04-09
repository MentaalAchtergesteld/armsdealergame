class_name InventoryList
extends VBoxContainer

func update_list(inventory: Dictionary[Good, int]) -> void:
	for child in get_children():
		remove_child(child);
	
	for good in inventory:
		var quantity = inventory[good];
		var listing = GoodListing.create(good, quantity);
		add_child(listing);
