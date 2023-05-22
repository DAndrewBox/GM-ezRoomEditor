
/// @func	ezUI_create_modal(props)
/// @param	{struct}	props
function ezUI_create_modal(_props) {
	var _inst = instance_create_depth(0, 0, 0, o_ezUI_Modal);
	var _final_props = ezUI_core_merge_props_structs(_inst.props, _props);

	_inst.props		= _final_props;
	_inst.prevProps = variable_clone(_final_props);
	_inst.depth		= ezUI_get_prop_value("depth", 0, _inst);
	
	if (ezUI_get_prop_value("titleBarEnabled",, _inst) && ezUI_get_prop_value("titleBarCloseButton",, _inst)) { 
		var _btn_size = ezUI_get_prop_value("titleBarHeight", 0, _inst);
		var _close_button = ezUI_create_button({
			x:		ezUI_get_prop_value("x",, _inst) + ezUI_get_prop_value("width",, _inst) - _btn_size,
			y:		ezUI_get_prop_value("y",, _inst) - _btn_size,
			depth:	ezUI_get_prop_value("depth",, _inst) - 1,
			width:	_btn_size,
			height: _btn_size,
			text:	"x",
			onClick: ezUI_get_prop_value("onClose",, _inst),
		});
		
		ezUI_add_children(_inst, _close_button);
	}
	
	return _inst;
}

/// @func	ezUI_modal_ev_step()
function ezUI_modal_ev_step() {
	// Move modal if dragged
	if (ezUI_get_prop_value("titleBarEnabled") && ezUI_get_prop_value("titleBarGrabEnabled")) {
		var _mouse_x = gui_mouse_x();
		var _mouse_y = gui_mouse_y();
		var _mouse_in_title = point_in_rectangle(
			_mouse_x, _mouse_y,
			x + ezUI_get_prop_value("x"), y + ezUI_get_prop_value("y") - ezUI_get_prop_value("titleBarHeight"), 
			x + ezUI_get_prop_value("x") + ezUI_get_prop_value("width"), y + ezUI_get_prop_value("y")
		);
		
		if (_mouse_in_title) {
			var _inst_on_top = ezUI_core_get_instance_on_top(_mouse_x, _mouse_y);
			if (_inst_on_top == id) {
				if (mouse_check_button_pressed(mb_left) && !cursor_grab) {
					cursor_offset = [
						_mouse_x - ezUI_get_prop_value("x") - x,
						_mouse_y - ezUI_get_prop_value("y") - y,
					];
					cursor_grab = true;
				}
			}
		}
			
		if (mouse_check_button(mb_left) && cursor_grab) {
			x = xstart - ezUI_get_prop_value("x") + _mouse_x - cursor_offset[0];
			y = ystart - ezUI_get_prop_value("y") + _mouse_y - cursor_offset[1];
		}
		
		if (mouse_check_button_released(mb_left) && cursor_grab) {
			cursor_grab = false;
		}
	}
	
	// Move children with modal
	for (var i = 0; i < get_size(children); i++) {
		children[i].x = x;
		children[i].y = y;
	}
}

/// @func	ezUI_modal_ev_draw()
function ezUI_modal_ev_draw() {
	// Draw modal base
	var _x = x + ezUI_get_prop_value("x");
	var _y = y + ezUI_get_prop_value("y");
	var _w = ezUI_get_prop_value("width");
	var _h = ezUI_get_prop_value("height");
	var _sprite = ezUI_get_prop_value("modalSprite");
	var _color  = ezUI_get_prop_value("modalColor");
	var _alpha  = ezUI_get_prop_value("modalAlpha");
	var _shadow_margin = 8;
	draw_set_alpha(.50);
	draw_sprite_stretched(s_ezUI_shadow_drop, 0, _x - _shadow_margin, _y - _shadow_margin - 12, _w + _shadow_margin * 2, _h + _shadow_margin * 2 + 12);
		
	if (_sprite == noone) {
		draw_set_alpha(_alpha);
		draw_set_colour(_color);
		
		draw_rectangle(_x, _y, _x + _w, _y + _h, false);
	} else {
		draw_sprite_stretched_ext(_sprite, 0, _x, _y, _w, _h, c_white, _alpha);
	}
	
	// Draw modal text
	var _text_align = ezUI_get_prop_value("modalTextAlign");
	var _text_x = ( _text_align == fa_center ? _x + _w / 2 : ( _text_align == fa_left ? _x + 4 : _x + _w - 4 ) );
	
	draw_set_alpha(1);
	draw_set_font(ezUI_get_prop_value("modalTextFont"));
	draw_set_color(ezUI_get_prop_value("modalTextColor"));
	draw_set_align(_text_align, fa_top);
	
	draw_text_size(_text_x, _y + 12, ezUI_get_prop_value("modalText"), ezUI_get_prop_value("modalTextSize"));
	
	if (ezUI_get_prop_value("titleBarEnabled") == false) return;
	
	// Draw titlebar
	draw_set_alpha(1);
	draw_set_color(ezUI_get_prop_value("titleBarColor"));
	draw_rectangle(_x, _y - ezUI_get_prop_value("titleBarHeight"), _x + _w, _y, false);
	
	// Draw modal border
	draw_rectangle(_x, _y - ezUI_get_prop_value("titleBarHeight"), _x + _w, _y + _h, true);
	
	// Draw titlebar text
	var _title_centered = ezUI_get_prop_value("titleBarTextCenter");
	var _title_x = ( _title_centered ? _x + _w / 2 : _x + 4 );
	
	draw_set_font(ezUI_get_prop_value("titleBarTextFont"));
	draw_set_color(ezUI_get_prop_value("titleBarTextColor"));
	draw_set_align(_title_centered ? fa_center : fa_left, fa_bottom);
	
	draw_text_size(_title_x, _y + 3, ezUI_get_prop_value("titleBarText"), ezUI_get_prop_value("titleBarTextSize"));
}