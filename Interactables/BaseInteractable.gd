extends Area2D

enum InteractType {NONE, CHAIN, LADDER}
@export var type: InteractType = InteractType.NONE

func _ready():
	connect("body_entered", _on_interactable_body_enter)
	connect("body_exited", _on_interactable_body_exit)
	
func _on_interactable_body_enter(body):
	if body.has_method("on_interact_enter"):
		body.on_interact_enter(global_position, type)

func _on_interactable_body_exit(body):
	if body.has_method("on_interact_exit"):
		body.on_interact_exit(global_position, type)
