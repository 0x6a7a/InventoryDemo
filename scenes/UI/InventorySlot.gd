extends TextureRect

## Start dragging the current item.
func _get_drag_data(_pos):
	## Get the inventory slot that the item texture is in
	var inv_slot = get_parent().name
	if PlayerData.inv_data[inv_slot]["Item"] != null:
		var data = {}
		data["origin_node"] = self
		data["origin_panel"] = "Inventory"
		data["origin_item_id"] = PlayerData.inv_data[inv_slot]["Item"]
		data["origin_equipment_slot"] = GameData.item_data[str(PlayerData.inv_data[inv_slot]["Item"])]["EquipmentSlot"]
		data["origin_texture"] = texture
	
		var drag_texture = TextureRect.new()
		drag_texture.expand_mode = true
		drag_texture.texture = texture
		drag_texture.size = Vector2(100,100)
		
		## Control node to center the Icon
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.position = -0.5 * drag_texture.size
		set_drag_preview(control)
		
		## Pass along the data for the other slots to use
		return data

## Check if player can drop the item.
func _can_drop_data(_pos, data):
	var target_inv_slot = get_parent().name
	if PlayerData.inv_data[target_inv_slot]["Item"] == null:
		data["target_item_id"] = null
		data["target_texture"] = null
		return true
	else:
		data["target_item_id"] = PlayerData.inv_data[target_inv_slot]["Item"]
		data["target_texture"] = texture
		if data["origin_panel"] == "CharacterSheet":
			var target_equipment_slot = GameData.item_data[str(PlayerData.inv_data[target_inv_slot]["Item"])]["EquipmentSlot"]
			if target_equipment_slot == data["origin_equipment_slot"]:
				return true
			else:
				return false
		else:
			return true

func _drop_data(_pos, data):
	var target_inv_slot = get_parent().name
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
	PlayerData.inv_data[target_inv_slot]["Item"] = data["origin_item_id"]
	texture = data["origin_texture"]
