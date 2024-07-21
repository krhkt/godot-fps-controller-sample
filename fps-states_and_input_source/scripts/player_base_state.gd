class_name PlayerBaseState
extends State
## Abstract base player state class

var player: PlayerController:
	get = _get_player

var input_source: InputSource:
	get = _get_input_source


func _get_player() -> PlayerController:
	return state_machine.player


func _get_input_source() -> InputSource:
	return state_machine.player.input_source
