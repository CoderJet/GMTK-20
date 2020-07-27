extends Control
class_name ModuleCore
## Enums
enum WINDOW_RESULT {
	SUBMIT = 0,
	MINIMISE,
	CLOSE
}
## Signals
signal finished(window_result, data_dict)
## Variables
var anim_tween : Tween
var current_module = GLOBALS.MODULE.SECURITY
var current_difficulty : int = 1

## Public functions
## Animations
func perform_opening_animation() -> void:
	anim_tween.interpolate_property(self, "rect_scale", Vector2(1, 0), Vector2(1, 1), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	anim_tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0.5), Color(1, 1, 1, 1), 0.09, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	anim_tween.start()
	yield(anim_tween, "tween_completed")


func perform_closing_animation() -> void:
	anim_tween.interpolate_property(self, "rect_scale", Vector2(1, 1), Vector2(1, 0), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	anim_tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0.5), 0.09, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	anim_tween.start()
	yield(anim_tween, "tween_completed")

## Helper functions
func initialise(module : int, difficulty : int = 1) -> void:
	current_module = module
	current_difficulty = difficulty


## Godot core loops
func _init() -> void:
	anim_tween = Tween.new()
	add_child(anim_tween)
