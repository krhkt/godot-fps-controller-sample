class_name PlayerController
extends CharacterBody3D

@export var input_source: InputSource
@export var buffer_frames_window := 10
@export var movement_data := PlayerMovementData.new()

var gravity := (ProjectSettings.get_setting("physics/3d/default_gravity") as float) * 2.0
var current_direction: Vector3:
	get = _get_current_direction
var current_state_name: String:
	get = _get_current_state_name

@onready var player_camera := %PlayerCamera as Camera3D
@onready var state_machine: PlayerStateMachine = %PlayerStateMachine


#region [ Godot API ]
func _ready() -> void:
	state_machine.change_to_idle()


func _physics_process(delta: float) -> void:
	if not input_source:
		return
	
	state_machine.state_physics_process(delta)
#endregion


#region [ Getters / Setters ]
func _get_current_direction() -> Vector3:
	var direction := input_source.movement_direction
	return (transform.basis * direction).normalized()


func _get_current_state_name() -> String:
	var current_state := state_machine.current_state
	return current_state.name
#endregion


#region [ Public API ]
func apply_movement_data_to_player(data: PlayerMovementData) -> void:
	movement_data.apply_from_data(data)


func tried_to_jump() -> bool:
	return is_on_floor() and input_source.was_jump_pressed_in(buffer_frames_window)
#endregion


#region [ Movement process ]
func jump() -> void:
	velocity.y = movement_data.jump_velocity


func process_horizontal_movement(delta: float) -> void:
	var input_direction := current_direction
	if input_direction:
		velocity.x = input_direction.x * movement_data.speed * delta
		velocity.z = input_direction.z * movement_data.speed * delta
	else:
		velocity.x = move_toward(
			velocity.x, 0, movement_data.speed * movement_data.deceleration * delta
		)
		velocity.z = move_toward(
			velocity.z, 0, movement_data.speed * movement_data.deceleration * delta
		)


func process_vertical_movement(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
		velocity.y = maxf(velocity.y, -movement_data.terminal_velocity)


func process_look_around() -> void:
	var look_direction := input_source.look_direction
	if not look_direction:
		return
	
	rotate_y(look_direction.x)
	player_camera.rotate_x(look_direction.y)
	var x_axis_rotation := player_camera.rotation_degrees.x
	player_camera.rotation_degrees.x = clampf(x_axis_rotation, -80.0, 80.0)
#endregion
