extends Node2D

const KEY: Vector2i = Vector2i(5,1)
const DOOR: Vector2i = Vector2i(7,1)
const CHAIN: Vector2i = Vector2i(7,2)
const COIN: Vector2i = Vector2i(0,5)
const PLAYER: Vector2i = Vector2i(3,0)

@export var key: PackedScene
@export var door: PackedScene
@export var chain: PackedScene
@export var coin: PackedScene
@export var player: PackedScene

func _ready():
	call_deferred("setup_tiles")
	pass # Replace with function body.

func setup_tiles():
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
			COIN:
				create_instance_from_tilemap(cell, coin, $Items)
			PLAYER:
				create_instance_from_tilemap(cell, player, self, Vector2(6, 10))

func create_instance_from_tilemap(coord: Vector2, prefab: PackedScene, parent: Node2D, offset: Vector2 = Vector2.ZERO):
	$Tiles.set_cell(0, coord, -1)
	var pf = prefab.instantiate()
	pf.position = $Tiles.map_to_local(coord) + offset
	parent.add_child((pf))
