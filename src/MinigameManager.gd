extends Node2D

onready var captchaMiniGame = preload("res://src/CaptchaGame/CaptchaGame.tscn")
onready var buttonMashMiniGame = preload("res://src/ButtonMashGame/ButtonMashGame.tscn")

## Core functions
func _init() -> void:
	# Register to something which tells us to close the current mini game, then we can remove it respecitvely.
	pass

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.scancode == KEY_1 and event.pressed:
		var instance = captchaMiniGame.instance()
		add_child(instance)
	elif event.scancode == KEY_2 and event.pressed:
		var instance = buttonMashMiniGame.instance()
		add_child(instance)

## Public functions
func LoadCaptcha() -> void:
	var instance = captchaMiniGame.instance()
	add_child(instance)


func LoadButtonMash() -> void:
	var instance = buttonMashMiniGame.instance()
	add_child(instance)
