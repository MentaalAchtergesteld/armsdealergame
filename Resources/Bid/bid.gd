class_name Bid
extends Resource

@export var bidder: Country;
@export var offer: float = 0;

static func create(bidder: Country, offer: float) -> Bid:
	var bid = Bid.new();
	bid.bidder = bidder;
	bid.offer = offer;
	return bid;
