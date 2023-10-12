extends CharacterBody2D

const GRAVITY = 800
@export var speed:int = 65
@export var air_control:bool = true

func _ready():
	pass

func _process(delta):
	horizontal()

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	move_and_slide()

func horizontal():
	if Input.is_action_pressed("right"):
		velocity.x = speed
		$Sprite2D.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -speed
		$Sprite2D.flip_h = true
	elif is_on_floor() or air_control:
		velocity.x = 0

	if is_on_floor():
		if velocity.x == 0:
			$AnimationPlayer.play("idle")
		else:
			$AnimationPlayer.play("walk")
