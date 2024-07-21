class_name PlayerJumpState
extends PlayerBaseState

var movement_direction_on_jump := Vector3.ZERO


func can_enter_from(_from: State) -> bool:
	return player.tried_to_jump()


func on_entered(_from: State) -> void:
	movement_direction_on_jump = input_source.movement_direction
	player.jump()


func state_physics_process(delta: float) -> void:
	player.process_look_around()
	player.process_horizontal_movement(delta)
	player.process_vertical_movement(delta)
	player.move_and_slide()
	
	if player.velocity.y < 0:
		state_machine.change_to_fall()
		return
	
	if not player.is_on_floor(): return
	
	if state_machine.change_to_idle(): return
	if state_machine.change_to_running(): return
	if state_machine.change_to_walk(): return
