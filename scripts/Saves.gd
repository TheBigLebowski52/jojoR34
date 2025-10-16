extends Node2D

const save_location = "user://SaveFile1.json"

var content_to_save1: Dictionary = {
	"CHAR_ID": 0,
	"MAX_HP": 1,
}

func _save1():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(content_to_save1.duplicate())
	file.close()
	
func _load1():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		content_to_save1.CHAR_ID = save_data.CHAR_ID
		content_to_save1.MAX_HP = save_data.MAX_HP
