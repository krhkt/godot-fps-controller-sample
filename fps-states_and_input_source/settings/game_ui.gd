class_name GameUi
extends CanvasLayer

signal settings_updated(settings_data: SettingsData)
signal close_settings_requested()
signal quit_game_requested()

var settings_data: SettingsData : set = _set_settings_data
var is_open: bool : get = _get_is_open

var _input_scheme_in_use: InputSource.InputType

#region [ Control scheme display ]
@onready var settings_controls_label := %SettingsControlsLabel as Label
@onready var controller_scheme_label := %ControllerSchemeLabel as Label
@onready var kb_mouse_scheme_label := %KbMouseSchemeLabel as Label
@onready var state_name_display := %StateNameDisplay as Label
@onready var control_settings := $ControlSettings as Control
#endregion


#region [ settings inputs ]
@onready var input_type_value := %InputTypeValue as OptionButton
@onready var vertical_axis_value := %VerticalAxisValue as OptionButton
@onready var horizontal_axis_value := %HorizontalAxisValue as OptionButton
@onready var controller_camera_speed_field := %ControllerCameraSpeedField as SliderLabelField
@onready var mouse_sensitivity_field := %MouseSensitivityField as SliderLabelField
#endregion


#region [ Public API ]
func open_settings() -> bool:
	if is_open: return false
	
	input_type_value.grab_focus()
	control_settings.visible = true
	display_settings_controls()
	return true


func close_settings() -> bool:
	if not is_open: return false
	
	control_settings.visible = false
	return true


func update_control_scheme_display(input_type: int) -> void:
	settings_controls_label.visible = false
	kb_mouse_scheme_label.visible = false
	controller_scheme_label.visible = false
	
	if input_type == InputSource.InputType.Controller:
		controller_scheme_label.visible = true
	else:
		kb_mouse_scheme_label.visible = true
	
	_input_scheme_in_use = input_type
	display_settings_controls()


func display_settings_controls() -> void:
	if not is_open: return
	
	if _input_scheme_in_use == InputSource.InputType.KeyboardMouse: return
	
	settings_controls_label.visible = true
	kb_mouse_scheme_label.visible = false
	controller_scheme_label.visible = false


func update_state_name(player_state_name: String) -> void:
	state_name_display.text = "(%s)" % player_state_name
#endregion


#region [ Getters / Setters ]
func _get_is_open() -> bool:
	return control_settings.visible

func _set_settings_data(value: SettingsData) -> void:
	settings_data = value
	_update_inputs()
#endregion


## Applies the current settings_data to the settings controls
func _update_inputs() -> void:
	input_type_value.select(settings_data.input_type)
	_select_by_id(vertical_axis_value,
			_axis_direction_to_option_id(settings_data.vertical_axis_direction))
	_select_by_id(horizontal_axis_value,
			_axis_direction_to_option_id(settings_data.horizontal_axis_direction))
	controller_camera_speed_field.value = settings_data.controller_camera_speed
	mouse_sensitivity_field.value = settings_data.mouse_sensitivity


## Helper function to set a OptionButton value by id
func _select_by_id(option: OptionButton, id: int) -> void:
	for i in range(0, option.item_count):
		if option.get_item_id(i) == id:
			option.select(i)
			return


#region [ Conversions ]
# from:  0, 1, 2
#   to: -1, 0, 1
func _option_id_to_axis_direction(value: int) -> InputSource.AxisDirection:
	return (value - 1) as InputSource.AxisDirection


# from: -1, 0, 1
#   to:  0, 1, 2
func _axis_direction_to_option_id(value: InputSource.AxisDirection) -> int:
	return value + 1
#endregion


#region [ Signal handlers  ]
func _on_close_button_pressed() -> void:
	close_settings_requested.emit()


func _on_quit_game_button_pressed() -> void:
	quit_game_requested.emit()


func _on_input_type_value_item_selected(index: int) -> void:
	if not settings_data: return
	
	settings_data.input_type = (index as InputSource.InputType)
	settings_updated.emit(settings_data)


func _on_vertical_axis_value_item_selected(_index: int) -> void:
	if not settings_data: return
	
	var value := vertical_axis_value.get_selected_id()
	settings_data.vertical_axis_direction = _option_id_to_axis_direction(value)
	settings_updated.emit(settings_data)


func _on_horizontal_axis_value_item_selected(_index: int) -> void:
	if not settings_data: return
	
	var value := horizontal_axis_value.get_selected_id()
	settings_data.horizontal_axis_direction = _option_id_to_axis_direction(value)
	settings_updated.emit(settings_data)


func _on_controller_camera_speed_field_value_changed(value: float) -> void:
	if not settings_data: return
	
	settings_data.controller_camera_speed = value
	settings_updated.emit(settings_data)


func _on_mouse_sensitivity_field_value_changed(value: float) -> void:
	if not settings_data: return
	
	settings_data.mouse_sensitivity = value
	settings_updated.emit(settings_data)
#endregion
