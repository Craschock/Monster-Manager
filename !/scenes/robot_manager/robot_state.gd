extends Node

signal robot_state_changed

# robot is full
var robot_full: bool:
	set(val):
		robot_full = val
		robot_state_changed.emit()
# robot is empty
var robot_empty: bool:
	set(val):
		robot_empty = val
		robot_state_changed.emit()
# robot is selected
var robot_is_selected: bool:
	set(val):
		robot_is_selected = val
		robot_state_changed.emit()

# emit signal on change

# robot changes state
# - on add load
# - on remove load

# robot manager changes state
# - upon select
# - upon unselect

# in clickable items
# - read state upon create and set clickability
# - read state on change and set clickability
