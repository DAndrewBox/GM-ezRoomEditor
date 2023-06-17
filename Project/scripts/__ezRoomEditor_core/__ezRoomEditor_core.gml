/// @func	ezRoomEditor_core_get_variable_type_name(var_type)
/// @param	{real}	var_type
function ezRoomEditor_core_get_variable_type_name(_type) {
	switch (_type) {
		default:
		case ezre_type_any:				return "Any";
		case ezre_type_string_long:
		case ezre_type_string:			return "Text";
		case ezre_type_bool:			return "Bool";
		case ezre_type_real:			return "Number";
		case ezre_type_int:				return "Integer";
		case ezre_type_array:			return "Array";
		case ezre_type_struct:			return "Struct";
		case ezre_type_color:			return "Color RGB";
		case ezre_type_color_rgba:		return "Color RGBA";
		case ezre_type_asset_sprite:	return "Sprite";
		case ezre_type_asset_script:	return "Script";
		case ezre_type_asset_object:	return "Object";
	}
}

/// @func	ezRoomEditor_core_get_input_by_type(var_type, id, value)
/// @param	{real}	var_type
/// @param	{int}	id
/// @param	{any}	value
function ezRoomEditor_core_get_input_by_type(_type, _id, _value) {
	static _sprites			= __EZRE_CONTROLLER.__EZRE_ASSETS[$ "sprites"];
	static _sprites_len		= get_size(_sprites);
	static _scripts			= __EZRE_CONTROLLER.__EZRE_ASSETS[$ "scripts"];
	static _scripts_len		= get_size(_scripts);
	static _scripts_offset	= 100001;
	static _objects			= __EZRE_CONTROLLER.__EZRE_ASSETS[$ "objects"];
	static _objects_len		= get_size(_objects);

	var _label = $"##{_id}";
	
	switch (_type) {
		default:
		case ezre_type_any:			
			ImGui.TextColored($"{_value}{_label}", #777777);
			return _value;
		case ezre_type_string:		return ImGui.InputTextWithHint(_label, "Write something here...", _value);
		case ezre_type_string_long:	return ImGui.InputTextMultiline(_label, _value,,, ImGuiInputTextFlags.AllowTabInput);
		case ezre_type_bool:		return ImGui.Checkbox(_label, _value);
		case ezre_type_real:		return ImGui.InputFloat(_label, _value, .1,,"%.2f");
		case ezre_type_int:			return ImGui.InputInt(_label, _value);
		case ezre_type_array:
			var _first_element = _value[0];
			if (is_string(_first_element)) {
				var _array_len = get_size(_value);
				var _text_inputs = array_create(_array_len);
				
				ImGui.Indent(ImGui.GetTreeNodeToLabelSpacing());
				for (var i = 0; i < _array_len; i++) {
					ImGui.AlignTextToFramePadding();
					ImGui.TextColored($"[{i}]", #777777);
					ImGui.SameLine();
					ImGui.SetNextItemWidth(ImGui.GetContentRegionAvailX());
					_text_inputs[i] = ImGui.InputText($"{_label}_arr_{i}", _value[i]);
				}
				ImGui.Unindent(ImGui.GetTreeNodeToLabelSpacing());
				
				return _text_inputs;
			}
		
			if (is_bool(_first_element)) {
				var _array_len = get_size(_value);
				var _checkboxes = array_create(_array_len);
				
				ImGui.Indent(ImGui.GetTreeNodeToLabelSpacing());
				for (var i = 0; i < _array_len; i++) {
					ImGui.AlignTextToFramePadding();
					ImGui.TextColored($"[{i}]", #777777);
					ImGui.SameLine();
					ImGui.SetNextItemWidth(ImGui.GetContentRegionAvailX());
					_checkboxes[i] = ImGui.Checkbox($"{_label}_arr_{i}", _value[i]);
				}
				ImGui.Unindent(ImGui.GetTreeNodeToLabelSpacing());
				
				return _checkboxes;
			}
			
			if (is_array(_first_element)) {
				var _array_len = get_size(_value);
				var _inputs = array_create(_array_len);
				
				ImGui.Indent(ImGui.GetTreeNodeToLabelSpacing());
				for (var i = 0; i < _array_len; i++) {
					var _val = _value[i];
					var _val_type = ezre_type_any;
					if (is_string(_val)) {
						_val_type = string_length(_val) < 64 ? ezre_type_string : ezre_type_string_long;
					} else if (is_bool(_val)) {
						_val_type = ezre_type_bool;
					} else if (is_array(_val)) {
						_val_type = ezre_type_array;
					} else if (is_real(_val)) {
						_val_type = (real(_val) == round(real(_val))) ? ezre_type_int : ezre_type_real;
					}
				
					ImGui.AlignTextToFramePadding();
					ImGui.TextColored($"[{i}]", #777777);
					ImGui.SameLine();
					ImGui.SetNextItemWidth(ImGui.GetContentRegionAvailX());
					_inputs[i] = ezRoomEditor_core_get_input_by_type(_val_type, $"{_label}_arr_{i}", _val);
				}
				ImGui.Unindent(ImGui.GetTreeNodeToLabelSpacing());
				
				return _inputs;
			}
		
			if (real(_first_element) == round(real(_first_element))) {
				return ImGui.InputIntN(_label, _value);
			} else {
				return ImGui.InputFloatN(_label, _value,,,"%.2f");
			}
			break;
		case ezre_type_struct:
			ImGui.Indent(ImGui.GetTreeNodeToLabelSpacing());
			var _keys = struct_keys(_value);
			var _array_len = get_size(_keys);
			array_sort(_keys, true);
		
			for (var i = 0; i < _array_len; i++) {
				var _val = _value[$ _keys[i]];
				var _val_type = ezre_type_any;
				if (is_string(_val)) {
					_val_type = string_length(_val) < 64 ? ezre_type_string : ezre_type_string_long;
				} else if (is_bool(_val)) {
					_val_type = ezre_type_bool;
				} else if (is_array(_val)) {
					_val_type = ezre_type_array;
				} else if (is_real(_val)) {
					_val_type = (real(_val) == round(real(_val))) ? ezre_type_int : ezre_type_real;
				} else if (is_struct(_val)) {
					_val_type = ezre_type_struct;
				}
					
				ImGui.AlignTextToFramePadding();
				ImGui.TextColored($"{_keys[i]}:", #777777);
				if (_val_type != ezre_type_array && _val_type != ezre_type_struct) {
					ImGui.SameLine();
				}
				ImGui.SetNextItemWidth(ImGui.GetContentRegionAvailX());
				_value[$ _keys[i]] = ezRoomEditor_core_get_input_by_type(_val_type, $"{_label}_struct_{i}_{_keys[i]}", _val);
			}
			ImGui.Unindent(ImGui.GetTreeNodeToLabelSpacing());
			return _value;
		
		case ezre_type_color:
		case ezre_type_color_rgba:
			var _color_rgb = color_get_rgb(_value);
			var _color_alpha = ( _type == ezre_type_color_rgba ? (_value >> 24) / 255 : 1 );
			var _imgui_color = new ImColor(_color_rgb[0], _color_rgb[1], _color_rgb[2], _color_alpha);
			var _flags = _type == ezre_type_color ? ImGuiColorEditFlags.NoAlpha : ImGuiColorEditFlags.AlphaBar | ImGuiColorEditFlags.AlphaPreview;
			
			ImGui.ColorEdit4(_label, _imgui_color, _flags);
			var _rgb_dec = rgb(_imgui_color.r, _imgui_color.g, _imgui_color.b);
			var _alpha = _imgui_color.a;
			var _rgba_dec = dec_rgb2rgba(_rgb_dec, _alpha);
			return _rgba_dec;

		case ezre_type_asset_sprite:
			var _spr_index = _value; 
			var _img_h = ImGui.GetTextLineHeightWithSpacing();
					
			ImGui.AlignTextToFramePadding();
			ImGui.SetCursorPos(ImGui.GetCursorPosX() + 2, ImGui.GetCursorPosY() + 2);
			ImGui.Image(_spr_index, 0,,, _img_h, _img_h);
			ImGui.SetCursorPos(ImGui.GetCursorPosX() - 2, ImGui.GetCursorPosY() - 2);
			ImGui.SameLine();
			ImGui.PushItemWidth(ImGui.GetContentRegionAvailX());
			if (ImGui.BeginCombo($"{_label}_sprIndex", _sprites[_spr_index], ImGuiComboFlags.None)) {							
				for (var i = 0; i < _sprites_len; i++) {
					var _is_selected = _spr_index == i;
					var _selectable = ImGui.Selectable($"{_label}_spr{i}", _is_selected);
					ImGui.SameLine();
					ImGui.Image(i, 0,,, _img_h, _img_h);
					ImGui.SameLine();
					ImGui.Indent(_img_h + 12);
					ImGui.Text(_sprites[i]);
					ImGui.Unindent(_img_h + 12);
								
					if (_selectable) {
						_value = i;
						break;
					}
							
					if (_is_selected) {
						ImGui.SetItemDefaultFocus();
					}
				}
				ImGui.EndCombo();
			}
			
			return _value;

		case ezre_type_asset_script:
			var _script_index = _value - _scripts_offset;
			if (_script_index < 0) return _value;
			var _img_h = ImGui.GetTextLineHeightWithSpacing();
			
			ImGui.PushItemWidth(ImGui.GetContentRegionAvailX());
			if (ImGui.BeginCombo($"{_label}_scriptIndex", _scripts[_script_index], ImGuiComboFlags.None)) {							
				for (var i = 0; i < _scripts_len; i++) {
					if (_scripts[i] == undefined) continue;
					var _is_selected = _script_index == i;
					var _selectable = ImGui.Selectable($"{_label}_script_{i}", _is_selected);
					ImGui.SameLine();
					ImGui.Text(_scripts[i]);
								
					if (_selectable) {
						_value = i + _scripts_offset;
						break;
					}
							
					if (_is_selected) {
						ImGui.SetItemDefaultFocus();
					}
				}
				ImGui.EndCombo();
			}
			
			return _value;
			
		case ezre_type_asset_object:
			var _obj_index = _value;
			var _spr_index = object_get_sprite(_obj_index); 
			_spr_index = _spr_index == -1 ? s_ezRoomEditor_empty : _spr_index;
			var _img_h = ImGui.GetTextLineHeightWithSpacing();
			
			ImGui.PushItemWidth(ImGui.GetContentRegionAvailX());
			if (ImGui.BeginCombo($"{_label}_objIndex", _objects[_obj_index], ImGuiComboFlags.None)) {							
				for (var i = 0; i < _objects_len; i++) {
					if (_objects[i] == undefined) continue;
					var _is_selected = _obj_index == i;
					var _selectable = ImGui.Selectable($"{_label}_obj{i}", _is_selected);
					var _obj_sprite = object_get_sprite(i);
					ImGui.SameLine();
					ImGui.Image(_obj_sprite == -1 ? s_ezRoomEditor_empty : _obj_sprite, 0,,, _img_h, _img_h);
					ImGui.SameLine();
					ImGui.Indent(_img_h + 12);
					ImGui.Text(_objects[i]);
					ImGui.Unindent(_img_h + 12);
								
					if (_selectable) {
						_value = i;
						break;
					}
							
					if (_is_selected) {
						ImGui.SetItemDefaultFocus();
					}
				}
				ImGui.EndCombo();
			}
			
			return _value;
	}
}

/// @func	ezRoomEditor_core_get_editable_instances_ids()
function ezRoomEditor_core_get_editable_instances_ids() {
	var _inst_keys = struct_keys(__EZRE_CONTROLLER.__EZRE_EDIT_INSTANCES_AVAILABLE);
	var _inst_ids = [];
	for (var i = 0; i < get_size(__EZRE_CONTROLLER.__EZRE_EDIT_INSTANCES_AVAILABLE); i++) {
		var _inst = __EZRE_CONTROLLER.__EZRE_EDIT_INSTANCES_AVAILABLE[$ _inst_keys[i]][$ "inst_in_room_id"];
		array_push(_inst_ids, _inst);
	}
	
	return _inst_ids;
}

/// @func	ezRoomEditor_core_property_get_override_struct(instance, prop_name, new_value)
/// @param	{ref}	instance
/// @param	{str}	prop_name
/// @param	{any}	new_value
function ezRoomEditor_core_property_get_override_struct(_inst_id, _prop_name, _value) {
	var _obj_name = object_get_name(_inst_id.object_index);
	var _struct = {
		resourceType: "GMOverriddenProperty",
		resourceVersion: "1.0",
		name: "",
		objectId: {
			name: _obj_name,
			path: $"objects/{_obj_name}/{_obj_name}.yy",
		},
		propertyId: {
			name: _prop_name,
			path: $"objects/{_obj_name}/{_obj_name}.yy",
		},
		value: string(_value),
	};
	
	return _struct;
}

/// @func	ezRoomEditor_core_get_instance_id(inst_const_name, x, y)
/// @param	{str}	inst_const_name
/// @param	{real}	x
/// @param	{real}	y
function ezRoomEditor_core_get_instance_id(_inst_const, _x, _y) {
	var _asset_index = asset_get_index(_inst_const);
	if (_asset_index == noone) return noone;
	
	var _inst_id = noone;
	with (_asset_index) {
		if (xstart == _x && ystart == _y) {
			_inst_id = id;
			break;
		}
	}
	
	return _inst_id;
}

/// @func	ezRoomEditor_core_get_builtin_equivalent(var_name)
/// @param	{str}	var_name
function ezRoomEditor_core_get_builtin_equivalent(_var_name) {
	switch (_var_name) {
		case "image_xscale":	return "scaleX";
		case "image_yscale":	return "scaleY";
		case "image_blend":		return "colour";
		case "image_index":		return "imageIndex";
		case "image_speed":		return "imageSpeed";
		case "image_angle":		return "rotation";
		default:				return _var_name;
	}
}

/// @func	ezRoomEditor_core_controller_event_step()
function ezRoomEditor_core_controller_event_step() {
	static _panel_flags = ImGuiWindowFlags.NoResize | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoCollapse;
	var _inst_const_id = __EZRE_MODAL_INST_TO_TRACK.__EZRE_EDIT_CONST_ID;
	var _obj_name = object_get_name(__EZRE_MODAL_INST_TO_TRACK.object_index);
	
	ImGui.SetNextWindowPos(__EZRE_MODAL_X, 0);
	ImGui.SetNextWindowSize(__EZRE_MODAL_WIDTH, __EZRE_MODAL_HEIGHT, ImGuiCond.Once);
	
	var _window = ImGui.Begin($"{_obj_name} ({_inst_const_id})##mainWindow", true, _panel_flags, ImGuiReturnMask.Both);
	if (__EZRE_EDIT_ENABLED && _window) {
		var _tabbar_flags = ImGuiTabBarFlags.NoCloseWithMiddleMouseButton;
		if (ImGui.BeginTabBar("TabBar", _tabbar_flags)) {
			if (ImGui.BeginTabItem("Modify")) {
				var _max_space = ImGui.GetContentRegionAvailX();
				if (ImGui.TreeNodeEx("Position & Layering", ImGuiTreeNodeFlags.DefaultOpen)) {
					ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 4);
					ImGui.Unindent(ImGui.GetTreeNodeToLabelSpacing());
					
					ImGui.PushItemWidth(_max_space * 1/2 - 19);
					ImGui.BeginGroup();
					ImGui.AlignTextToFramePadding();
					ImGui.Text("x");
					ImGui.SameLine();
					__EZRE_MODAL_INST_TO_TRACK.x = ImGui.InputInt("##x", __EZRE_MODAL_INST_TO_TRACK.x);
					ImGui.EndGroup();
					
					ImGui.SameLine();
					
					ImGui.PushItemWidth(_max_space * 1/2 - 19);
					ImGui.BeginGroup();
					ImGui.AlignTextToFramePadding();
					ImGui.Text("y");
					ImGui.SameLine();
					__EZRE_MODAL_INST_TO_TRACK.y = ImGui.InputInt("##y", __EZRE_MODAL_INST_TO_TRACK.y);
					ImGui.EndGroup();
					
					ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 4);
					
					ImGui.PushItemWidth(_max_space * 7/8);
					ImGui.BeginGroup();
					ImGui.AlignTextToFramePadding();
					ImGui.Text("Depth");
					ImGui.SameLine();
					__EZRE_MODAL_INST_TO_TRACK.depth = ImGui.InputInt("##depth", __EZRE_MODAL_INST_TO_TRACK.depth);
					ImGui.EndGroup();
					
					ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 4);
					
					ImGui.PushItemWidth(_max_space);
					ImGui.BeginTable("checks##TblChecks", 3,,, 32, _max_space / 3);
					ImGui.TableNextRow();
					ImGui.TableSetColumnIndex(0);
					__EZRE_MODAL_INST_TO_TRACK.visible = ImGui.Checkbox("Visible##visible", __EZRE_MODAL_INST_TO_TRACK.visible);
					ImGui.TableSetColumnIndex(1);
					__EZRE_MODAL_INST_TO_TRACK.solid = ImGui.Checkbox("Solid##solid", __EZRE_MODAL_INST_TO_TRACK.solid);
					ImGui.TableSetColumnIndex(2);
					__EZRE_MODAL_INST_TO_TRACK.persistent = ImGui.Checkbox("Persistent##persist", __EZRE_MODAL_INST_TO_TRACK.persistent);
					ImGui.EndTable();
					
					ImGui.TreePop();
					ImGui.Indent(ImGui.GetTreeNodeToLabelSpacing());
				}
				
				ImGui.Separator();
				if (ImGui.TreeNodeEx("Image", ImGuiTreeNodeFlags.DefaultOpen)) {
					ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 4);
					ImGui.Unindent(ImGui.GetTreeNodeToLabelSpacing());
					
					static _sprites = __EZRE_ASSETS[$ "sprites"];
					static _sprites_len = get_size(_sprites);
					var _spr_index = __EZRE_MODAL_INST_TO_TRACK.sprite_index; 
					var _img_h = ImGui.GetTextLineHeightWithSpacing() - 2;
					
					ImGui.PushItemWidth(_max_space);
					ImGui.BeginGroup();
					ImGui.AlignTextToFramePadding();
					ImGui.Text("Sprite");
					ImGui.SameLine();
					ImGui.SetCursorPos(ImGui.GetCursorPosX() + 2, ImGui.GetCursorPosY() + 2);
					ImGui.Image(_spr_index, 0,,, _img_h + 2, _img_h + 2);
					ImGui.SetCursorPos(ImGui.GetCursorPosX() - 2, ImGui.GetCursorPosY() - 2);
					ImGui.SameLine();
					ImGui.PushItemWidth(ImGui.GetContentRegionAvailX());
					if (ImGui.BeginCombo("##sprIndex", _sprites[_spr_index], ImGuiComboFlags.None)) {							
						for (var i = 0; i < _sprites_len; i++) {
							var _is_selected = _spr_index == i;
							var _selectable = ImGui.Selectable($"##spr{i}", _is_selected);
							ImGui.SameLine();
							ImGui.Image(i, 0,,, _img_h, _img_h);
							ImGui.SameLine();
							ImGui.Indent(_img_h + 12);
							ImGui.Text(_sprites[i]);
							ImGui.Unindent(_img_h + 12);
								
							if (_selectable) {
								__EZRE_MODAL_INST_TO_TRACK.sprite_index = i;
								break;
							}
							
							if (_is_selected) {
								ImGui.SetItemDefaultFocus();
							}
						}
						ImGui.EndCombo();
					}
					ImGui.EndGroup();
					ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 4);
					
					ImGui.PushItemWidth(_max_space * 1/4);
					ImGui.BeginGroup();
					ImGui.AlignTextToFramePadding();
					ImGui.Text("Frame");
					ImGui.SameLine();
					__EZRE_MODAL_INST_TO_TRACK.image_index = ImGui.InputInt("##imgIndex", __EZRE_MODAL_INST_TO_TRACK.image_index);
					ImGui.EndGroup();
					
					ImGui.SameLine();
					
					ImGui.PushItemWidth(_max_space * 1/2 + 8);
					ImGui.BeginGroup();
					ImGui.AlignTextToFramePadding();
					ImGui.Text("Speed");
					ImGui.SameLine();
					__EZRE_MODAL_INST_TO_TRACK.image_speed = ImGui.InputFloat("##imgSpeed", __EZRE_MODAL_INST_TO_TRACK.image_speed);
					ImGui.EndGroup();
					ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 4);
					
					
					ImGui.PushItemWidth((_max_space - 105) / 2);
					ImGui.BeginGroup();
					ImGui.AlignTextToFramePadding();
					ImGui.Text("xScale");
					ImGui.SameLine();
					__EZRE_MODAL_INST_TO_TRACK.image_xscale = ImGui.InputFloat("##xScale", __EZRE_MODAL_INST_TO_TRACK.image_xscale, .01,,"%.2f");
					ImGui.EndGroup();
					
					ImGui.SameLine();
					
					ImGui.PushItemWidth((_max_space - 105) / 2);
					ImGui.BeginGroup();
					ImGui.AlignTextToFramePadding();
					ImGui.Text("yScale");
					ImGui.SameLine();
					__EZRE_MODAL_INST_TO_TRACK.image_yscale = ImGui.InputFloat("##yScale", __EZRE_MODAL_INST_TO_TRACK.image_yscale, .01,,"%.2f");
					ImGui.EndGroup();
					ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 4);
					
					ImGui.PushItemWidth(_max_space - 42);
					ImGui.BeginGroup();
					ImGui.AlignTextToFramePadding();
					ImGui.Text("Blend");
					ImGui.SameLine();
					var _blend_color_rgb = color_get_rgb(__EZRE_MODAL_INST_TO_TRACK.image_blend);
					var _imgui_color = new ImColor(_blend_color_rgb[0], _blend_color_rgb[1], _blend_color_rgb[2]);
					ImGui.ColorEdit4("##imgBlend", _imgui_color, ImGuiColorEditFlags.NoAlpha);
					__EZRE_MODAL_INST_TO_TRACK.image_blend = rgb(_imgui_color.r, _imgui_color.g, _imgui_color.b);
					ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 4);
					ImGui.EndGroup();
					
										
					ImGui.PushItemWidth(_max_space);
					__EZRE_MODAL_INST_TO_TRACK.image_alpha = ImGui.SliderFloat("##imgAlpha", __EZRE_MODAL_INST_TO_TRACK.image_alpha, 0, 1, "Alpha: %.2f", ImGuiSliderFlags.AlwaysClamp);
					ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 4);
					
					ImGui.PushItemWidth(_max_space);
					__EZRE_MODAL_INST_TO_TRACK.image_angle = ImGui.SliderInt("##imgAngle", __EZRE_MODAL_INST_TO_TRACK.image_angle, 0, 359,"Rotation: %d", ImGuiSliderFlags.AlwaysClamp);					
					ImGui.TreePop();
					ImGui.Indent(ImGui.GetTreeNodeToLabelSpacing());
					ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 4);
				}
				
				ImGui.Separator();
		
				if (ImGui.TreeNodeEx("Properties", ImGuiTreeNodeFlags.DefaultOpen)) {
					ImGui.Unindent(ImGui.GetTreeNodeToLabelSpacing());
					
					var _var_edit_array = __EZRE_MODAL_INST_TO_TRACK.__EZRE_EDIT_VARIABLES;
					var _len = get_size(_var_edit_array);
					var _name, _type;
					for (var i = 0; i < _len; i++) {
						var _name = _var_edit_array[i][$ "name"];
						var _type = _var_edit_array[i][$ "type"];
						var _type_name = $"({ezRoomEditor_core_get_variable_type_name(_type)})";
			
						// Skip default vars
						if (_name == "x" || _name == "y" || _name == "depth" ||
							_name == "image_index" || _name == "image_speed" || 
							_name == "image_angle" || _name == "image_blend" ||
							_name == "image_xscale" || _name == "image_yscale") {
						
							_var_edit_array[i][$ "value"] = variable_instance_get(__EZRE_MODAL_INST_TO_TRACK, _name);						
							ezRoomEditor_editable_set_variable_value(_inst_const_id, _name, _var_edit_array[i][$ "value"], _type);
							continue;

						}

						ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 4);

						// Draw input
						ImGui.Text(_name);
						ImGui.SameLine(8 + ImGui.GetContentRegionAvailX() - ImGui.CalcTextWidth(_type_name));
						ImGui.TextColored(_type_name, #777777);
						if (ImGui.IsItemHovered()) {
							ImGui.SetNextWindowSize(ezRoomEditor_get_camera_width(), -1);
							ImGui.BeginTooltip();
							ImGui.TextColored($"{_name}", c_yellow);
							ImGui.SameLine();
							ImGui.TextColored(_type_name, #777777);
							ImGui.TextWrapped("You can change this using `ezRoomEditor_add_variable()` 3rd parameter.");
							ImGui.EndTooltip();
						}
						ImGui.PushItemWidth(ImGui.GetContentRegionAvailX());
						_var_edit_array[i][$ "value"] = ezRoomEditor_core_get_input_by_type(_type, i, _var_edit_array[i][$ "value"]);
						ezRoomEditor_editable_set_variable_value(_inst_const_id, _name, _var_edit_array[i][$ "value"], _type);
					}
					ImGui.TreePop();
					ImGui.Indent(ImGui.GetTreeNodeToLabelSpacing());
					ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 4);
				}
				ImGui.EndTabItem();
			} 
			
			if (ImGui.BeginTabItem("Instance Vars")) {
				static _builtin_vars = ezRoomEditor_core_get_builtin_variables();
				static _builtin_len = array_length(_builtin_vars);
				array_sort(_builtin_vars, true);
				ImGui.TextColored("Built-in Variables", c_yellow);
				ImGui.SameLine();
				ImGui.TextColored("(?)", #777777);
				if (ImGui.IsItemHovered()) {
					ImGui.BeginTooltip();
					ImGui.Text("Variables that every instance have inherited."); 
					ImGui.EndTooltip();
				}
				ImGui.Separator();
				
				ImGui.BeginChild("buildinFrame##biFrame", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() / 3 + 8);
				for (var i = 0; i < _builtin_len; i++) {
					var _value = variable_instance_get(__EZRE_MODAL_INST_TO_TRACK, _builtin_vars[i]);
					ezRoomEditor_core_draw_variable(_builtin_vars[i], _value);
				}
				ImGui.EndChild();
				ImGui.NewLine();
				
				ImGui.TextColored("Custom Variables", c_yellow);
				ImGui.SameLine();
				ImGui.TextColored("(?)", #777777);
				if (ImGui.IsItemHovered()) {
					ImGui.BeginTooltip();
					ImGui.Text("Variables added by the user.");
					ImGui.EndTooltip();
				}
				ImGui.Separator();
				
				ImGui.BeginChild("customFrame##customFrame", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 32);
				var _vars = variable_instance_get_names(__EZRE_MODAL_INST_TO_TRACK);
				array_sort(_vars, true);
				var _len = get_size(_vars);
				
				for (var i = 0; i < _len; i++) {
					if (array_find_index_by_value(__EZRE_MODAL_INST_TO_TRACK.__EZRE_EDIT_IGNORED, _vars[i]) > -1) continue;
					var _value = variable_instance_get(__EZRE_MODAL_INST_TO_TRACK, _vars[i]);
					ezRoomEditor_core_draw_variable(_vars[i], _value);
				}
				ImGui.EndChild();
				ImGui.EndTabItem();
			}
			
			if (ImGui.BeginTabItem("Global Vars")) {
				var _vars = variable_instance_get_names(global);
				array_sort(_vars, true);
				var _len = get_size(_vars);
				
				ImGui.TextColored("Global Variables", c_yellow);
				ImGui.SameLine();
				ImGui.TextColored("(?)", #777777);
				if (ImGui.IsItemHovered()) {
					ImGui.BeginTooltip();
					ImGui.Text("Global Variables defined by the user.");
					ImGui.EndTooltip();
				}
				ImGui.Separator();
				ImGui.BeginChild("globalsFrame##globalsFrame", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 32);
				for (var i = 0; i < _len; i++) {
					var _value = variable_global_get(_vars[i]);
					if (is_callable(_value)) continue;
					if (_vars[i] == "ObjectContainer" || string_contains(_vars[i], "IMGUI")) continue;
					ezRoomEditor_core_draw_variable(_vars[i], _value);
				}
				ImGui.EndChild();
				ImGui.EndTabItem();
			}

			ImGui.EndTabBar();
		}
	
		var _is_floating_button = ImGui.GetCursorPosY() < ImGui.GetWindowHeight();
		if (_is_floating_button) {
			ImGui.SetCursorPosY(ImGui.GetWindowHeight() - 48);
		}

		ImGui.NewLine();
		ImGui.Separator();
	//	ImGui.TextColored("THIS WILL OVERWRITE THE ROOM FILE!", c_red);	
		var _button_w		= (ImGui.GetContentRegionAvailX() - 8) / 2;
		var _button_save	= ImGui.Button("SAVE PROPS", _button_w);
		ImGui.SameLine();
		var _button_backup	= ImGui.Button("MAKE ROOM BACKUP", _button_w);
		
		if (_button_save) {
			event_user_exec(__EZRE_CONTROLLER, 2);
			// __EZRE_MODAL_STATE = __EZRE_MODAL_STATES.DISAPPEAR;
			show_message_async("Room saved.\n[Reload] room in to see changes in the editor.");
		}
		
		if (_button_backup) {
			var _room_backed = ezRoomEditor_core_backup_room();
			if (_room_backed) {
				show_message_async($"Backup created as \"{room_get_name(room)}.yy.backup\"!");
			} else {
				show_message_async("There was an error saving the backup, please check the project folder.");
			}
			
		}
		
		ImGui.End();
	}
};

