class_name InventorySlot extends PanelContainer

@onready var texture_rect: TextureRect = $TextureRect
var item: ItemResource = null

func set_item(new_item: ItemResource) -> void:
	item = new_item
	if item:
		texture_rect.texture = item.item_sprite
	else:
		texture_rect.texture = null
