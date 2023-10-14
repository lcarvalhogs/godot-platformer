extends "res://Triggerables/BaseTriggerable.gd"

var is_on: bool = false

func _on_trigger():
	_on_player_enter(null)

func _on_player_enter(body):
	if !is_on:
		is_on = true
		$Sprite2D.frame += 2
		get_tree().call_group("game", "on_computer")
