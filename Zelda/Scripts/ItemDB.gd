extends Node2D

const ITEM_PATH = "res://items/"
const ITEMS = {
	"bow": {
		"icon": ITEM_PATH + "bow.png",
		"slot": "MAIN_HAND"
	}
}


func get_item(item_id):
	if item_id in ITEMS:
		return ITEMS[item_id]
	else:
		return ITEMS["error"]

func _ready():
	pass
