extends Node
# Stores references to commonly accessed nodes 

@onready var main: Main = get_tree().get_root().get_node("Main")
@onready var player: Player = get_tree().get_root().get_node("Main/Player")
@onready var transition: Transition = get_tree().get_root().get_node("Main/Transition")
