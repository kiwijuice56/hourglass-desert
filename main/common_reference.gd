extends Node
# Stores references to commonly accessed nodes 

@onready var main: Main = get_tree().get_root().get_node("Main")
@onready var player: Player = get_tree().get_root().get_node("Main/Player")
@onready var ui: UI = get_tree().get_root().get_node("Main/UI")

# This should be under UI's script but its used very often
@onready var transition: Transition = get_tree().get_root().get_node("Main/UI/Transition")
