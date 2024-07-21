class_name PlayerIdleState
extends PlayerBaseState


func can_enter_from(_from: State) -> bool:
	return not player.velocity


func state_physics_process(_delta: float) -> void:
	player.process_look_around()
	
	if not player.is_on_floor():
		state_machine.change_to_fall()
		return
	
	if player.tried_to_jump():
		state_machine.change_to_jump()
		return
	
	if not input_source.has_movement_input():
		return
	
	if input_source.is_run_pressed:
		state_machine.change_to_running()
	else:
		state_machine.change_to_walk()
