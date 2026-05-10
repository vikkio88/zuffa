extends CharacterBody2D

@export var MAX_SPEED = 300.0
@export var ACCELERATION = 1500.0
@export var FRICTION = 1200.0

@export var SHIELD_BASE_COST = 1
@export var SWORD_WIELD_COST = 1
@export var SWORD_SWING_COST = 10

@onready var weapon_pivot = $hand
@onready var sword_sprite = $hand/sword
@onready var shield_sprite = $hand/shield
@onready var sprite = $sprite

var facing: Enums.FACING = Enums.FACING.WEST
var is_weilding: bool = false
var is_shielding: bool = false

var last_sword_position = null
var sword_speed = null

var stamina: int = 100:
	set(value):
		stamina = clampi(value, 0, 100)
		print_debug(stamina)
		if stamina == 0:
			FloatingLabel.add("Out of Stamina", self)
		EventBus.stamina_update.emit(stamina)
	get:
		return stamina


func _physics_process(delta: float) -> void:
	var r_input := Input.get_vector("RJ_LEFT", "RJ_RIGHT", "RJ_UP", "RJ_DOWN")
	
	update_orientation(r_input)
	handle_shielding(r_input, delta)
	handle_weilding(r_input, delta)
	handle_movement(delta)

func update_orientation(r_input: Vector2) -> void:
	if r_input.length() > 0.1:
		var angle = wrapf(r_input.angle(), -PI, PI)
		if abs(angle) > PI/2:
			facing = Enums.FACING.EAST
			sprite.flip_h = true
		else:
			facing = Enums.FACING.WEST
			sprite.flip_h = false

func handle_shielding(r_input: Vector2, _delta: float) -> void:
	is_shielding = Input.is_action_pressed("LT") and stamina > 0
	if is_shielding:
		weapon_pivot.rotation = r_input.angle()
		shield_sprite.position.x = lerp(20.0, 25.0, r_input.length())
		shield_sprite.visible = true
	else:
		shield_sprite.visible = false

func handle_weilding(r_input: Vector2, delta: float) -> void:
	is_weilding = Input.is_action_pressed("LB") and stamina > 0 and not is_shielding
	if is_weilding:
		var current_tip_pos = get_sword_tip_local()
		sword_sprite.position.x = lerp(10.0, 30.0, r_input.length())
		sword_sprite.visible = true
		weapon_pivot.rotation = r_input.angle()
		
		if last_sword_position == null:
			last_sword_position = current_tip_pos
		else:
			var sw_vel = (current_tip_pos - last_sword_position) / delta
			last_sword_position = current_tip_pos
			sword_speed = sw_vel.length()
	else:
		sword_sprite.visible = false
		sword_speed = null
		last_sword_position = null

func handle_movement(delta: float) -> void:
	var direction := Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	if direction != Vector2.ZERO:
		var target_speed = MAX_SPEED
		var target_accel = ACCELERATION
		var facing_vector = Vector2.LEFT if facing == Enums.FACING.EAST else Vector2.RIGHT
		
		if direction.dot(facing_vector) < 0:
			target_speed *= 0.5
			target_accel *= 0.4
			
		if is_weilding or is_shielding:
			target_speed *= 0.7
			target_accel *= 0.8
			
		velocity = velocity.move_toward(direction * target_speed, target_accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()


func get_sword_tip_local() -> Vector2:
	# This calculates where the sword is relative to the PLAYER,
	# accounting for both rotation and the lerped distance.
	return Vector2.RIGHT.rotated(weapon_pivot.rotation) * sword_sprite.position.x


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage") and sword_speed != null and sword_speed > 0:
		body.take_damage(sword_speed)
	pass


func _on_tick_timeout() -> void:
	if is_weilding:
		if sword_speed:
			print_debug("sp %f" % sword_speed)
		stamina -= SWORD_WIELD_COST if sword_speed == null or sword_speed < 1 else SWORD_SWING_COST
	elif is_shielding:
		stamina -= SHIELD_BASE_COST
	elif stamina < 100:
		stamina += 10
