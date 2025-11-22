extends Node
class_name PlayerInventory


@export var object_slots: Array[InventorySlot]
@export var equipment_slots: Array[InventorySlot]
@export var spell_slots: Array[InventorySlot]
@export var food_slots: Array[InventorySlot]

func collect(item: InventoryItem, amount: int = 1) -> void:
	var target_array: Array[InventorySlot]

	if item is FoodItem:
		target_array = food_slots
	elif item is EquipmentItem:
		target_array = equipment_slots
	elif item is SpellItem:
		target_array = spell_slots
	else:
		target_array = object_slots

	for slot in target_array:
		
		if slot.item.id == item.id:
			slot.count += amount
			print("oks")
			return

	var new_slot := InventorySlot.new(item, amount)
	target_array.append(new_slot)
