extends TabContainer

# Assumes you preload or reference an Inventory resource for better decoupling.
@onready var player := get_node("/root/Game/Player")
@onready var inventory : PlayerInventory = player.inventory
var id : int
@onready var oggetti_label: Label = $Oggetti/OggettiMarginContainer/OggettiLabel
@onready var cibo_label: Label = $Cibo/CiboMarginContainer/CiboLabel
@onready var equipaggiamenti_label: Label = $Equipaggiamenti/EquipaggiamentiMarginContainer/EquipaggiamentiLabel
@onready var incantesimi_label: Label = $Incantesimi/IncantesimiMarginContainer/IncantesimiLabel


func _on_generaltab_container_tab_changed(tab_index: int) -> void:
	if tab_index == 1:
		update_display()


func update_display() -> void:
	oggetti_label.text = format_inventory(inventory.object_slots)
	cibo_label.text = format_inventory(inventory.food_slots)
	equipaggiamenti_label.text = format_inventory(inventory.equipment_slots)
	incantesimi_label.text = format_inventory(inventory.spell_slots)


func format_inventory(slots: Array[InventorySlot]) -> String:
	var text := ""
	for slot in slots:
		if slot.item and slot.count > 0:
			text += "%s %d\n" % [slot.item.name, slot.count]
	return text.strip_edges()
