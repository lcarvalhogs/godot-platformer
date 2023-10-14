extends "res://Triggerables/BaseTriggerable.gd"

var is_open: bool = false

func _ready():
	get_tree().call_group("game", "on_set_door", self)

func _on_trigger():
	if !is_open:
		$AnimationPlayer.play("open")
		is_open = true

func _on_player_enter(body):
	if !is_open:
		return
	get_tree().call_group("game", "on_next_level")
