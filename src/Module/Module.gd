extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var title = "Title"
export var description = "Description"
var disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Title.text = title
	$Description.text = description
	$Progress.value = 1
	
func _disable():
	$ModuleButton.disabled = true
	modulate.a = 0.5
	
func _enable():
	$ModuleButton.disabled = false
	modulate.a = 1
	
func _module_update(sub_val):
	$Progress.value = sub_val
	
	if sub_val == 0:
		_disable()
		disabled = true
	elif disabled:
		_enable()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
