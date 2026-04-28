class_name ItemResource extends Resource

@export var item_name: String
@export var item_sprite: Texture2D
@export var stackable: bool = false
@export var max_count: int = 1
var count: int

func stacks_available() -> int:
	return max_count - count
		
func is_full() -> bool:
	return stackable and (count == max_count)
	
func add_count(amount: int) -> void:
	if (count + amount) >= max_count:
		count = max_count
	else:
		count += amount

func lower_count(amount: int) -> void:
	if count > 0:
		if (count - amount) < 0:
			count = 0
		else:
			count -= amount
