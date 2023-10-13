extends Area2D

@export var animation_random_start: bool = false

func _ready():
	connect("body_entered", on_player_entered)
	
	if animation_random_start:
		var animation_offset = $AnimationPlayer.current_animation_length * randf()
		$AnimationPlayer.advance(animation_offset)
		

func on_player_entered(body):
	get_tree().call_group("game", "on_pickup", self)
	queue_free()	# NB (lac): this is equivalent a "self.destroy"
