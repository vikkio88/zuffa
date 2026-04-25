extends CharacterBody2D

@export var MAX_SPEED = 300.0
@export var ACCELERATION = 1500.0
@export var FRICTION = 1200.0
@onready var weapon_pivot = $hand 
@onready var sword_sprite = $hand/sword
@onready var sprite = $sprite

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	
	var r_input := Input.get_vector("RJ_LEFT", "RJ_RIGHT", "RJ_UP", "RJ_DOWN")
	
	if r_input.length() > 0.1: 
		weapon_pivot.rotation = r_input.angle()
		sword_sprite.position.x = lerp(10.0, 30.0, r_input.length())
		sword_sprite.visible = true
		if r_input.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
			
	else:
		sword_sprite.visible = false
