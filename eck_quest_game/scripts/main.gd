extends Node2D

func _ready() -> void:
	var player = $Player
	var inventory_ui = $"UI Layer/InventoryUI"
	inventory_ui.setup(player.player_inventory)
	print("Inventory:")
	print("   Weapon: "+ player.player_inventory.weapon.item_name)
