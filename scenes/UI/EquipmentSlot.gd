extends TextureRect

func _get_drag_data(_pos):
	
	## Returns Name of the slot
	var equipment_slot = get_parent().name
	if PlayerData.equipment_data[equipment_slot] != null:
		var data = {}
		data["origin_node"] = self
		data["origin_panel"] = "CharacterSheet"
		data["origin_item_id"] = PlayerData.equipment_data[equipment_slot]
		data["origin_equipment_slot"] = equipment_slot
		data["origin_texture"] = texture
	
		var drag_texture = TextureRect.new()
		drag_texture.expand_mode = true
		drag_texture.texture = texture
		drag_texture.size = Vector2(100,100)
		
		## Control node that follows cursor, only for centering texture
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.position = -0.5 * drag_texture.size
		set_drag_preview(control)
		
		return data
	
func _can_drop_data(_pos, data):
	var target_equipment_slot = get_parent().name
	if target_equipment_slot == data["origin_equipment_slot"]:
		if PlayerData.equipment_data[target_equipment_slot] == null:
			data["target_item_id"] = null
			data["target_texture"] = null
		else:
			data["target_item_id"] = PlayerData.equipment_data[target_equipment_slot]
			data["target_texture"] = texture
		return true
	else:
		return false

func _drop_data(_pos, data):
	var target_equipment_slot = get_parent().name
	var origin_slot = data["origin_node"].get_parent().name
	
	## Update the origin
	if data["origin_panel"] == "Inventory":
		PlayerData.inv_data[origin_slot]["Item"] = data["target_item_id"]
	else:
		PlayerData.equipment_data[origin_slot] = data["target_item_id"]
		
	
	## Update origin texture
	if data["origin_panel"] == "CharacterSheet" and data["target_item_id"] == null:
		var default_texture = load("res://assets/UI_Elements/ItemFrame.png") #CHANGE THIS FOR UNIQUE BACKGROUNDS 
		data["origin_node"].texture = default_texture
	else:
		data["origin_node"].texture = data["target_texture"]
		
	## Update target texture
	PlayerData.equipment_data[target_equipment_slot] = data["origin_item_id"]
	texture = data["origin_texture"]
