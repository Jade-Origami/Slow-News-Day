extends Node

var current_step := 0
var agitate_var = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if agitate_var:
		if agitate_object($"."):
			agitate_var = false


var rotate_steps = [0.05,0.1,0.05,0,-0.05,-0.05,-0.1,-0.1,-0.1,0.05,-0.05,0,0.05,0.1,0.05]
func agitate_object(which_object) -> bool:
	which_object.rotate(rotate_steps[which_object.current_step])
	which_object.current_step += 1
	if which_object.current_step == rotate_steps.size():
		which_object.current_step = 0
		return true
	else:
		return false

func agitate():
	agitate_var = true
