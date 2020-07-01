extends Label

onready var effect = $effect

func _ready():
	effect.interpolate_property(self, "modulate:a", 1.0, 0.0, 15, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	effect.start()

func _on_effect_tween_completed(_object, _key):
	queue_free()
