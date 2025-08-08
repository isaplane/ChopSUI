BSP_One_Chop_Test_Setup_Data :: struct
{
    bsp:      *Chop.Tree;
    root_rect: Chop.Rect;
    builder: String_Builder;
}

setup_bsp_one_chop_tests :: ()
{
    setup := New(BSP_One_Chop_Test_Setup_Data);
    rect := Chop.Rect.{0, 0, 100, 100};
    setup.* = .{
        bsp = BSP.get_new_tree(Chop.Node_Data.{rect = rect}),
        root_rect = rect
    };

    context.setup_data = setup;
} @Setup

teardown_bsp_one_chop_tests :: ()
{
    setup := context.setup_data.(*BSP_One_Chop_Test_Setup_Data);
    BSP.free_tree(setup.bsp);
} @Teardown

// ------------------------------------------------------------------------------------------------------------

bsp_bisect_root_none_test :: ()
{
    setup := context.setup_data.(*BSP_One_Chop_Test_Setup_Data);
    using setup;

    chopped, remainder := Chop.chop(root_rect, 20, .NONE, bsp);
    Verifai.are_equal(chopped, Chop.Rect.{0, 0, 0, 0}, Chop.compare_rect);
    Verifai.are_equal(remainder, Chop.Rect.{0, 0, 100, 100}, Chop.compare_rect);

    Verifai.is_null(bsp.root.data.expression);
    Verifai.are_equal(bsp.root.data.direction, Chop.Direction.NONE);
} @Test

// ------------------------------------------------------------------------------------------------------------

bsp_bisect_root_left_test :: ()
{
    setup := context.setup_data.(*BSP_One_Chop_Test_Setup_Data);
    using setup;

    chopped, remainder := Chop.chop(root_rect, 20, .LEFT, bsp);
    Verifai.are_equal(chopped, Chop.Rect.{0, 0, 20, 100}, Chop.compare_rect);
    Verifai.are_equal(remainder, Chop.Rect.{20, 0, 80, 100}, Chop.compare_rect);

    Verifai.are_equal(bsp.root.data.direction, Chop.Direction.LEFT);

    print_expression(*builder, bsp.root.data.expression);
    Verifai.are_equal(builder_to_string(*builder), "20");

    left, right: *Chop.Node;

    left = BSP.find_leaf_containing_point(bsp, 0, 0, Chop.node_contains_point);
    right = BSP.find_leaf_containing_point(bsp, 20, 0, Chop.node_contains_point);
    Verifai.are_equal(chopped, left.data.rect, Chop.compare_rect);
    Verifai.are_equal(remainder, right.data.rect, Chop.compare_rect);

    left = BSP.find_leaf_containing_point(bsp, 19, 99, Chop.node_contains_point);
    right = BSP.find_leaf_containing_point(bsp, 99, 99, Chop.node_contains_point);
    Verifai.are_equal(chopped, left.data.rect, Chop.compare_rect);
    Verifai.are_equal(remainder, right.data.rect, Chop.compare_rect);

    left = BSP.find_leaf_containing_point(bsp, -1, -1, Chop.node_contains_point);
    right = BSP.find_leaf_containing_point(bsp, 100, 100, Chop.node_contains_point);
    Verifai.is_null(left);
    Verifai.is_null(right);

    Verifai.is_null(bsp.root.left.data.expression);
    Verifai.are_equal(bsp.root.left.data.direction, Chop.Direction.NONE);

    Verifai.is_null(bsp.root.right.data.expression);
    Verifai.are_equal(bsp.root.right.data.direction, Chop.Direction.NONE);
} @Test

// ------------------------------------------------------------------------------------------------------------

