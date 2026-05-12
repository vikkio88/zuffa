extends StaticBody2D

func take_damage(weapon_speed: float):
	Input.stop_joy_vibration(0)
	FloatingLabel.add("%d" % weapon_speed, self)
	Input.start_joy_vibration(0, 0.1, .4, 0.3)
