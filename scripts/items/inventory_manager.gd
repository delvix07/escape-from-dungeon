class_name InventoryManager
extends Node

@export var weapon: ItemData
@export var shield: ItemData
@export var health_potion: ItemData
@export var magic_potion: ItemData
@export var misc_items: Array[ItemData] = []

signal weapon_equipped(item: ItemData)

func _ready() -> void:
	# Listen to the global event to know when an item is confirmed to be collected
	GameEvents.item_collected.connect(_on_item_collected)

func _on_item_collected(item: ItemData) -> void:
	add_item(item)

func add_item(item: ItemData) -> void:
	if not item:
		return
		
	match item.item_type:
		ItemData.ItemType.WEAPON:
			weapon = item
			weapon_equipped.emit(item)
			print("Weapon equipped: ", item.item_name)
		ItemData.ItemType.SHIELD:
			shield = item
			print("Shield equipped: ", item.item_name)
		ItemData.ItemType.HEALTH_POTION:
			health_potion = item
			print("Health Potion added: ", item.item_name)
		ItemData.ItemType.MAGIC_POTION:
			magic_potion = item
			print("Magic Potion added: ", item.item_name)
		ItemData.ItemType.MISC:
			if misc_items.size() < 3:
				misc_items.append(item)
				print("Misc item added: ", item.item_name)
			else:
				print("Inventory full for misc items!")
