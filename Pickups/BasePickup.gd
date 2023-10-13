extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", on_player_entered)
	pass # Replace with function body.

func on_player_entered(body):
	get_tree().call_group("game", "on_pickup", self)
	queue_free()	# NB (lac): this is equivalent a "self.destroy"
