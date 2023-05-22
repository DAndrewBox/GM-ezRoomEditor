/// @description Setup
ImGui.__Initialize();
event_user(10);

depth = -10000;

__EZRE_PROJECT_PATH = "B:\\Andrew\\Desktop\\My Projects\\GM-ezRoomEditor\\Project";
__EZRE_ROOMS_PATH	= $"{__EZRE_PROJECT_PATH}\\rooms";
__EZRE_ROOM_FILE	= "";

__EZRE_GUI_SCALE	= 1;
__EZRE_CAMERA		= view_camera[0];

__EZRE_EDIT_INSTANCES_AVAILABLE = {};
__EZRE_EDIT_ENABLED = false;

__EZRE_MODAL_X		= 0;
__EZRE_MODAL_Y		= 0;
__EZRE_MODAL_WIDTH	= gui_width() * .35;
__EZRE_MODAL_HEIGHT = gui_height();
__EZRE_MODAL_STATE	= __EZRE_MODAL_STATES.APPEAR;
__EZRE_MODAL_INST_TO_TRACK = noone;
__EZRE_MODAL_TAB_INDEX = 0;

__EZRE_ASSETS = {
	sprites: ezRoomEditor_core_get_assets("sprite"),
	sounds: ezRoomEditor_core_get_assets("audio"),
	scripts: ezRoomEditor_core_get_assets("script", 100001),
	objects: ezRoomEditor_core_get_assets("object"),
}

/// Filter assets
var _len;
var _asset_arr = __EZRE_ASSETS[$ "scripts"];
_len = get_size(_asset_arr);
for (var i = 0; i < _len; i++) {
	var _name = _asset_arr[i];	
	
	if (string_contains(_name, "GlobalScript_") ||
		string_contains(_name, "__struct__") || 
		string_contains(_name, "ImGui") || 
		string_contains(_name, "anon_gml")  || 
		_name == "ImColor"
	) {
		_asset_arr[i] = undefined;
		continue;
	}
}

_asset_arr = __EZRE_ASSETS[$ "objects"];
_len = get_size(_asset_arr);
for (var i = 0; i < _len; i++) {
	var _name = _asset_arr[i];
	if (string_contains(_name, "YYInternalObject")) {
		_asset_arr[i] = undefined;
	}
}