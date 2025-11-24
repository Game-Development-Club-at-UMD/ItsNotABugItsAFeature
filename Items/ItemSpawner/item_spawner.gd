class_name ItemSpawner extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var item_popup: Node2D = $ItemPopup
@onready var icon_item: TextureRect = %IconItem
@onready var description_item: RichTextLabel = %DescriptionItem
@onready var item_1_icon: TextureButton = %Item1
@onready var item_1_text: RichTextLabel = %Item1Text
@onready var line_2d: Line2D = $Line2D

signal player_chose_item

enum States {ENABLED, DISABLED}
var state : States = States.DISABLED
var item_1 : Item
var item_2 : Item
var player : Player = null
var spawned_item : Item
var inventory : Inventory
var available_items : Array[String] = [
	"res://Items/Scenes/another_item.tscn",
	"res://Items/Scenes/Item1.tscn",
	"res://Items/Scenes/item.tscn",
	"res://Items/Scenes/item_2.tscn",
	"res://Items/Scenes/item_3.tscn",
]
var distance : float

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

func _process(delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
	
	match state:
		States.ENABLED:
			player.move_vis_rotation_helper.hide()
			
			distance = global_position.distance_to(player.global_position)
			
			if Input.is_action_just_pressed("pickup item") && distance < 250:
				give_player_new_item()
				next_round()
			if Input.is_action_just_pressed("decline item") && distance < 250:
				next_round()
			
			line_2d.set_point_position(0, Vector2(556, 300))
			line_2d.set_point_position(1, player.global_position)
			distance = clamp(distance, 250, 500)
			line_2d.modulate.a = remap(distance, 250, 500, 0, 1)
			item_popup.modulate.a = remap(distance, 250, 500, 1, 0)
		
		States.DISABLED:
			player.move_vis_rotation_helper.show()
			line_2d.modulate.a = lerp(line_2d.modulate.a, 0.0, delta * 12)
			item_popup.modulate.a = lerp(item_popup.modulate.a, 0.0, delta * 12)

func give_player_new_item():
	var packed_scene : PackedScene = PackedScene.new()
	packed_scene.pack(spawned_item)
	player.inventory.pickup_new_item(packed_scene)

func next_round():
	player_chose_item.emit()
	state = States.DISABLED

func spawn_item():
	available_items.shuffle()
	spawned_item = load(available_items.pick_random()).instantiate() as Item
	spawned_item.visible = false
	add_child(spawned_item)
	icon_item.texture = spawned_item.icon.texture
	var first_ability = spawned_item.first_ability.instantiate()
	var second_ability = spawned_item.second_ability.instantiate()
	description_item.text = first_ability.text + "[br]" + second_ability.text

func start_item_selection_phase():
	spawn_item()
	state = States.ENABLED

func display_current_player_items(item : Item):
	item_1_icon.texture_normal = item.icon.texture
	var first_ability = item.first_ability.instantiate()
	var second_ability = item.second_ability.instantiate()
	item_1_text.text = first_ability.text + "[br]" + second_ability.text
