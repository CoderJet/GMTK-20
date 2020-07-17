extends Control

onready var shield_1 = $Shield1
onready var shield_2 = $Shield2
onready var shield_3 = $Shield3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _shield_down(shield_level):
	match(shield_level):
		3:
			shield_3.visible = false
			pass
		2:
			shield_2.visible = false
			pass
		1:
			shield_1.visible = false
			pass
