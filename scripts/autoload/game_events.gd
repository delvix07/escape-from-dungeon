extends Node

## Global Event Bus for the game.
## This Autoload handles global signals like UI popups.

## Emitted when an item is collected from a chest or the ground.
## The UI should listen to this to display the item popup.
signal show_item_popup(item: ItemData)

## Emitted when the item has been confirmed (action button pressed on the popup)
## and should be added to the player's inventory.
signal item_collected(item: ItemData)
