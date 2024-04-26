# hourglass-desert

## Project Structure
The majority of locations in the game are scenes that inherit from the `World` class/scene. Each location has a folder within `res://main/world/` and subfolders for each variation of that location. The name of this folder will be used internally to load and reference this location.

`World` scenes are populated by assets and other scenes within the `res://main/prop` folder. This includes characters, tilesets, and decorations.

`Actor` scenes are the most complex props due their dynamic nature. In order to feasibly create characters with large sets of actions, code to control an `Actor` is stored within `State` scripts and handled by a `StateMachine` node. Each `State` handles a small, reusable action and defines transitions to and from other `State` scripts. 

`Trigger` scripts are an extension to the `StateMachine` structure that allow an `Actor` to have more varied behavior with less code. Unlike a `State`, a `Trigger` listens for an environmental change (such as an enemy entering a player hitbox) and either runs a small block of code or forces a `State` transition. With this implementation, `State` code does not have to be polluted with hundreds of toggles for possible transitions. However, it does force `State` code to handle transitions at any time, so its `enter` and `exit` functions must make as few assumptions as possible and clean up its own processes.

In addition, `Actor` scenes can be `disabled` at any time, such as during screen transitions or when the game is paused. `Actor` scenes have `disable` and `enable` methods called when `disabled` is toggled that will prevent nodes such as hitboxes and timers from working when an `Actor` is disabled, effectively preventing interaction or movement. If an `Actor` scene adds more nodes that can affect behavior, they should also be toggled in an inheriting script.

A `disabled` `Actor` scene is intended to be uninteractable and unchangeable, although their `State` may still transition or run code. The `disable` and `enable` methods should prevent most bugs, but `State` scripts should still account for being disabled at any time with the `was_interrupted` method on their `StateMachine`. 

## Known Bugs
- The player can overlap with an NPC if both move into the same empty tile at roughly the same time
- NPCs moving across a mirror border will sometimes flicker
- CanvasMirror flickers at lower FPS
