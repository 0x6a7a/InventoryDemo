extends Node

var inv_data = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var item_data_file = FileAccess.open("res://data/inv_data_file.json", FileAccess.READ)
	var item_data_JSON = JSON.parse_string(item_data_file.get_as_text())
	item_data_file.close()
	inv_data = item_data_JSON


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