/// @func	ezRoomEditor_core_get_builtin_variables()
function ezRoomEditor_core_get_builtin_variables() {
	static _builtin_vars = [
		"id",
		"bbox_left",
		"bbox_right",
		"bbox_bottom",
		"bbox_top",
		"x",
		"y",
		"depth",
		"direction",
		"friction",
		"gravity",
		"gravity_direction",
		"hspeed",
		"vspeed",
		"image_alpha",
		"image_angle",
		"image_blend",
		"image_index",
		"image_number",
		"image_speed",
		"image_xscale",
		"image_yscale",
		"layer",
		"mask_index",
		"solid",
		"speed",
		"sprite_height",
		"sprite_width",
		"sprite_index",
		"visible",
		"xprevious",
		"yprevious",
		"xstart",
		"ystart",
	];
	
	return _builtin_vars;
}

/// @func	ezRoomEditor_core_get_forbidden_variable(var_name)
/// @param	{str}	var_name
function ezRoomEditor_core_get_forbidden_variable(_name) {
	static _forbidden_var_names = [
		"name",
		"resourceType",
		"resourceVersion",
		"frozen",
		"hasCreationCode",
		"ignore",
		"inheritCode",
		"inheritedItemId",
		"inheritItemSettings",
		"isDnd",
		"objectId",
		"properties"
	];
	static _len_forbidden = get_size(_forbidden_var_names);
	
	for (var i = 0; i < _len_forbidden; i++) {
		if (_name == _forbidden_var_names[i]) {
			var _inst_name = object_get_name(object_index);
			ezRoomEditor_error($"Cannot assign editable variable name \"{_name}\" on instance of \"{_inst_name}\". Name is reserved by GameMaker .YY files.");
			return true;
		}
	}
	
	return false;
}

