Test_UI_Rect :: #type,isa Chop.Rect;

Test_UI_Data :: struct
{
    using #as data: Chop.UI_Data;
}

#insert -> string
{
    return #string HERE
init_Test_UI_Rect :: (ui_data: Test_UI_Data, rect: Test_UI_Rect) -> Test_UI_Rect
{
    return rect;
}
    HERE;
}

UI_Rect_init_test :: ()
{
    rect: Test_UI_Rect;
    data: Test_UI_Data;

    new_rect := Chop.init_baked_rect(data, rect);
    Verifai.are_equal(rect, new_rect, Chop.compare_rect);
} @Test

// ------------------------------------------------------------------------------------------------------------

EXPECTED_STRUCT_STR :: #string HERE
Test_UI_Rect :: ()
{
    x: int = root_rect.x + 50;
    y: int = root_rect.y;
    w: int = root_rect.w - 50;
    h: int = root_rect.h;
}
HERE

generate_rect_struct_decl_test :: ()
{
    root_data: Chop.Node_Data = .{
        rect = .{0, 0, 10, 10},
        x_str = "root_rect.x + 50",
        y_str = "root_rect.y",
        w_str = "root_rect.w - 50",
        h_str = "root_rect.h",
    };

    bsp := BSP.get_new_tree(root_data);
    struct_str := Chop.bake_rect_struct_decl(bsp.root.data.rect, "Test_UI_Rect", bsp);

    Verifai.are_equal(EXPECTED_STRUCT_STR, struct_str);
} @Test

#scope_file
Chop    :: #import "ChopSUI";
BSP     :: #import "BSP";
Verifai :: #import "Verifai";

// This will go away eventually! Be on the lookout for handling this type of problem in the future.
#poke_name Chop init_Test_UI_Rect;
