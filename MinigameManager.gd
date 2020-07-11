extends Node2D

onready var captchaMiniGame = preload("res://src/CaptchaGame/CaptchaGame.tscn")

## Core functions
func _init() -> void:
	# Register to something which tells us to close the current mini game, then we can remove it respecitvely.
	pass

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.scancode == KEY_SPACE and event.pressed:
		# Load a minigame randomly, for now
		var instance = captchaMiniGame.instance()
		add_child(instance)

## Public functions
func LoadCaptcha() -> void:
	# Load a minigame randomly, for now
	var instance = captchaMiniGame.instance()
	add_child(instance)
