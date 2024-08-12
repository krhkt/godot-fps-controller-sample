class_name InputSource
extends Node

signal input_type_changed(input_type: int)

## Input types supported.
enum InputType { 
	AutoDetect,
	Controller,
	KeyboardMouse
}

# list of all actions that have to be added to the project
const ACTION_MOVE_FORWARD = &"move_forward"
const ACTION_MOVE_BACKWARD = &"move_backward"
const ACTION_STRAFE_LEFT = &"strafe_left"
const ACTION_STRAFE_RIGHT = &"strafe_right"
const ACTION_LOOK_UP = &"look_up"
const ACTION_LOOK_DOWN = &"look_down"
const ACTION_LOOK_LEFT = &"look_left"
const ACTION_LOOK_RIGHT = &"look_right"
const ACTION_JUMP = &"jump"
const ACTION_RUN = &"run"
const ACTION_SETTINGS = &"settings"

## Input type behavior: [br]
##   - [b]AutoDetect[/b]: will change between KBM and Controller based on input[br]
##   - [b]Controller[/b]: locks the input to be controller only[br]
##   - [b]KeyboardMouse[/b]: locks the input to be Keyboard and Mouse only
@export var input_type: InputType = InputType.AutoDetect

## The positive direction of horizontal axis of camera movement.
@export_enum(&"Default:1", &"Inverted:-1", &"Locked:0")
var look_horizontal_axis_direction := 1

## The positive direction of vertical axis of camera movement.
@export_enum(&"Default:1", &"Inverted:-1", &"Locked:0")
var look_vertical_axis_direction := 1

## Deadzone of the controller movement input: 
##    strafe_left, strafe_right, move_forward, move_backward.
@export var input_axis_deadzone := 0.25

## How fast the controller can move the camera.
@export_range(.1, 2.0, 0.2)
var controller_camera_speed := 0.5

## Sensitivity of mouse movement. The higher the number, the more sensible
## the movement is.
@export_range(.5, 50.0, 0.5)
var mouse_sensitivity := 5.0

## Defines the acceleration curve that influences 
## how the horizontal velocity of the mouse movement should behave.
@export var mouse_horizontal_acceleration_curve: Curve = null

## Defines the acceleration curve that influences 
## how the vertical velocity of the mouse movement should behave.
@export var mouse_vertical_acceleration_curve: Curve = null


var is_mouse_captured: bool:
	get = _get_is_mouse_captured
var input_scheme_in_use := InputType.KeyboardMouse
var movement_direction := Vector3.ZERO
var look_direction := Vector2.ZERO
var is_run_pressed := false
var is_jump_pressed := false
var frames_since_jump_last_pressed := -1.0
var is_settings_just_pressed := false


#region [ Godot API ]
func _ready() -> void:
	if input_scheme_in_use != InputType.AutoDetect:
		input_scheme_in_use = input_type
	capture_mouse()


func _input(event: InputEvent) -> void:
	if input_scheme_in_use == InputType.KeyboardMouse and event is InputEventMouseMotion:
		_read_look_around_input_from_mouse(event)
	
	if input_type != InputType.AutoDetect: return
	
	var old_input_scheme := input_scheme_in_use
	if event is InputEventKey:
		input_scheme_in_use = InputType.KeyboardMouse
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		input_scheme_in_use = InputType.Controller
	
	if old_input_scheme != input_scheme_in_use:
		input_type_changed.emit(input_scheme_in_use)


func _process(_delta: float) -> void:
	_read_look_around_input()
	_read_direction_input()
	_read_run()
	_read_jump()
	_read_settings()
#endregion


#region [ Public API ]
## Returns if there's any movement input on the current frame.
func has_movement_input() -> bool:
	return movement_direction != Vector3.ZERO


## Changes the mouse mode to be captured by the game window and locking it at 
## its center.
func capture_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


## Changes the mouse mode to be visible, which is the default behavior of 
## the operating system.
func uncapture_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


## Checks if the jump action was pressed between now and (now - frames_window).
func was_jump_pressed_in(frames_window: float) -> bool:
	return frames_window >= frames_since_jump_last_pressed
#endregion


#region [ Getters / Setters ]
func _get_is_mouse_captured() -> bool:
	return Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
#endregion


#region [ Input process ]
func _read_direction_input() -> void:
	var input_axis: Vector2 = Input.get_vector(
			ACTION_STRAFE_LEFT, ACTION_STRAFE_RIGHT, 
			ACTION_MOVE_FORWARD, ACTION_MOVE_BACKWARD,
			input_axis_deadzone
	)
	movement_direction = Vector3(input_axis.x, 0, input_axis.y)


func _read_look_around_input() -> void:
	if input_scheme_in_use != InputType.Controller:
		look_direction = Vector2.ZERO
		return
	
	look_direction = Input.get_vector(
			ACTION_LOOK_LEFT, ACTION_LOOK_RIGHT,
			ACTION_LOOK_UP, ACTION_LOOK_DOWN,
			0.1
	) * controller_camera_speed / 10.0
	
	# applying axis inversions
	look_direction *= Vector2(
			-look_horizontal_axis_direction,
			-look_vertical_axis_direction
	)


func _read_look_around_input_from_mouse(event: InputEventMouseMotion) -> void:
	if not is_mouse_captured:
		return
	
	var mouse_position := event.relative * mouse_sensitivity
	if mouse_position == Vector2.ZERO:
		look_direction = Vector2.ZERO
		return
	
	var available_area := get_viewport().get_visible_rect().size as Vector2
	var mouse_direction := (mouse_position / (available_area / 2)).limit_length()
	
	# applying acceleration curves
	if mouse_horizontal_acceleration_curve:
		mouse_direction.x *= mouse_horizontal_acceleration_curve.sample(abs(mouse_direction.x))
	if mouse_vertical_acceleration_curve:
		mouse_direction.y *= mouse_vertical_acceleration_curve.sample(abs(mouse_direction.y))
	
	# applying axis inversions
	look_direction = mouse_direction * Vector2(
		-look_horizontal_axis_direction,
		-look_vertical_axis_direction
	)


func _read_jump() -> void:
	is_jump_pressed = Input.is_action_pressed(ACTION_JUMP)
	if Input.is_action_just_pressed(ACTION_JUMP):
		frames_since_jump_last_pressed = 0.0
	else:
		frames_since_jump_last_pressed += 1


func _read_run() -> void:
	is_run_pressed = Input.is_action_pressed(ACTION_RUN)


func _read_settings() -> void:
	is_settings_just_pressed = Input.is_action_just_pressed(ACTION_SETTINGS)
#endregion
