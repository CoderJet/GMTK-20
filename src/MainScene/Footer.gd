extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var whoops_text = $"WHOOPS Footer"
onready var whoops_scroll_in = $"WHOOPS Footer Scroll"
export(float) var speed = 100
var anim = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#whoops_text.rect_position.x = -whoops_text.rect_size.x;
	whoops_scroll_in.rect_position.x = -whoops_scroll_in.rect_size.x
	
	
	#pass # Replace with function body.

func _start_animation():
	anim = true

func _stop_animation():
	anim = false

func _forward(delta, thing):
	if thing.rect_position.x < 0:
		var scroll = speed
		if thing.rect_size.x - thing.rect_position.x < scroll:
			scroll = thing.rect_size.x - thing.rect_position.x
		
		thing.rect_position.x += scroll
		
	return !(thing.rect_position.x < 0)

func _backward(delta, thing):
	if thing.rect_position.x > -thing.rect_size.x:
		var scroll = -speed
		if thing.rect_size.x - thing.rect_position.x < scroll:
			scroll = -(thing.rect_size.x - thing.rect_position.x)
		
		thing.rect_position.x += scroll
	
	return !(thing.rect_position.x > -thing.rect_size.x)

var swap = true
func _process(delta):
	
	if !anim:
		return
	
	if swap:
		if _forward(delta, whoops_scroll_in):
			swap = false
	else:
		whoops_text.visible = true
		_backward(delta, whoops_scroll_in)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
