class_name InventoryResource extends Resource

@export var weapon: WeaponResource
@export var ability: ItemResource
@export var armor: ArmorResource
@export var trinket: ItemResource

@export var bag_size: int = 8
var item_bag: Array[ItemResource] = []
