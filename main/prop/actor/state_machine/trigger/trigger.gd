class_name Trigger
extends Node
# General node that detects changes (such as an area entering a hitbox) and either
# transitions the state of the controller or runs a small block of code

# Allows actors to have a variety of different respones through composition rather than
# making a mess in state code

@export var controller: Node
