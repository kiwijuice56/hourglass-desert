extends Node

func save_memory(slot: int) -> void:
	var new_memory_slot: MemorySlot = MemorySlot.new()
	new_memory_slot.data = GlobalMemory.data
	new_memory_slot.slot = slot
	
	ResourceSaver.save(new_memory_slot, "user://" + str(slot) + ".tres")

func load_memory(slot: int) -> void:
	var memory_slot: MemorySlot = ResourceLoader.load("user://" + str(slot) + ".tres")
	GlobalMemory.data = memory_slot.data

func get_memories() -> Array[MemorySlot]:
	var memories: Array[MemorySlot] = []
	
	var dir: DirAccess = DirAccess.open("user://")
	dir.list_dir_begin()
	
	var file_name: String = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			memories.append(ResourceLoader.load("user://" + file_name))
		file_name = dir.get_next()
	
	return memories
