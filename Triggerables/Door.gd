extends "res://Triggerables/BaseTriggerable.gd"

var is_open: bool = false

func _on_trigger():
	if !is_open:
		$AnimationPlayer.play("open")
		is_open = true

func _on_player_enter(body):
	if !is_open:
		return
	print("TODO (lac): next level")
