get_layout_proc_location :: () {}

Test_Layout_1_Data :: struct 
{
    using #as data: Chop.UI_Data;
}

test_layout_1 :: (data: Test_Layout_1_Data)
{
    rect: Chop.Rect = .{0, 0, 100, 100};
    foo, bar := Chop.chop(rect, 50, .LEFT, bsp = data.bsp);
}

#scope_file
Chop :: #import "ChopSUI";
