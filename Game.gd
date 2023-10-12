extends Node2D

const LVL_PATH = "res://Levels/Level%d.tscn"

var level_number:int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("pickup_listeners")
	call_deferred("init")
	pass # Replace with function body.


func init():
	load_level(level_number)
	pass


func load_level(num:int):
	var root = get_tree().root
	if root.has_node("Level"):
		root.remove_child($Level)
	
	print(LVL_PATH % num)
	var level = load(LVL_PATH % num).instantiate()
	root.add_child(level)
	return true

func on_pickup(item):
	print(item.name)
