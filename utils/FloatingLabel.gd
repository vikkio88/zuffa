extends Node

const MAX_ROTATION: float = 20.0


func add(text: String, target: Node2D, font_size: int = 32, color = Color.WHITE):
	var label = Label.new()
	label.text = text

	# Random rotation
	var random_rotation = randf_range(-MAX_ROTATION, MAX_ROTATION)
	label.rotation_degrees = random_rotation

	# Style the label with heat-based properties
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 2)

	# Center the text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	target.add_child(label)

	# Create the fade-out animation
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "modulate:a", 0.0, 1.0)
	tween.tween_property(label, "position:y", label.position.y - 100, 1.0)
	tween.tween_callback(label.queue_free).set_delay(1.0)
