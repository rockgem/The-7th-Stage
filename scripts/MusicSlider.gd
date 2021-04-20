extends HSlider

onready var bus = AudioServer.get_bus_index("Main")

func _ready():
	value = db2linear(AudioServer.get_bus_volume_db(bus))

func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(bus, linear2db(value))
