get_layout_proc_location :: () {}

Test_Layout_Data :: struct 
{
    using #as ui_data: Chop.UI_Data;
    root = .{0, 0, 100, 100};
}

test_layout_simple_decl :: (using data: *Test_Layout_Data)
{
    bsp = Chop.init_bsp(root);

    foo := Chop.chop(root, 50, .LEFT, bsp = bsp);
    bar := Chop.chop(foo, 10, .TOP, bsp = bsp);

    path: [..] *Chop.Node;
    leaf := BSP.find_leaf_containing_point(bsp, x = 0, y = 0, Chop.node_contains_point);

    names := Array_Helpers.map(path, x => x.data.ident);
    print("Found path names: %\n", names);
}

test_layout_compound_decl :: (using data: *Test_Layout_Data)
{
    bsp = Chop.init_bsp(root);

    rect: Chop.Rect = .{0, 0, 100, 100};
    Foo, FOO, Bar, b: Chop.Rect;
    foo, bar := Chop.chop(root, 50, .LEFT, bsp = data.bsp);
    Foo, Bar =  Chop.chop(foo, 10, .TOP, bsp = data.bsp);
    FOO =, BAR := Chop.chop(bar, 10, .BOTTOM, bsp = data.bsp);
    f:, b = Chop.chop(Foo, 10, .RIGHT, bsp = data.bsp);
}

test_layout_assignments :: (using data: *Test_Layout_Data)
{
    bsp = Chop.init_bsp(root);

    rect: Chop.Rect = .{0, 0, 100, 100};
    foo, bar: Chop.Rect;
    foo = Chop.chop(root, 50, .LEFT, bsp = data.bsp);
    bar = Chop.chop(foo, 10, .RIGHT, bsp = data.bsp);
}

test_layout_calls :: (using data: *Test_Layout_Data)
{
    bsp = Chop.init_bsp(root);

    rect: Chop.Rect = .{0, 0, 100, 100};
    Chop.chop(root, 50, .LEFT, bsp = data.bsp);
}

#scope_file
Chop :: #import "ChopSUI";
BSP  :: #import "BSP";
Array_Helpers :: #import "Array_Helpers";
#import "Basic";
