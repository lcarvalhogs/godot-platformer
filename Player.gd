extends CharacterBody2D

enum {NORMAL, JUMP, FALL, LAND, DIE}
const GRAVITY = 800
const JUMP_VELOCITY = -200
const AIR_JUMP_MULTIPLIER: float = 0.75

@export var speed:int = 65
@export var air_control:bool = true
@export var max_air_jumps:int = 1

var state:= NORMAL
var air_jumps: int = 0
func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

	match state:
		NORMAL:
			horizontal()
			if Input.is_action_pressed("jump"):
				air_jumps = max_air_jumps
				state = JUMP
				jump()
		JUMP:
			jump()
			pass
		FALL:
			if is_on_floor():
				state = LAND
			pass
		LAND:
			state = NORMAL
			pass
		DIE:
			pass

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

func jump():
	if air_control:
		horizontal()

	if Input.is_action_pressed("jump") and air_jumps >= 0:
		$AnimationPlayer.play("jump")
		if air_jumps == max_air_jumps:
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY * AIR_JUMP_MULTIPLIER

		air_jumps -= 1
	if is_on_floor() and velocity.y >= 0:
		state = LAND
