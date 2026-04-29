extends PanelContainer

@onready var inventory: InventoryResource
@onready var weapon_slot: WeaponSlot = $EquipmentSlots/WeaponSlot
@onready var ability_slot: AbilitySlot = $EquipmentSlots/AbilitySlot
@onready var armor_slot: ArmorSlot = $EquipmentSlots/ArmorSlot
@onready var trinket_slot: TrinketSlot = $EquipmentSlots/TrinketSlot
@onready var bag: Dictionary[int, ItemResource]

func setup(player_inventory: InventoryResource) -> void:
	inventory = player_inventory
	bag = player_inventory.item_bag
	inventory.weapon_change.connect(update_weapon)
	inventory.ability_change.connect(update_ability)
	inventory.armor_change.connect(update_armor)
	inventory.trinket_change.connect(update_trinket)
	inventory.bag_change.connect(update_bag_ui)
	start_ui()

func start_ui() -> void:
	update_weapon(inventory.weapon)
	update_ability(inventory.ability)
	update_armor(inventory.armor)
	update_trinket(inventory.trinket)
	update_bag_ui(inventory.item_bag)
	
func update_weapon(weapon: WeaponResource) -> void:
	weapon_slot.set_item(weapon)
	
func update_ability(ability: AbilityResource) -> void:
	ability_slot.set_item(ability)
	
func update_armor(armor: ArmorResource) -> void:
	armor_slot.set_item(armor)
	
func update_trinket(trinket: TrinketResource) -> void:
	trinket_slot.set_item(trinket)

func update_bag_ui(bag: Dictionary[int, ItemResource]) -> void:
	# TODO: Figure out the bag situation
	pass
