class_name GameUi
extends CanvasLayer

signal settings_updated(settings_data: SettingsData)
signal close_settings_requested()
signal quit_game_requested()

var settings_data: SettingsData : set = _set_settings_data
var is_open: bool : get = _get_is_open

@onready var settings_controls_label := %SettingsControlsLabel as Label
@onready var controller_scheme_label := %ControllerSchemeLabel as Label
@onready var kb_mouse_scheme_label := %KbMouseSchemeLabel as Label
@onready var state_name_display := %StateNameDisplay as Label
@onready var control_settings := $ControlSettings as Control

#region [ settings inputs ]
@onready var input_type_value := %InputTypeValue as OptionButton
@onready var vertical_axis_value := %VerticalAxisValue as OptionButton
@onready var horizontal_axis_value := %HorizontalAxisValue as OptionButton
@onready var controller_camera_speed_value := %ControllerCameraSpeedValue as HSlider
@onready var mouse_sensitivity_value := %MouseSensitivityValue as HSlider
#endregion


func _get_is_open() -> bool:
	return control_settings.visible


func open_settings() -> bool:
	if is_open: return false
	
	display_settings_controls()
	input_type_value.grab_focus()
	control_settings.visible = true
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


func display_settings_controls() -> void:
	settings_controls_label.visible = true
	kb_mouse_scheme_label.visible = false
	controller_scheme_label.visible = false


func update_state_name(player_state_name: String) -> void:
	state_name_display.text = "(%s)" % player_state_name


func _set_settings_data(value: SettingsData) -> void:
	settings_data = value
	_update_inputs()


func _update_inputs() -> void:
	input_type_value.select(settings_data.input_type)
	vertical_axis_value.select(settings_data.vertical_axis_direction)
	horizontal_axis_value.select(settings_data.horizontal_axis_direction)
	controller_camera_speed_value.value = settings_data.controller_camera_speed
	mouse_sensitivity_value.value = settings_data.mouse_sensitivity


#region [ Signal Handlers  ]
func _on_close_button_pressed():
	close_settings_requested.emit()



func _on_quit_game_button_pressed():
	quit_game_requested.emit()
