/// @description Step
if (keyboard_check_pressed(__EZRE_EDIT_TOGGLE_KEY)) {
	__EZRE_MODAL_WIDTH	= gui_width() * .35;
	__EZRE_MODAL_HEIGHT = gui_height();
	ezRoomEditor_set_edit_mode(!__EZRE_EDIT_ENABLED);
}

if (__EZRE_EDIT_ENABLED && instance_exists(__EZRE_MODAL_INST_TO_TRACK)) {
	ezRoomEditor_core_controller_event_step();
	var _gui_w = gui_width();
	var _vw_x = camera_get_view_x(__EZRE_CAMERA);
	var _vw_w = camera_get_view_width(__EZRE_CAMERA);
	var _vw_h = camera_get_view_height(__EZRE_CAMERA);
	var _scale = window_get_height() / _vw_h;
	var _modal_w = __EZRE_MODAL_WIDTH;
	var _vw_mid = _gui_w / 2;
	var _instance_x = (__EZRE_MODAL_INST_TO_TRACK.x - _vw_x);
	var _instance_in_vw_left_side = _instance_x < (_vw_w / 2);
	
	switch (__EZRE_MODAL_STATE) {
		case __EZRE_MODAL_STATES.OPEN:
			var _xTo = ( _instance_in_vw_left_side ? _gui_w - _modal_w : 0 );
			__EZRE_MODAL_X = lerp(__EZRE_MODAL_X, _xTo, .33);
			break;
			
		case __EZRE_MODAL_STATES.APPEAR:
			var _xTo = (
				_instance_in_vw_left_side
				? _gui_w - _modal_w
				: 0
			);
			__EZRE_MODAL_X = lerp(__EZRE_MODAL_X, _xTo, .33);
			if (near(__EZRE_MODAL_X, _xTo, 1)) {
				__EZRE_MODAL_STATE = __EZRE_MODAL_STATES.OPEN; 
			}
			break;
			
		case __EZRE_MODAL_STATES.DISAPPEAR:
			var _xTo = (
				__EZRE_MODAL_X > _vw_mid
				? _gui_w + _modal_w
				: -_modal_w
			);
			__EZRE_MODAL_X = lerp(__EZRE_MODAL_X, _xTo, .25);
			
			if (near(__EZRE_MODAL_X, _xTo, 1)) {
				__EZRE_MODAL_STATE = __EZRE_MODAL_STATES.APPEAR;
				__EZRE_MODAL_X = _xTo;
				__EZRE_MODAL_INST_TO_TRACK = noone;
			}
			break;
	}
}