bsp_bisect_root_right_test :: ()
{
    setup := context.setup_data.(*BSP_One_Chop_Test_Setup_Data);
    using setup;

    x := 10;
    chopped, remainder := Chop.chop(root_rect, x + 20, .RIGHT, bsp);
    Verifai.are_equal(chopped, Chop.Rect.{70, 0, 30, 100}, Chop.compare_rect);
    Verifai.are_equal(remainder, Chop.Rect.{0, 0, 70, 100}, Chop.compare_rect);

    Verifai.are_equal(bsp.root.data.direction, Chop.Direction.RIGHT);

    print_expression(*builder, bsp.root.data.expression);
    Verifai.are_equal(builder_to_string(*builder), "x + 20");

    Verifai.is_null(bsp.root.left.data.expression);
    Verifai.are_equal(bsp.root.left.data.direction, Chop.Direction.NONE);

    Verifai.is_null(bsp.root.right.data.expression);
    Verifai.are_equal(bsp.root.right.data.direction, Chop.Direction.NONE);
} @Test

// ------------------------------------------------------------------------------------------------------------

bsp_bisect_root_top_test :: ()
{
    setup := context.setup_data.(*BSP_One_Chop_Test_Setup_Data);
    using setup;

    chopped, remainder := Chop.chop(root_rect, get_amount_to_chop(.4, root_rect.h), .TOP, bsp);
    Verifai.are_equal(chopped, Chop.Rect.{0, 0, 100, 40}, Chop.compare_rect);
    Verifai.are_equal(remainder, Chop.Rect.{0, 40, 100, 60}, Chop.compare_rect);

    Verifai.are_equal(bsp.root.data.direction, Chop.Direction.TOP);

    print_expression(*builder, bsp.root.data.expression);
    expr_str := builder_to_string(*builder);
    Verifai.are_equal(expr_str, "get_amount_to_chop(0.4, root_rect.h)");

    Verifai.is_null(bsp.root.left.data.expression);
    Verifai.are_equal(bsp.root.left.data.direction, Chop.Direction.NONE);

    Verifai.is_null(bsp.root.right.data.expression);
    Verifai.are_equal(bsp.root.right.data.direction, Chop.Direction.NONE);
} @Test

// ------------------------------------------------------------------------------------------------------------

bsp_bisect_root_bottom_test :: ()
{
    setup := context.setup_data.(*BSP_One_Chop_Test_Setup_Data);
    using setup;

    flag := true;
    chopped, remainder := Chop.chop(root_rect, ifx flag then 20 else 10, .BOTTOM, bsp);
    Verifai.are_equal(chopped, Chop.Rect.{0, 80, 100, 20}, Chop.compare_rect);
    Verifai.are_equal(remainder, Chop.Rect.{0, 0, 100, 80}, Chop.compare_rect);

    Verifai.are_equal(bsp.root.data.direction, Chop.Direction.BOTTOM);

    print_expression(*builder, bsp.root.data.expression);
    expr_str := builder_to_string(*builder);
    Verifai.are_equal(expr_str, "ifx flag 20;\n else 10;\n");

    Verifai.is_null(bsp.root.left.data.expression);
    Verifai.are_equal(bsp.root.left.data.direction, Chop.Direction.NONE);

    Verifai.is_null(bsp.root.right.data.expression);
    Verifai.are_equal(bsp.root.right.data.direction, Chop.Direction.NONE);
} @Test

// ------------------------------------------------------------------------------------------------------------

bsp_bisect_root_check_path_test :: ()
{
    setup := context.setup_data.(*BSP_One_Chop_Test_Setup_Data);
    using setup;

    chopped, remainder := Chop.chop(root_rect, 20, .LEFT, bsp);

    path: [..] *Chop.Node;

    left := BSP.find_leaf_containing_point(bsp, 0, 0, Chop.node_contains_point, *path);
    Verifai.are_equal(left.data.rect, chopped, Chop.compare_rect);
    Verifai.are_equal(path.count, 1);
    Verifai.are_equal(path[0], bsp.root);

    array_reset(*path);

    right := BSP.find_leaf_containing_point(bsp, 50, 50, Chop.node_contains_point, *path);
    Verifai.are_equal(right.data.rect, remainder, Chop.compare_rect);
    Verifai.are_equal(path.count, 1);
    Verifai.are_equal(path[0], bsp.root);
} @Test

#scope_file
Verifai :: #import "Verifai";
Chop    :: #import "ChopSUI";
BSP     :: #import "BSP";

#import "Program_Print";
#import "Basic";
