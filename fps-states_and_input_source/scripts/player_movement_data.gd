class_name PlayerMovementData
extends Resource


@export var speed := 0.0
@export var acceleration := 1.0
@export var deceleration := 1.0
@export var top_speed := 0.0
@export var terminal_velocity := 20.0
@export var jump_velocity := 0.0


func apply_from_data(data: PlayerMovementData) -> void:
	speed = data.speed
	acceleration = data.acceleration
	deceleration = data.deceleration
	top_speed = data.top_speed
	jump_velocity = data.jump_velocity
