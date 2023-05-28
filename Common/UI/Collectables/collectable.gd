extends Control

signal Clicked(nm: String)

@export var collectable: String = ""
@export var collectable_texture: CompressedTexture2D
@export var default_frame = preload("res://Items/Frames/item_frame_2.png")
@export var default_background = preload("res://Items/Frames/item_frame_2.png")
@export var amount: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_properties(new_collectable, new_texture, new_amount: int):
	# The the initial properties
	collectable = new_collectable
	collectable_texture = new_texture
	amount = new_amount

func show_item():
	# Remove the unknown texture, show the new one
	$Frame.texture = default_frame
	$Frame/Item.texture = collectable_texture
	$Frame/Amount.text = str("x", amount)
	$Frame/Amount.visible = true
