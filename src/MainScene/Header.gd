extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var header_time = $RemainingTime
onready var header_progress_bar = $Header_full

var target_val = 100
var animate = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if animate:
		header_progress_bar.value -= delta * 10
		if header_progress_bar.value < target_val:
			header_progress_bar.value = target_val
			animate = false
		pass

	pass

func _update_time(time_str):
	header_time.text = time_str

func _shield_down(shield_level):
	match(shield_level):
		3:
			#header_progress_bar.value = 65
			target_val = 68.7
			animate = true
		2:
			target_val = 34.8
			animate = true
		1:
			target_val = 1
			animate = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
