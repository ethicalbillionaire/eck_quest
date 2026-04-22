class_name WeaponResource extends Resource
## Resource for weapons
##
## Refers to a single projectile of the weapon
## i.e. faster fire rate means calling launch on the projectile more frequently

@export var weapon_name: String = "New Weapon"
@export var phy_dmg: float = 0.0
@export var mgc_dmg: float = 0.0
@export var ignore_phy_res: bool = false # Ignore phsyical resistance
@export var ignore_mgc_res: bool = false # Ignore magical resistance 
@export var projectile_duration: int = 0 # Projectile lifetime
@export var projectile: PackedScene
