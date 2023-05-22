/// @description Setup
ezRoomEditor_set_as_editable_object();
ezRoomEditor_set_editable_grid(8, 8);
ezRoomEditor_set_editable_variables(["x", "y", "image_angle", "image_index"],, ezre_type_int);
ezRoomEditor_add_editable_variables(["image_xscale", "image_yscale", "image_speed"],, ezre_type_real);
ezRoomEditor_add_editable_variables("image_blend",, ezre_type_color);