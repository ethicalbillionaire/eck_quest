class_name InventoryResource extends Resource

signal inventory_change

@export var weapon: WeaponResource
@export var ability: ItemResource
@export var armor: ArmorResource
@export var trinket: ItemResource

@export var bag_size: int = 8
@export var item_bag: Dictionary[int, ItemResource] = {
	1: null, 2: null, 3: null, 4: null, 5: null, 6: null, 7: null, 8:null
}

func has_space() -> bool:
	return item_bag.values().has(null)
	
func get_first_empty_slot() -> int:
	for slot in item_bag:
		if item_bag[slot] == null:
			return slot
	return -1 # -1 means no empty slot found

func add_item(item: ItemResource, inventory_position: int = -1) -> void:
	if not has_space():
		return
		
	# look for stack options in the inventory
	if item.stackable:
		for inv_item: ItemResource in item_bag.values():
			if (item.item_name == inv_item.item_name) and (inv_item.count < inv_item.max_count):
				inv_item.up_count()
				inventory_change.emit()
				return
				
	item_bag.set(0, item)
	inventory_change.emit()
	
func remove_item(item: ItemResource) -> void:
	if get_first_empty_slot() == 0:
		for inv_item: ItemResource in item_bag.values():
			if item != inv_item:
				pass
