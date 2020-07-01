extends Label

var current_score

func _ready():
	self.text = "You've reached " + str(current_score) + " points"

