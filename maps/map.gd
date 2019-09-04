extends Node2D

var crosshair = load("res://assets/crosshair.png")

func _ready():
	Input.set_custom_mouse_cursor(crosshair, Input.CURSOR_ARROW, Vector2(24, 24))