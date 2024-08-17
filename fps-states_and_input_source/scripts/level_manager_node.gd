class_name LevelManagerNode
extends Node3D

@export var settings_data: SettingsData

@onready var player := $Gameplay/StatesPlayer as PlayerController
@onready var gameplay := $Gameplay as Node3D
@onready var input_source := $InputSource as InputSource
@onready var game_ui := $GameUi as GameUi


#region [ Godot API ]
func _ready() -> void:
	if not settings_data:
		settings_data = SettingsData.new()
		settings_data.set_from_input_source(player.input_source)
	
	game_ui.settings_data = settings_data
	update_control_scheme_display()


func _process(_delta: float) -> void:
	update_player_state_name()
	
	if input_source.is_settings_just_pressed:
		toggle_settings()
#endregion


#region [ Public API ]
func update_control_scheme_display():
	game_ui.update_control_scheme_display(player.input_source.input_scheme_in_use)


func update_player_state_name() -> void:
	game_ui.update_state_name(player.current_state_name)


func open_settings() -> void:
	if game_ui.is_open:
		return
	
	game_ui.open_settings()
	pause_game()


func close_settings() -> void:
	game_ui.close_settings()
	unpause_game()
	update_control_scheme_display()


func toggle_settings():
	if game_ui.is_open:
		close_settings()
	else:
		open_settings()


func pause_game():
	if input_source.input_scheme_in_use == InputSource.InputType.KeyboardMouse:
		input_source.uncapture_mouse()
	
	gameplay.process_mode = Node.PROCESS_MODE_DISABLED


func unpause_game():
	input_source.capture_mouse()
	gameplay.process_mode = Node.PROCESS_MODE_INHERIT


func toggle_pause_game():
	var is_paused := gameplay.process_mode == Node.PROCESS_MODE_DISABLED
	
	if not is_paused:
		pause_game()
	else:
		unpause_game()


func quit_game():
	get_tree().quit()
#endregion


#region [ Signal handlers ]
func _on_input_type_changed(_input_type: int) -> void:
	update_control_scheme_display()


func _on_game_ui_close_settings_requested() -> void:
	close_settings()


func _on_game_ui_quit_game_requested()-> void:
	quit_game()


func _on_game_ui_settings_updated(_settings_data: SettingsData) -> void:
	settings_data.apply_to_input_source(player.input_source)
#endregion
