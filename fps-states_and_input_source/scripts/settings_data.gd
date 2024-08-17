class_name SettingsData
extends Resource

@export var input_type := InputSource.InputType.AutoDetect
@export var horizontal_axis_direction := InputSource.AxisDirection.Default
@export var vertical_axis_direction := InputSource.AxisDirection.Default
@export var controller_camera_speed: float
@export var mouse_sensitivity: float


## Applies the current values to the provided input_source
func apply_to_input_source(input_source: InputSource) -> void:
	assert(input_source, "SettingsData: input_source can't be null")
	
	input_source.input_type = input_type
	input_source.look_horizontal_axis_direction = horizontal_axis_direction
	input_source.look_vertical_axis_direction = vertical_axis_direction
	input_source.controller_camera_speed = controller_camera_speed
	input_source.mouse_sensitivity = mouse_sensitivity


## Reads the current values from input_source and updates the
## SettingsData properties
func set_from_input_source(input_source: InputSource) -> void:
	assert(input_source, "SettingsData: input_source can't be null")
	
	input_type = input_source.input_type
	horizontal_axis_direction = input_source.look_horizontal_axis_direction
	vertical_axis_direction = input_source.look_vertical_axis_direction
	controller_camera_speed = input_source.controller_camera_speed
	mouse_sensitivity = input_source.mouse_sensitivity
	
	print(horizontal_axis_direction, " ", vertical_axis_direction)