/// @func	ezRoomEditor_core_draw_variable(name, value, iteration)
/// @param	{str}	name
/// @param	{any}	value
/// @param	{ral}	iteration
function ezRoomEditor_core_draw_variable(_name, _val, _iter = 0) {
	var _name_pad = string_pad_right($"{_name}:", " ", 21 - _iter * 3);
	var _width = __EZRE_CONTROLLER.__EZRE_MODAL_WIDTH - 8;
	var _color = merge_color(c_white, #333333, (_iter / 5));
	ImGui.PushStyleColor(ImGuiCol.Text, _color, 1.);
	
	if (is_array(_val)) {
		if (ImGui.TreeNode($"{_name_pad} (Array)")) {
			ImGui.PopStyleColor();
			var _array_len = get_size(_val);
			for (var i = 0; i < _array_len; i++) {
				if (_val[i] != undefined)
				ezRoomEditor_core_draw_variable($"[{i}]", _val[i], _iter+1);
			}
			ImGui.TreePop();
		}
		return;
	} if (is_struct(_val)) {
		if (ImGui.TreeNode($"{_name_pad} (Struct)")) {
			var _keys = struct_keys(_val);
			var _array_len = get_size(_keys);
			array_sort(_keys, true);
		
			for (var i = 0; i < _array_len; i++) {
				ezRoomEditor_core_draw_variable($"{_keys[i]}", _val[$ _keys[i]], _iter+1);
			}
			ImGui.TreePop();
		}
		return;
	} else {
		if (is_string(_val)) {
			_val = $"\"{_val}\"";
		}
		
		ImGui.Indent(ImGui.GetTreeNodeToLabelSpacing());
		
		ImGui.Text(_name_pad, _color);
		ImGui.SameLine();
		ImGui.TextWrapped(_val, _width);
		
		ImGui.Unindent(ImGui.GetTreeNodeToLabelSpacing());
	}
	ImGui.PopStyleColor();
}

/// @func	ezRoomEditor_core_get_assets(asset_type, offset)
/// @param	{str}	asset_type
/// @param	{real}	offset
function ezRoomEditor_core_get_assets(_type, _offset = 0) {
	var _callbacks = {
		sprite: [sprite_exists, sprite_get_name],
		audio:	[audio_exists,	audio_get_name],
		script: [script_exists, script_get_name],
		object: [object_exists, object_get_name],
	};
	var _index		= _offset;
	var _arr		= [ ];
	var _checker	= _callbacks[$ _type][0];
	var _getter		= _callbacks[$ _type][1];
	
	while (_checker(_index)) {
		array_push(_arr, _getter(_index));
		_index++;
	}
	
	return _arr;
}

/// @func	ezRoomEditor_core_backup_room()
function ezRoomEditor_core_backup_room() {
	var _filepath = __EZRE_CONTROLLER.__EZRE_ROOM_FILE;
	var _backup_filepath = $"{_filepath}.backup";
	
	if (file_exists(_filepath)) {
		if (file_exists(_backup_filepath)) {
			file_delete(_backup_filepath);
		}
		file_copy(_filepath, _backup_filepath);
		
		return true;
	}
	
	return false;
}

/// @func	ezRoomEditor_warning(message)
/// @param	{str}	message
function ezRoomEditor_warning(_msg) {
	trace($"(ez-RoomEditor) ⚠ WARNING: {_msg}");
}

/// @func	ezRoomEditor_error(message)
/// @param	{str}	message
function ezRoomEditor_error(_msg) {
	trace($"(ez-RoomEditor) ❌ ERROR: {_msg}");
}