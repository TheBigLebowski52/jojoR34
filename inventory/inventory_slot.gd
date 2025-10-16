extends Resource
class_name InventorySlot

var item: InventoryItem
var count: int
var id : int

func _init(_item: InventoryItem, _count: int) -> void:
	item = _item
	count = _count
