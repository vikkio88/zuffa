extends Control


@onready var stamina_bar: ProgressBar = $stamina_bar;


func _ready() -> void:
	EventBus.stamina_update.connect(self._on_stamina_update)

func _on_stamina_update(perc: int):
	stamina_bar.value = perc
