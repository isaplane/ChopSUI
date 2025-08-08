BSP_Two_Chop_Test_Setup_Data :: struct
{
    bsp:      *Chop.Tree;
    root_rect: Chop.Rect;
    builder: String_Builder;

    left:   Chop.Rect;
    right:  Chop.Rect;
    top:    Chop.Rect;
    bottom: Chop.Rect;
}

setup_bsp_two_chop_tests :: ()
{
    setup := New(BSP_Two_Chop_Test_Setup_Data);
    rect: Chop.Rect = .{0, 0, 100, 100};
    setup.* = .{
        bsp = BSP.get_new_tree(Chop.Node_Data.{rect = rect}),
        root_rect = rect
    };

    setup.left, setup.right = Chop.chop(rect, 50, .LEFT, setup.bsp);
    setup.top, setup.bottom = Chop.chop(setup.right, 75, .TOP, setup.bsp);

    context.setup_data = setup;
} @Setup

teardown_bsp_two_chop_tests :: ()
{
    setup := context.setup_data.(*BSP_Two_Chop_Test_Setup_Data);
    BSP.free_tree(setup.bsp);
} @Teardown

// ------------------------------------------------------------------------------------------------------------

bsp_bisect_rect_test :: ()
{
    using setup := context.setup_data.(*BSP_Two_Chop_Test_Setup_Data);

    Verifai.are_equal(setup.left, Chop.Rect.{0, 0, 50, 100}, Chop.compare_rect);
    Verifai.are_equal(setup.right, Chop.Rect.{50, 0, 50, 100}, Chop.compare_rect);
    Verifai.are_equal(setup.top, Chop.Rect.{50, 0, 50, 75}, Chop.compare_rect);
    Verifai.are_equal(setup.bottom, Chop.Rect.{50, 75, 50, 25}, Chop.compare_rect);
} @Test

// ------------------------------------------------------------------------------------------------------------

bsp_bisect_node_data_test :: ()
{
    using setup := context.setup_data.(*BSP_Two_Chop_Test_Setup_Data);

    Verifai.are_equal(bsp.root.data.direction, Chop.Direction.LEFT);
    print_expression(*builder, bsp.root.data.expression);
    Verifai.are_equal(builder_to_string(*builder), "50");

    Verifai.are_equal(bsp.root.left.data.direction, Chop.Direction.NONE);

    Verifai.are_equal(bsp.root.right.data.direction, Chop.Direction.TOP);
    print_expression(*builder, bsp.root.right.data.expression);
    Verifai.are_equal(builder_to_string(*builder), "75");
} @Test

// ------------------------------------------------------------------------------------------------------------

bsp_bisect_find_node_test :: ()
{
    using setup := context.setup_data.(*BSP_Two_Chop_Test_Setup_Data);

    left_node := BSP.find_leaf_containing_point(bsp, 25, 50, Chop.node_contains_point);
    Verifai.are_equal(bsp.root.left, left_node);

    left_node = BSP.find_leaf_containing_point(bsp, 0, 0, Chop.node_contains_point);
    Verifai.are_equal(bsp.root.left, left_node);

    left_node = BSP.find_leaf_containing_point(bsp, 49, 99, Chop.node_contains_point);
    Verifai.are_equal(bsp.root.left, left_node);

    right_top_node := BSP.find_leaf_containing_point(bsp, 75, 50, Chop.node_contains_point);
    Verifai.are_equal(bsp.root.right.left, right_top_node);

    right_top_node = BSP.find_leaf_containing_point(bsp, 50, 0, Chop.node_contains_point);
    Verifai.are_equal(bsp.root.right.left, right_top_node);

    right_top_node = BSP.find_leaf_containing_point(bsp, 50, 74, Chop.node_contains_point);
    Verifai.are_equal(bsp.root.right.left, right_top_node);

    right_bottom_node := BSP.find_leaf_containing_point(bsp, 75, 85, Chop.node_contains_point);
    Verifai.are_equal(bsp.root.right.right, right_bottom_node);

    right_bottom_node = BSP.find_leaf_containing_point(bsp, 50, 75, Chop.node_contains_point);
    Verifai.are_equal(bsp.root.right.right, right_bottom_node);

    right_bottom_node = BSP.find_leaf_containing_point(bsp, 99, 99, Chop.node_contains_point);
    Verifai.are_equal(bsp.root.right.right, right_bottom_node);
} @Test

// ------------------------------------------------------------------------------------------------------------

bsp_bisect_find_node_check_rect_test :: ()
{
    using setup := context.setup_data.(*BSP_Two_Chop_Test_Setup_Data);

    left_node := BSP.find_leaf_containing_point(bsp, 25, 50, Chop.node_contains_point);
    Verifai.are_equal(left_node.data.rect, left, Chop.compare_rect);

    right_top_node := BSP.find_leaf_containing_point(bsp, 75, 50, Chop.node_contains_point);
    Verifai.are_equal(right_top_node.data.rect, top, Chop.compare_rect);

    right_bottom_node := BSP.find_leaf_containing_point(bsp, 75, 85, Chop.node_contains_point);
    Verifai.are_equal(right_bottom_node.data.rect, bottom, Chop.compare_rect);
} @Test

// ------------------------------------------------------------------------------------------------------------

bsp_bisect_check_path_test :: ()
{
    using setup := context.setup_data.(*BSP_Two_Chop_Test_Setup_Data);

    path: [..] *Chop.Node;

    left_node := BSP.find_leaf_containing_point(bsp, 0, 0, Chop.node_contains_point, *path);
    Verifai.are_equal(left_node.data.rect, left, Chop.compare_rect);
    Verifai.are_equal(path.count, 1);
    Verifai.are_equal(path[0], bsp.root);

    array_reset(*path);

    right_top_node := BSP.find_leaf_containing_point(bsp, 50, 0, Chop.node_contains_point, *path);
    Verifai.are_equal(right_top_node.data.rect, top, Chop.compare_rect);
    Verifai.are_equal(path.count, 2);
    Verifai.are_equal(path[0], bsp.root);
    Verifai.are_equal(path[1], bsp.root.right);
    Verifai.are_equal(path[1].data.rect, right, Chop.compare_rect);

    array_reset(*path);

    right_bottom_node := BSP.find_leaf_containing_point(bsp, 99, 99, Chop.node_contains_point, *path);
    Verifai.are_equal(right_bottom_node.data.rect, bottom, Chop.compare_rect);
    Verifai.are_equal(path.count, 2);
    Verifai.are_equal(path[0], bsp.root);
    Verifai.are_equal(path[1], bsp.root.right);
    Verifai.are_equal(path[1].data.rect, right, Chop.compare_rect);
} @Test

#scope_file
Verifai :: #import "Verifai";
Chop    :: #import "ChopSUI";
BSP     :: #import "BSP";

#import "Program_Print";
#import "Basic";
