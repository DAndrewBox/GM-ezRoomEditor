/// @description Deactivate Edit Mode
var _instances = ezRoomEditor_core_get_editable_instances_ids();
for (var i = 0; i < get_size(_instances); i++) {
	_instances[i].__EZRE_EDIT_ACTIVE = false;
}