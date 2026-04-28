extends PanelContainer

var inventory: InventoryResource

func setup(player_inventory: InventoryResource) -> void:
	inventory = player_inventory
	inventory.inventory_change.connect(update_ui)
	update_ui()

func update_ui() -> void:
	# updates inventory ui based on items in the inventory
	pass
