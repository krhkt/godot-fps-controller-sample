class_name SettingsData
extends Resource

@export var input_type: InputSource.InputType
@export var horizontal_axis_direction: int
@export var vertical_axis_direction: int
@export var controller_camera_speed: float
@export var mouse_sensitivity: float


func update_input_source(input_source: InputSource) -> void:
	input_source.input_type = input_type
	input_source.look_horizontal_axis_direction = horizontal_axis_direction
	input_source.look_vertical_axis_direction = vertical_axis_direction
	input_source.contrller_camera_speed = controller_camera_speed
	input_source.mouse_sensitivity = mouse_sensitivity


func set_from_input_source(input_source: InputSource) -> void:
	input_type = input_source.input_type
	horizontal_axis_direction = input_source.look_horizontal_axis_direction
	vertical_axis_direction = input_source.look_vertical_axis_direction
	controller_camera_speed = input_source.contrller_camera_speed
	mouse_sensitivity = input_source.mouse_sensitivity
