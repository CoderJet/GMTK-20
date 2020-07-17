extends Control


onready var header_time = $RemainingTime
onready var header_progress_bar = $Header_full

var target_val = 100
var animate = false

func _process(delta):
	if animate:
		header_progress_bar.value -= delta * 10
		if header_progress_bar.value < target_val:
			header_progress_bar.value = target_val
			animate = false

func _update_time(time_str : String) -> void:
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

