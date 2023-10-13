extends CharacterBody2D

enum {NORMAL, JUMP, FALL, LAND, DIE}
const GRAVITY = 800
const JUMP_VELOCITY = -200
const AIR_JUMP_MULTIPLIER: float = 0.75
const COYOTE_TIME: float = 0.05

@export var speed:int = 65
@export var air_control:bool = true
@export var max_air_jumps:int = 1

var state:= NORMAL
var air_jumps: int = 0
var jump_start_y: float = 0.0
var fall_time: float = 0.0

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	match state:
		NORMAL:
			if !is_on_floor():
				state = FALL
				jump_start_y = global_position.y
			else:
				horizontal()
				if Input.is_action_just_pressed("jump"):
					air_jumps = max_air_jumps
					state = JUMP
					jump()
		JUMP:
			jump()
			pass
		FALL:
			if is_on_floor():
				state = LAND
			elif fall_time <= COYOTE_TIME:
				air_jumps = max_air_jumps
				jump()
			fall_time += delta
		LAND:
			if $DustTimer.is_stopped():
				print("emit")
				$FootDust.emitting = true
				$DustTimer.start($FootDust.lifetime + 0.15)
			fall_time = 0
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

	if Input.is_action_just_pressed("jump") and air_jumps >= 0:
		$AnimationPlayer.play("jump")
		state = JUMP
		if air_jumps == max_air_jumps:
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY * AIR_JUMP_MULTIPLIER

		air_jumps -= 1
		jump_start_y = global_position.y
	if is_on_floor() and velocity.y >= 0:
		state = LAND
