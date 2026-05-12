extends Node2D

@onready var target: Node2D = $fighter

var button_heat: Dictionary = { }
const MAX_HEAT: float = 10.0
const HEAT_PER_PRESS: float = 1.0
const COOLDOWN_RATE: float = 1.5


func _process(delta: float) -> void:
	for button in button_heat.keys():
		button_heat[button] = max(0.0, button_heat[button] - COOLDOWN_RATE * delta)

	if Input.is_action_just_pressed("LB"):
		show_input_text("LB")
	elif Input.is_action_just_pressed("RB"):
		show_input_text("RB")
	elif Input.is_action_just_pressed("RT"):
		show_input_text("RT")
	elif Input.is_action_just_pressed("LT"):
		show_input_text("LT")
	elif Input.is_action_just_pressed("X"):
		show_input_text("X")
	elif Input.is_action_just_pressed("Y"):
		show_input_text("Y")
	elif Input.is_action_just_pressed("A"):
		show_input_text("A")
	elif Input.is_action_just_pressed("B"):
		show_input_text("B")


func show_input_text(input_name: String) -> void:
	# Increase heat for this button
	if not button_heat.has(input_name):
		button_heat[input_name] = 0.0
	button_heat[input_name] = min(MAX_HEAT, button_heat[input_name] + HEAT_PER_PRESS)

	# Calculate heat ratio (0.0 to 1.0)
	var heat_ratio = button_heat[input_name] / MAX_HEAT
	# Calculate size based on heat (32 at cool, up to 64 at max heat)
	var font_size = int(32 + (heat_ratio * 32))
	# Calculate color - white to red gradient
	var color = Color.WHITE.lerp(Color.RED, heat_ratio)
	FloatingLabel.add(input_name, target, font_size, color)
