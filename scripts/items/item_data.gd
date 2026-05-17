class_name ItemData
extends Resource

## The name of the item to be displayed in the UI.
@export var item_name: String = ""

## The description of the item to be displayed in the UI.
@export_multiline var description: String = ""

## The visual representation of the item.
@export var texture: Texture2D

enum ItemType {
	WEAPON,
	SHIELD,
	HEALTH_POTION,
	MAGIC_POTION,
	MISC
}
## The category of the item, which determines its slot in the inventory.
@export var item_type: ItemType = ItemType.MISC

## Sound played when the item is picked up and its popup is shown.
@export var pickup_sound: AudioStream
