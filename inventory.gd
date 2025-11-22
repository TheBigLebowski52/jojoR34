extends Control

@onready var items_list: Control = $Items/SplitContainer/ListContainer
@onready var items_desc: Label = $Items/SplitContainer/InformationContainer/InformazioniOggetto
@onready var food_list: Control = $Food/SplitContainer/ListContainer
@onready var food_desc: Label = $Food/SplitContainer/InformationContainer/InformazioniOggetto
@onready var texts_list: Control = $Texts/SplitContainer/ListContainer
@onready var texts_desc: Label = $Texts/SplitContainer/InformationContainer/InformazioniOggetto
@onready var armor_list: Control = $Armor/SplitContainer/ListContainer
@onready var armor_desc: Label = $Armor/SplitContainer/InformationContainer/InformazioniOggetto
@onready var weapons_list: Control = $Weapons/SplitContainer/ListContainer
@onready var weapons_desc: Label = $Weapons/SplitContainer/InformationContainer/InformazioniOggetto

func _ready() -> void:
	# Pulisce le descrizioni all'avvio
	_clear_descriptions()


func update_inventory_ui() -> void:

	_populate_list(items_list, items_desc, Inventory.object_slots)
	_populate_list(food_list, food_desc, Inventory.food_slots)
	_populate_list(texts_list, texts_desc, Inventory.spell_slots)
	_populate_list(armor_list, armor_desc, Inventory.equipment_slots)
	_populate_list(weapons_list, weapons_desc, Inventory.equipment_slots)

# Funzione generica per riempire una lista
func _populate_list(container: Control, description_label: Label, slots: Array[InventorySlot]) -> void:
	#Rimuove i vecchi pulsanti dalla lista
	for child in container.get_children():
		child.queue_free()
		
	# crea un pulsante per ogni oggetto nello slot
	for slot in slots:
		if slot.item == null:
			continue
			
		var btn = Button.new()
		if slot.count > 1:
			btn.text = slot.item.name + " x" + str(slot.count)
		else:
			btn.text = slot.item.name
		
		# robo per allinearlo per non fare una merda
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		# roba fatta da chatgpt forse l ho capita forse no 
		# fa vedere la descrizione quando premi, sto modo di scrivere è per non 
		# scrivere 4 funzioni per ogni tipo di oggetto, quindi funzizona per tutti
		# e 4
		btn.pressed.connect(func(): _show_description(description_label, slot.item))
		
		# sta roba a quanto pare serve per il game pad
		btn.focus_entered.connect(func(): _show_description(description_label, slot.item))
		
		container.add_child(btn)


func _show_description(label: Label, item: InventoryItem) -> void:
	if item and item.description:
		label.text = item.description
	else:
		label.text = "suca bliet in rumeno."

func _clear_descriptions():
	if items_desc: items_desc.text = ""
	if food_desc: food_desc.text = ""
	if texts_desc: texts_desc.text = ""
	if armor_desc: armor_desc.text = ""
	if weapons_desc: weapons_desc.text = ""
