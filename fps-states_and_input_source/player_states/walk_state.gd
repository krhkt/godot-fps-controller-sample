class_name PlayerWalkState
extends PlayerBaseState

@export var movement_data: PlayerMovementData


func can_enter_from(_from: State) -> bool:
	return (
			input_source.has_movement_input()
			and player.is_on_floor() 
			and (not input_source.is_run_pressed)
	)


func on_entered(_from: State) -> void:
	player.apply_movement_data_to_player(movement_data)


func state_physics_process(delta: float) -> void:
	player.process_look_around()
	player.process_horizontal_movement(delta)
	player.move_and_slide()
	
	if state_machine.change_to_fall(): return
	if state_machine.change_to_idle(): return
	if state_machine.change_to_jump(): return
	if state_machine.change_to_running(): return
