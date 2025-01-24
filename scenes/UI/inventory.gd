extends Control

var template_inv_slot = preload("res://scenes/UI/templates/inv.tscn")

@onready var tabcontainer = $Background/M/T
@onready var gridcontainer = $Background/M/T/V/ScrollContainer/GridContainer
@onready var gridcontainer2 = $Background/M/T/V2/ScrollContainer/GridContainer

## Add all slots and items from playerdata
func _ready() -> void:
	for i in PlayerData.inv_data.keys():
		var inv_slot_new = template_inv_slot.instantiate()
		if PlayerData.inv_data[i]["Item"] != null:
			var item_name = GameData.item_data[str(PlayerData.inv_data[i]["Item"])]["Name"]
			var icon_texture = load("res://assets/ItemIcons/"+item_name+".png")
			inv_slot_new.get_node("Icon").texture = icon_texture
		gridcontainer.add_child(inv_slot_new, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


## Cycle tabs
func _on_button_pressed() -> void:
	tabcontainer.current_tab = (tabcontainer.current_tab + 1) % tabcontainer.get_tab_count()
