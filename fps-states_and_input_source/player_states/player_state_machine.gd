class_name PlayerStateMachine
extends StateMachine


@export var player: PlayerController

@export var idle_state: PlayerIdleState
@export var walk_state: PlayerWalkState
@export var running_state: PlayerRunningState
@export var jump_state: PlayerJumpState
@export var fall_state: PlayerFallState


func change_to_idle() -> bool:
	return change_state(idle_state)


func change_to_walk() -> bool:
	return change_state(walk_state)


func change_to_running() -> bool:
	return change_state(running_state)


func change_to_jump() -> bool:
	return change_state(jump_state)


func change_to_fall() -> bool:
	return change_state(fall_state)
