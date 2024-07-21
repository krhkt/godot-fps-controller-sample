class_name StateMachine
extends Node3D

var current_state: State = null


func change_state(target_state: State) -> bool:
	if current_state == target_state:
		return false
	
	if current_state and not current_state.can_exit_to(target_state):
		return false
	
	if not target_state.can_enter_from(current_state):
		return false
	
	if current_state:
		current_state.on_exited(target_state)
	
	var previous_state := current_state
	current_state = target_state
	target_state.on_entered(previous_state)
	return true


func state_process(delta: float) -> void:
	if not current_state:
		return
	
	current_state.state_process(delta)


func state_physics_process(delta: float) -> void:
	if not current_state:
		return
	
	current_state.state_physics_process(delta)
