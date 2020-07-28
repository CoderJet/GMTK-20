extends Node
class_name WorkDaySystem
## Signals
signal day_ended
signal overtime_ended
## Constants
const INTERVAL : int = 5
const WORK_DAY : int = 240
const OVER_TIME : int = 120
## Exports
export (int, 0, 23, 1) var start_time : int = 8
## Onready nodes
onready var label_time = get_tree().get_root().get_node("TODO")
onready var label_day = get_tree().get_root().get_node("TODO")
onready var elapsed_time = get_node("./Timer")
## Variables
var day_no : int = 0
var time_of_day : int = 0

## Public funtcions
func start_day() -> void:
	_time_formatter()
	elapsed_time.start()


func next_day() ->void:
	day_no += 1
	_day_formatter()

## Private functions
func _time_formatter() -> void:
	var hours = start_time + time_of_day / 30
	var mins = time_of_day % 30 * 2

	if label_time != null:
		label_time.text = "%02d:%02d" % [hours, mins]
	else:
		print_debug("%02d:%02d" % [hours, mins])


func _day_formatter() -> void:
	if label_day != null:
		label_day.text = "Day %02d" % [day_no]
	else:
		print_debug("Day %02d" % [day_no])

## Node signals
func _on_timeout() -> void:
	time_of_day += INTERVAL
	_time_formatter()

	if time_of_day == 240:
		emit_signal("day_ended")
	elif time_of_day >= WORK_DAY + OVER_TIME:
		emit_signal("overtime_ended")

## Godot core functions
func _ready() -> void:
	elapsed_time.wait_time = float(INTERVAL)
	next_day()
	start_day()
