extends Camera2D

@export var transition_time: float = 1.0

var _camera_target: Node2D

func _ready():
	pass

func _physics_process(delta):
	if _camera_target == null:
		return

	position = _get_target_pos()

func _get_target_pos() -> Vector2:
	return _camera_target.position

func set_camera_target(target: Node2D):
	_camera_target = target
