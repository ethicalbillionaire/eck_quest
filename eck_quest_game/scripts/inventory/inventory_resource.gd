class_name InventoryResource extends Resource

signal bag_change(bag: Dictionary[int, ItemResource])
signal weapon_change(weapon: WeaponResource)
signal ability_change(ability: AbilityResource)
signal armor_change(armor: ArmorResource)
signal trinket_change(trinket: TrinketResource)

@export var weapon: WeaponResource
@export var ability: AbilityResource
@export var armor: ArmorResource
@export var trinket: TrinketResource

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
			if inv_item != null:
				if (item.item_name == inv_item.item_name) and (inv_item.count < inv_item.max_count):
					inv_item.up_count()
					bag_change.emit()
					return
	
	if inventory_position < 0:
		item_bag[get_first_empty_slot()] = item
	else:
		item_bag[inventory_position] = item
	bag_change.emit()
	
func remove_item(item: ItemResource) -> void:
	if item_bag.values().has(item):
		var idx: int = item_bag.find_key(item)
		if item_bag[idx].count > 1:
			item_bag[idx].lower_count(1)
		else:
			item_bag[idx] = null
