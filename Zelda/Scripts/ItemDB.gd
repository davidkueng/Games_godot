extends Node2D

const ITEM_PATH = "res://Assets/"
const ITEMS = {
	"bow": {
		"icon": ITEM_PATH + "bow.png",
		"slot": "WEAPON"
	},
	"axe": {
		"icon": ITEM_PATH + "axe.png",
		"slot": "WEAPON"
	}
}

func get_item(item_id):
	if item_id in ITEMS:
		return ITEMS[item_id]
	else:
		return ITEMS["error"]
