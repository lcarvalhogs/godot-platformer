extends Node2D
class_name Level

const KEY: Vector2i = Vector2i(5,1)
const DOOR: Vector2i = Vector2i(7,1)
const CHAIN: Vector2i = Vector2i(7,2)
const LADDER: Vector2i = Vector2i(3,4)
const LADDER_TOP: Vector2i = Vector2i(6,5)
const COIN: Vector2i = Vector2i(0,5)
const PLAYER: Vector2i = Vector2i(3,0)
const COMPUTER: Vector2i = Vector2i(5,4)
const BLOCK_OUTLINE: Vector2i = Vector2i(4,2)
const BLOCK: Vector2i = Vector2i(5,2)

@export var key: PackedScene
@export var door: PackedScene
@export var chain: PackedScene
@export var ladder: PackedScene
@export var ladder_top: PackedScene
@export var coin: PackedScene
@export var player: PackedScene
@export var computer: PackedScene

var tileset_dimension: Vector2i = Vector2i(8,6)

func _ready():
	call_deferred("setup_tiles")
	pass # Replace with function body.

func setup_tiles():
	var player_instance
	var cells = $Tiles.get_used_cells(0)
	for cell in cells:
		var index = $Tiles.get_cell_atlas_coords(0, Vector2i(cell.x, cell.y))
		match index:
			KEY:
				create_instance_from_tilemap(cell, key, $Items)
			DOOR:
				create_instance_from_tilemap(cell, door, $Triggerables)
			CHAIN:
				create_instance_from_tilemap(cell, chain, $Triggerables)
			LADDER:
				create_instance_from_tilemap(cell, ladder, $Triggerables)
			LADDER_TOP:
				create_instance_from_tilemap(cell, ladder_top, $Triggerables)
			COIN:
				create_instance_from_tilemap(cell, coin, $Items)
			PLAYER:
				player_instance = create_instance_from_tilemap(cell, player, self, Vector2(6, 10))
			COMPUTER:
				create_instance_from_tilemap(cell, computer, $Triggerables)

	get_tree().call_group("game", "on_level_loaded", $Area2D.position, $Area2D/CollisionShape2D.shape.extents)
	if player_instance != null:
		get_tree().call_group("game", "on_player_spawn", player_instance)

func create_instance_from_tilemap(coord: Vector2, prefab: PackedScene, parent: Node2D, offset: Vector2 = Vector2.ZERO):
	$Tiles.set_cell(0, coord, -1)
	var pf = prefab.instantiate()
	pf.position = $Tiles.map_to_local(coord) + offset
	parent.add_child((pf))
	return pf

func replace_tiles(old_tile: Vector2i, new_tile: Vector2i):
	var cells = $Tiles.get_used_cells_by_id(0, 0, old_tile)
	for cell in cells:
		$Tiles.set_cell(0, Vector2i(cell.x, cell.y), 0, new_tile)
