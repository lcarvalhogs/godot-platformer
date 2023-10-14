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
	var old_level = get_level_node()
	var root = get_tree().root
	if old_level != null:
		root.remove_child(old_level)
		old_level.queue_free()
	
	var level = load(LVL_PATH % num).instantiate()
	root.add_child(level)
	return true

func get_level_node():
	var root = get_tree().root
	if root.has_node("Level"):
		return root.get_node("Level")
	return null

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

func on_computer():
	var level: Level = get_level_node()
	level.replace_tiles(level.BLOCK_OUTLINE, level.BLOCK)
