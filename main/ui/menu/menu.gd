class_name Menu
extends Control

signal exited
signal entered

func enter() -> void:
	entered.emit()

func exit() -> void:
	exited.emit()
