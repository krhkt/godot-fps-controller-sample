class_name PlayerFallState
extends PlayerBaseState


func can_enter_from(_from: State) -> bool:
	return not player.is_on_floor()


func state_physics_process(delta: float) -> void:
	player.process_look_around()
	player.process_horizontal_movement(delta)
	player.process_vertical_movement(delta)
	player.move_and_slide()
	
	if not player.is_on_floor():
		return
	
	elif not player.velocity:
		state_machine.change_to_idle()
	elif input_source.is_run_pressed:
		state_machine.change_to_running()
	else:
		state_machine.change_to_walk()
