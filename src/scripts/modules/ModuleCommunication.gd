extends ModuleWindowCore


enum CALL_TYPE {
	PERSONAL = 0,
	WORK,
}

## Window
onready var window = get_node("Window")
## Avatars
onready var female_avatar = get_node("Window/Avatars/FemalePortrait")
onready var male_avatar = get_node("Window/Avatars/MalePortrait")
onready var contact_name = get_node("Window/Avatars/ContactName")
## Switch controls
onready var slider = get_node("Window/SlideBackground/SliderPickup")
onready var slider_anim = get_node("Window/SlideBackground/AnimationPlayer")

export (String, MULTILINE) var PersonalFemales
export (String, MULTILINE) var PersonalMales

export (String, MULTILINE) var WorkFemales
export (String, MULTILINE) var WorkMales

var pickup_has_focus = false
var start_pos := Vector2()
var curr_pos := Vector2()

var current_call_type = CALL_TYPE.PERSONAL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window.window_title = "Tele-Comms"
	window.flavour_text = ""

	current_call_type = CALL_TYPE.WORK if randf() > 0.5 else CALL_TYPE.PERSONAL
	randomize()

	if current_call_type == CALL_TYPE.PERSONAL:
		if randf() > 0.25:
			var items = PersonalFemales.split('\n')
			contact_name.text = items[randi() % items.size()].strip_edges()
			female_avatar.visible = true
		else:
			var items = PersonalMales.split('\n')
			contact_name.text = items[randi() % items.size()].strip_edges()
			male_avatar.visible = true
	else:
		if randf() > 0.5:
			var items = WorkFemales.split('\n')
			contact_name.text = items[randi() % items.size()].strip_edges()
			female_avatar.visible = true
		else:
			var items = WorkMales.split('\n')
			contact_name.text = items[randi() % items.size()].strip_edges()
			male_avatar.visible = true
	yield(perform_opening_animation(), "completed")

func _process(delta: float) -> void:
	if slider.rect_position.x == 256:
		slider_anim.play("Fade")

func _input(event: InputEvent) -> void:
	if event is InputEventMouse and pickup_has_focus:
		curr_pos = get_global_mouse_position()
		var diff = curr_pos.x - start_pos.x

		if slider.rect_position.x < 128:
			slider.rect_position.x = max(0, min(256, diff))
		else:
			slider.rect_position.x = 256

func _on_SliderPickup_button_down() -> void:
	pickup_has_focus = true
	curr_pos = get_global_mouse_position()
	start_pos = curr_pos
	#print_debug("Gained Focus")


func _on_SliderPickup_button_up() -> void:
	pickup_has_focus = false

	if slider.rect_position.x < 64:
		slider.rect_position.x = 0
	else:
		slider.rect_position.x = 256


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	slider_anim.stop()
	$Window/SlideBackground.visible =false
	slider.rect_position.x = 0

	_on_submit(true)


func _on_ButtonHangUp_pressed() -> void:
	_on_submit(false)


func _on_submit(success : bool) -> void:
	yield(perform_closing_animation(), "completed")
	# Submit the text
	emit_signal("finished", WINDOW_RESULT.SUBMIT if success else WINDOW_RESULT.CLOSE,
	{
		"module"	: current_module,
		"value" 	: success,
	})
