extends Node2D

const LVL_PATH = "res://Levels/Level%d.tscn"

@export var fade_time: float = .5

var level_number:int = 1
var level_door: Node2D

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

func on_set_door(new_door):
	level_door = new_door

func on_next_level():
	level_number += 1
	
	# NB (lac): Scene transition
	get_tree().paused = true	# NB (lac): Pause the game, which is in "process" mode (levelr are not)
	var tween: Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)	# NB (lac): set tween to always process
	tween.tween_property($Node2D/Fader, "color:a", 1, fade_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)	
	await(tween.finished)

	load_level(level_number)

	# NB (lac): Scene transition
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property($Node2D/Fader, "color:a", 0, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await(tween.finished)
	get_tree().paused = false
	# TODO (lac): Do something when there are no more levels

func on_pickup(item):
	if item.name == "Key":
		get_tree().paused = true
		var tween: Tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(item, "position", item.position - Vector2(0, 20), 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.play()
		await(tween.finished)

		# NB (lac): Small pause
		await(get_tree().create_timer(.25).timeout)

		# NB (lac): Make key go to door, rotating
		tween = get_tree().create_tween().set_parallel(true)
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(item, "position", level_door.position, .6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		tween.tween_property(item, "rotation", item.rotation - TAU, .5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		tween.tween_property(item, "scale", Vector2.ONE * .1, .6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		tween.play()
		await(tween.finished)

		# NB (lac): Delete item
		item.queue_free()

		get_tree().call_group("triggerable", "trigger", "Door")
		get_tree().paused = false

func on_computer():
	var level: Level = get_level_node()
	level.replace_tiles(level.BLOCK_OUTLINE, level.BLOCK)

func on_player_spawn(player: Node2D):
	if player != null:
		$Camera2D.set_camera_target(player)
		pass

func on_level_loaded(camera_bounds_top: Vector2, extents: Vector2):
	if camera_bounds_top != null and extents != null:
		var camera_node: Camera2D = $Camera2D
		camera_node.limit_left = camera_bounds_top.x
		camera_node.limit_top = camera_bounds_top.y

		camera_node.limit_right = camera_bounds_top.x + extents.x * 2
		camera_node.limit_bottom = camera_bounds_top.y + extents.y * 2
