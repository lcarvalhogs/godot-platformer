extends CharacterBody2D

enum PlayerState {NORMAL, JUMP, FALL, LAND, DIE, CLIMB_CHAIN}
const GRAVITY = 800
const JUMP_VELOCITY = -200
const AIR_JUMP_MULTIPLIER: float = 0.75
const COYOTE_TIME: float = 0.05

@export var speed:int = 65
@export var air_control:bool = true
@export var max_air_jumps:int = 1

var state: PlayerState = PlayerState.NORMAL
var previous_state: PlayerState = PlayerState.NORMAL
var air_jumps: int = 0
var jump_start_y: float = 0.0
var fall_time: float = 0.0

var vines: int = 0
var last_vine_x: int = 0

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	match state:
		PlayerState.NORMAL:
			if !is_on_floor():
				change_state(PlayerState.FALL)
				jump_start_y = global_position.y
			else:
				horizontal()
				if Input.is_action_just_pressed("jump"):
					air_jumps = max_air_jumps
					change_state(PlayerState.JUMP)
					jump()
		PlayerState.JUMP:
			jump()
			pass
		PlayerState.CLIMB_CHAIN:
			climb_chain()
		PlayerState.FALL:
			if is_on_floor():
				change_state(PlayerState.LAND)
			elif fall_time <= COYOTE_TIME:
				air_jumps = max_air_jumps
				jump()
			fall_time += delta
		PlayerState.LAND:
			if $DustTimer.is_stopped():
				$FootDust.emitting = true
				$DustTimer.start($FootDust.lifetime + 0.15)
			fall_time = 0
			change_state(PlayerState.NORMAL)
			pass
		PlayerState.DIE:
			pass

func _physics_process(delta):
	if state != PlayerState.CLIMB_CHAIN:
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

func vertical():
	if Input.is_action_pressed("up"):
		velocity.y = -speed/2.0
	elif Input.is_action_pressed("down"):
		velocity.y = 0.75 * speed
	else:
		velocity.y = 0

func change_state(new_state: int):
	previous_state = state
	state = new_state

func jump():
	if air_control:
		horizontal()

	if Input.is_action_just_pressed("jump") and air_jumps >= 0:
		$AnimationPlayer.play("jump")
		if air_jumps == max_air_jumps:
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY * AIR_JUMP_MULTIPLIER

		air_jumps -= 1
		jump_start_y = global_position.y
	if is_on_floor() and velocity.y >= 0:
		change_state(PlayerState.LAND)

func climb_chain():
	velocity.x = 0
	vertical()
	if Input.is_action_just_pressed("jump"):
		air_jumps = max_air_jumps
		horizontal()
		change_state(PlayerState.JUMP)
		if velocity.x != 0:
			jump()

func on_Area2D_enter(area):
	if area.type == Utils.InteractType.CHAIN:
		vines += 1
		if state == PlayerState.JUMP and (previous_state != PlayerState.CLIMB_CHAIN or last_vine_x != area.global_position.x):
			last_vine_x = area.global_position.x
			global_position.x = position.x
			change_state(PlayerState.CLIMB_CHAIN)

func on_Area2D_exit(area):
	if area.type == Utils.InteractType.CHAIN:
		vines = max(0, vines - 1)
		if vines == 0 and state == PlayerState.CLIMB_CHAIN:
			change_state(PlayerState.FALL)
