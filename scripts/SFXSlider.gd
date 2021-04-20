extends HSlider

onready var bus = AudioServer.get_bus_index("SFX")

func _ready():
	value = db2linear(AudioServer.get_bus_volume_db(bus))

func _on_SFXSlider_value_changed(value):
	AudioServer.set_bus_volume_db(bus, linear2db(value))
