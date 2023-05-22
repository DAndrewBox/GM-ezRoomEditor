/// @description Draw editable objects
display_set_gui_maximize(__EZRE_GUI_SCALE, __EZRE_GUI_SCALE);
if (__EZRE_EDIT_ENABLED) {
	draw_set_alpha(1);
	draw_set_align(fa_center, fa_top);
	draw_set_font(fnt_ezRoomEditor_default);
	var _vw_x = camera_get_view_x(__EZRE_CAMERA);
	var _vw_y = camera_get_view_y(__EZRE_CAMERA);
	var _gui_xscale = gui_width() / ezRoomEditor_get_camera_width();
	var _gui_yscale = gui_height() / ezRoomEditor_get_camera_height();
	
	var _inst_keys = struct_keys(__EZRE_EDIT_INSTANCES_AVAILABLE);
	var _inst_keys_len = get_size(_inst_keys);
	
	var _color_unselected = [c_purple, c_red];
	var _color_selected = [rgb(7, 7, 30), rgb(66, 99, 235)];
	
	for (var i = 0; i < _inst_keys_len; i++) {
		var _inst = __EZRE_EDIT_INSTANCES_AVAILABLE[$ _inst_keys[i]][$ "inst_in_room_id"];
		if (_inst.__EZRE_IS_EDITABLE) {
			var _is_selected = (_inst == __EZRE_MODAL_INST_TO_TRACK && __EZRE_MODAL_STATE != __EZRE_MODAL_STATES.DISAPPEAR);
			var _x_pos = [
				(_inst.bbox_left - _vw_x) * _gui_xscale,
				(_inst.bbox_right - _vw_x) * _gui_xscale
			];
			var _y_pos = [
				(_inst.bbox_top - _vw_y) * _gui_yscale,
				(_inst.bbox_bottom - _vw_y) * _gui_yscale,
			];
			var _x_mid = (_x_pos[0] + _x_pos[1]) / 2;
			
			
			draw_set_align(fa_center, fa_top);
			draw_set_alpha(_inst.__EZRE_CURSOR_GRAB || _is_selected ? 1. : .33);
			draw_set_colour(_inst.__EZRE_CURSOR_GRAB || _is_selected ? c_white : c_gray);
			draw_text_shadow(_x_mid, _y_pos[1] + 4, _inst_keys[i], 0, 1, c_white, c_purple);
			
			draw_set_alpha(.08);
			draw_set_colour(_is_selected ? _color_selected[0] : _color_unselected[0]);
			draw_rectangle(_x_pos[0], _y_pos[0], _x_pos[1], _y_pos[1], false);
			draw_set_alpha(.16);
			draw_set_colour(_is_selected ? _color_selected[1] : _color_unselected[1]);
			draw_rectangle(_x_pos[0], _y_pos[0], _x_pos[1], _y_pos[1], true);
		}
	}
}
draw_set_alpha(1);