extends Node2D

@onready
var target: Node2D = $fighter

var button_heat: Dictionary = {}
const MAX_HEAT: float = 10.0
const HEAT_PER_PRESS: float = 1.0
const COOLDOWN_RATE: float = 1.5
const MAX_ROTATION: float = 20.0

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
	
	# Create a new Label
	var label = Label.new()
	label.text = input_name
	label.position = target.position
	
	# Random rotation
	var random_rotation = randf_range(-MAX_ROTATION, MAX_ROTATION)
	label.rotation_degrees = random_rotation
	
	# Calculate size based on heat (32 at cool, up to 64 at max heat)
	var font_size = int(32 + (heat_ratio * 32))
	
	# Calculate color - white to red gradient
	var color = Color.WHITE.lerp(Color.RED, heat_ratio)
	
	# Style the label with heat-based properties
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 2)
	
	# Center the text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	add_child(label)
	
	# Create the fade-out animation
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "modulate:a", 0.0, 1.0)
	tween.tween_property(label, "position:y", label.position.y - 100, 1.0)
	tween.tween_callback(label.queue_free).set_delay(1.0)
