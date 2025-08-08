BSP_Root_Only_Test_Setup_Data :: struct
{
    bsp:      *Chop.Tree;
    root_rect: Chop.Rect;
    builder: String_Builder;
}

setup_bsp_root_only_tests :: ()
{
    setup := New(BSP_Root_Only_Test_Setup_Data);
    rect := Chop.Rect.{0, 0, 100, 100};
    setup.* = .{
        bsp = BSP.get_new_tree(Chop.Node_Data.{rect = rect}),
        root_rect = rect
    };

    context.setup_data = setup;
} @Setup

teardown_bsp_root_only_tests :: ()
{
    setup := context.setup_data.(*BSP_Root_Only_Test_Setup_Data);
    BSP.free_tree(setup.bsp);
} @Teardown

// ------------------------------------------------------------------------------------------------------------

bsp_root_test :: ()
{
    setup := context.setup_data.(*BSP_Root_Only_Test_Setup_Data);
    using setup;
    Verifai.are_equal(root_rect, bsp.root.data.rect, Chop.compare_rect);
} @Test

// ------------------------------------------------------------------------------------------------------------

BSP_Find_Root_Test_Case :: struct
{
    x, y: int;
    expect_null_root: bool;
}

BSP_Find_Root_Test_Cases: [] BSP_Find_Root_Test_Case = .[
    .{x = 50, y = 50, expect_null_root = false},
    .{x = 0, y = 0, expect_null_root = false},
    .{x = 99, y = 99, expect_null_root = false},
    .{x = 100, y = 100, expect_null_root = true},
    .{x = -1, y = -1, expect_null_root = true},
];

bsp_find_root_test :: (c: BSP_Find_Root_Test_Case)
{
    setup := context.setup_data.(*BSP_Root_Only_Test_Setup_Data);
    using setup;
    root := BSP.find_leaf_containing_point(bsp, c.x, c.y, Chop.node_contains_point);

    if c.expect_null_root 
        Verifai.is_null(root);
    else 
        Verifai.are_equal(root_rect, root.data.rect, Chop.compare_rect);
} @Test


#scope_file
Verifai :: #import "Verifai";
Chop    :: #import "ChopSUI";
BSP     :: #import "BSP";

#import "Program_Print";
#import "Basic";
