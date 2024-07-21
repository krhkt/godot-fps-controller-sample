class_name State
extends Node3D
## Abstract base state class

@export var state_machine: StateMachine = null


## Guard method called before transition to this state from
## the `from_state` provided
func can_enter_from(_from_state: State) -> bool:
	return true


## Guard method called before transition from this to the `to_state`
## provided
func can_exit_to(_to_state: State) -> bool:
	return true


## Callback executed when the state is successfully entered
func on_entered(_from: State) -> void:
	pass


## Callback executed when is about to be exited
func on_exited(_to: State) -> void:
	pass


## State's version of Godot's _process(_delta)
func state_process(_delta: float) -> void:
	pass


## State's version of Godot's _physics_process(_delta)
func state_physics_process(_delta: float) -> void:
	pass
