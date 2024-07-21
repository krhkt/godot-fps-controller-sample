class_name Player
extends CharacterBody3D

@export var walk_speed := 5.0
@export var running_speed := 9.0
@export var stop_friction := 4.0
@export var jump_velocity := 7.0
@export var jump_velocity_running := 10.0
@export var camera_speed := 1.2

var gravity := ProjectSettings.get_setting("physics/3d/default_gravity") as float
var current_speed: float: get = _get_current_speed
var current_direction: Vector3: get = _get_current_direction
var is_running := false

@onready var player_camera := %PlayerCamera as Camera3D


#region [ Godot API ]
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	_process_jump()
	_process_movement(delta)
	_process_look_around()
	
	move_and_slide()
#endregion


#region [ Getters / Setters ]
func _get_current_speed() -> float:
	return running_speed if is_running else walk_speed


func _get_current_direction() -> Vector3:
	var direction := Input.get_vector(
		&"strafe_left", &"strafe_right",
		&"move_forward", &"move_backward"
	)
	return (transform.basis * Vector3(direction.x, 0, direction.y)).normalized()
#endregion


#region [ Input process ]
func _process_jump() -> void:
	if Input.is_action_just_pressed(&"jump") and is_on_floor():
		velocity.y = (jump_velocity_running if is_running else jump_velocity)


func _process_movement(delta: float) -> void:
	if Input.is_action_just_pressed(&"run") and is_on_floor():
		is_running = not is_running
	
	var input_direction := current_direction
	if input_direction:
		velocity.x = input_direction.x * current_speed
		velocity.z = input_direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed * stop_friction* delta)
		velocity.z = move_toward(velocity.z, 0, current_speed * stop_friction * delta)
	
	if not velocity:
		is_running = false


func _process_look_around() -> void:
	var input_direction := Input.get_vector(
		&"look_right", &"look_left",
		&"look_up", &"look_down"
	)
	
	var look_direction := input_direction / 8.0 * camera_speed
	if not look_direction:
		return
	
	rotate_y(look_direction.x)
	player_camera.rotate_x(-look_direction.y)
	var x_axis_rotation := player_camera.rotation_degrees.x
	player_camera.rotation_degrees.x = clampf(x_axis_rotation, -80.0, 80.0)
#endregion
