extends Node
class_name ModuleJobs

var continent_contractor := GLOBALS.CONTINENT
var continent_target := GLOBALS.CONTINENT

var job_type := GLOBALS.MODULE

var remaining_time : int = 0
var completed : bool = false
var flavour_text := String()

func create_job() -> ModuleJobs:
	var result := ModuleJobs.new()

	return result


func _generate_job() -> void:
	pass
