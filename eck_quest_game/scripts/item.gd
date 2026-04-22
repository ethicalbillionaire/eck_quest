extends Resource

@export var name: String
var stackable: bool = true
var max_count: int
var now_count: int

func add_count(amount: int) -> void:
	if (now_count + amount) >= max_count:
		now_count = max_count
	else:
		now_count += amount

func remove_count(amount: int) -> void:
	if now_count > 0:
		if (now_count - amount) < 0:
			now_count = 0
		else:
			now_count -= amount
