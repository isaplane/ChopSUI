get_layout_proc_location :: () {}

Test_Layout_Data :: struct 
{
    using #as ui_data: Chop.UI_Data;
    root = .{0, 0, 100, 100};
}

test_layout_simple_decl :: (using data: Test_Layout_Data)
{
    bsp := context.bsp;
    foo := Chop.chop(root, 50, .LEFT);
    bar := Chop.chop(foo, 10, .TOP);

    path: [..] *Chop.Node;
    leaf := BSP.find_leaf_containing_point(bsp, 0, 0, Chop.node_contains_point, *path);

    names := Array_Helpers.map(path, x => x.data.ident);
    print("Found path names: %\n", names);
}

test_layout_compound_decl :: (using data: Test_Layout_Data)
{
    Foo, FOO, Bar, b: Chop.Rect;
    foo, bar := Chop.chop(root, 50, .LEFT);
    Foo, Bar =  Chop.chop(foo, 10, .TOP);
    FOO =, BAR := Chop.chop(bar, 10, .BOTTOM);
    f:, b = Chop.chop(Foo, 10, .RIGHT);
}

test_layout_assignments :: (using data: Test_Layout_Data)
{
    foo, bar: Chop.Rect;
    foo = Chop.chop(root, 50, .LEFT);
    bar = Chop.chop(foo, 10, .RIGHT);
}

test_layout_calls :: (using data: Test_Layout_Data)
{
    Chop.chop(root, 50, .LEFT);
}

#scope_file
Chop :: #import "ChopSUI"(IS_BAKING = true);
BSP  :: #import "BSP";
Array_Helpers :: #import "Array_Helpers";
#import "Basic";
