class_name ItemSpawner extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var item_popup: Node2D = $ItemPopup
@onready var icon_item: TextureRect = %IconItem
@onready var description_item: RichTextLabel = %DescriptionItem
@onready var item_1_icon: TextureButton = %Item1
@onready var item_1_text: RichTextLabel = %Item1Text

signal swap_items(new_item : Item, old_item : Item)

enum States {ENABLED, DISABLED}
var state : States = States.ENABLED
var item_1 : Item
var item_2 : Item
var player : Player = null
var spawned_item : Item
var inventory : Inventory
var available_items : Array[String] = [
	"res://Items/another_item.tscn",
	"res://Items/item.tscn"
]

func _ready() -> void:
	spawn_item()
	initialize_inventory()
	get_player()

func initialize_inventory():
	await get_tree().root.ready
	inventory = get_tree().get_first_node_in_group("Inventory")
	inventory.active_item_swapped.connect(display_current_player_items)

func get_player():
	await get_tree().root.ready
	player = get_tree().get_first_node_in_group("Player")

func _process(_delta: float) -> void:
	match state:
		States.ENABLED:
			if Input.is_action_just_pressed("pickup item"):
				give_player_new_item()
				animation_player.play("fade_out")
				await animation_player.animation_finished
				disable()
		States.DISABLED:
			pass

func enable():
	item_popup.visible = true

func disable():
	item_popup.visible = false

func give_player_new_item():
	if player == null:
		return
	var packed_scene : PackedScene = PackedScene.new()
	packed_scene.pack(spawned_item)
	player.inventory.pickup_new_item(packed_scene)

func spawn_item():
	available_items.shuffle()
	spawned_item = load(available_items.pop_front()).instantiate() as Item
	spawned_item.visible = false
	add_child(spawned_item)
	icon_item.texture = spawned_item.icon.texture
	var first_ability = spawned_item.first_ability.instantiate()
	var second_ability = spawned_item.second_ability.instantiate()
	description_item.text = "[center]" + first_ability.text + "[br]" + second_ability.text

func display_current_player_items(item : Item):
	item_1_icon.texture_normal = item.icon.texture

func _on_area_2d_body_entered(body: Node2D) -> void:
	if state == States.ENABLED && body is Player:
		animation_player.play("fade_in")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if state == States.ENABLED && body is Player:
		animation_player.play("fade_out")
