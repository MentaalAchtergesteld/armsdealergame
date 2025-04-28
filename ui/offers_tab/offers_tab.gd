@tool
class_name OffersTab
extends PanelContainer

@export var offers: Array[MarketItem]:
	set(value):
		offers = value;
		update_offers();

#var offer_listings: Array[OfferListing];

func update_offers() -> void:
	pass;
