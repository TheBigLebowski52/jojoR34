extends InventoryItem
class_name EquipmentItem

enum EquipmentType {armor, weapon}
@export var body_part: EquipmentType
@export var atk_increase: int
@export var def_increase: int
