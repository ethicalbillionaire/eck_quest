class_name WeaponResource extends ItemResource
## Equippable in the character's weapon slot

@export var phy_dmg: float = 0.0
@export var mgc_dmg: float = 0.0
@export var ignore_phy_res: bool = false # Ignore phsyical resistance
@export var ignore_mgc_res: bool = false # Ignore magical resistance 
@export var range: int = 100
@export var projectile: PackedScene
