extends Area2D

@export var tag: String

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("triggerable")

func trigger(tag_name: String):
	print("t")
	if tag.length() == 0 || tag != tag_name:
		return
	_on_trigger()

func _on_trigger():
	print("Need to implement _on_trigger")
