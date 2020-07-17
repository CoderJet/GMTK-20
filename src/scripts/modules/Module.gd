extends Control

export(NodePath) var manager_path
onready var manager = get_node(manager_path)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var title = "Title"
export var description = "Description"
export(GLOBALS.MODULE) var module = GLOBALS.MODULE.SECURITY
var disabled = false


func _ready():
	get_node("/root/GameRoot/MainGame").connect("module_update", self, "_module_update")

	$Title.text = title
	$Description.text = description
	$Progress.value = 1

func _disable():
	$ModuleButton.disabled = true
	modulate.a = 0.5

func _enable():
	$ModuleButton.disabled = false
	modulate.a = 1

func _button_press():
	randomize()

	if module == GLOBALS.MODULE.SECURITY:
		manager.open_captcha_game(module)
	elif module == GLOBALS.MODULE.SOFTWARE_INTEGRITY:
		if randf() <= 0.5:
			manager.open_button_mash_game(module)
		else:
			manager.open_captcha_game(module)
	elif module == GLOBALS.MODULE.POWER_SUPPLY:
		manager.open_space_mash_game(module)
	elif module == GLOBALS.MODULE.COMMUNICATION:
		if randf() <= 0.5:
			manager.open_button_mash_game(module)
		else:
			manager.open_switch_game(module)

func _module_update(key, sub_val):
	if key != module:
		return
	print(sub_val)
	$Progress.value = sub_val

	if sub_val == 0:
		_disable()
		disabled = true
	elif disabled:
		_enable()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
