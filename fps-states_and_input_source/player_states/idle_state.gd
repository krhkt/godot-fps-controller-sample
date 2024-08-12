class_name PlayerIdleState
extends PlayerBaseState


func can_enter_from(_from: State) -> bool:
	return not player.velocity


func state_physics_process(_delta: float) -> void:
	player.process_look_around()
	
	if state_machine.change_to_fall(): return
	if state_machine.change_to_jump(): return
	if state_machine.change_to_running(): return
	if state_machine.change_to_walk(): return
