extends Node2D

const LVL_PATH = "res://Levels/Level%d.tscn"

var level_number:int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("game")
	call_deferred("init")

func init():
	load_level(level_number)
	pass


func load_level(num:int):
	var root = get_tree().root
	if root.has_node("Level"):
		var current_level = root.get_node("Level")
		root.remove_child(current_level)
		current_level.queue_free()
	
	print(LVL_PATH % num)
	var level = load(LVL_PATH % num).instantiate()
	root.add_child(level)
	return true

# Game group functions

func on_next_level():
	level_number += 1
	# TODO (lac): Add a scene transition
	load_level(level_number)
	# TODO (lac): Do something when there are no more levels

func on_pickup(item):
	print(item.name)
	if item.name == "Key":
		get_tree().call_group("triggerable", "trigger", "Door")
