class_name SliderLabelField
extends Control

signal value_changed(value: float)

@export var current_value_label: Label
@export var slider: HSlider
@export var string_format: String = "%f"

var value: float : set = _set_slide_value


func _set_slide_value(new_value: float) -> void:
	value = new_value
	update_slider_value()
	update_label_value()


func update_slider_value() -> void:
	if not slider: return
	
	slider.value = value


func update_label_value() -> void:
	if not current_value_label: return
	
	current_value_label.text = string_format % value


#region [ Signal handlers ]
func _on_slider_value_changed(new_value: float) -> void:
	value = new_value
	value_changed.emit(value)
#endregion
