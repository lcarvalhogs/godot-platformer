extends Area2D

@export var tag: String

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("triggerable")
	connect("body_entered", _on_player_enter)

func trigger(tag_name: String):
	if tag.length() == 0 || tag != tag_name:
		return
	_on_trigger()

func _on_trigger():
	print("Need to implement _on_trigger")

func _on_player_enter(body):
	print("Need to implement on_player_entered")
