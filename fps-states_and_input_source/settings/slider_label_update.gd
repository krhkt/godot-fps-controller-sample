class_name SliderLabelUpdate
extends Control

@export var current_value_label: Label


func _on_slider_value_changed(value: float) -> void:
	if not current_value_label: return
	
	current_value_label.text = str(value)
