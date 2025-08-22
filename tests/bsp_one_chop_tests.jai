// BSP_One_Chop_Test_Setup_Data :: struct
// {
//     bsp:     *Chop.Tree;
//     root:    Chop.Rect;
//     builder: String_Builder;
// }
//
// setup_bsp_one_chop_tests :: ()
// {
//     setup := New(BSP_One_Chop_Test_Setup_Data);
//     rect := Chop.Rect.{0, 0, 100, 100};
//     setup.* = .{
//         bsp = BSP.get_new_tree(Chop.Node_Data.{rect = rect}),
//         root = rect
//     };
//
//     context.setup_data = setup;
// } @Setup
//
// teardown_bsp_one_chop_tests :: ()
// {
//     setup := context.setup_data.(*BSP_One_Chop_Test_Setup_Data);
//     BSP.free_tree(setup.bsp);
//
//     reset_temporary_storage();
// } @Teardown
//
// check_root_sym_rect :: (using node: Chop.Node)
// {
//     Verifai.are_equal(data.x_str, "root.x");
//     Verifai.are_equal(data.y_str, "root.y");
//     Verifai.are_equal(data.w_str, "root.w");
//     Verifai.are_equal(data.h_str, "root.h");
// }
//
// // ------------------------------------------------------------------------------------------------------------
//
// bsp_bisect_root_none_test :: ()
// {
//     setup := context.setup_data.(*BSP_One_Chop_Test_Setup_Data);
//     using setup;
//
//     chopped, remainder := Chop.chop(root, 20, .NONE, bsp);
//     Verifai.are_equal(chopped, Chop.Rect.{0, 0, 0, 0}, Chop.compare_rect);
//     Verifai.are_equal(remainder, Chop.Rect.{0, 0, 100, 100}, Chop.compare_rect);
//     Verifai.is_null(bsp.root.left);
//     Verifai.is_null(bsp.root.right);
//
//     check_root_sym_rect(bsp.root);
//
//     Verifai.are_equal(bsp.root.data.direction, Chop.Direction.NONE);
// } @Test
//
// // ------------------------------------------------------------------------------------------------------------
//
// bsp_bisect_root_left_test :: ()
// {
//     setup := context.setup_data.(*BSP_One_Chop_Test_Setup_Data);
//     using setup;
//
//     chopped, remainder := Chop.chop(root, 20, .LEFT, bsp);
//     Verifai.are_equal(chopped, Chop.Rect.{0, 0, 20, 100}, Chop.compare_rect);
//     Verifai.are_equal(remainder, Chop.Rect.{20, 0, 80, 100}, Chop.compare_rect);
//
//     Verifai.are_equal(bsp.root.data.direction, Chop.Direction.LEFT);
//
//     check_root_sym_rect(bsp.root);
//
//     left, right: *Chop.Node;
//
//     left = BSP.find_leaf_containing_point(bsp, 0, 0, Chop.node_contains_point);
//     right = BSP.find_leaf_containing_point(bsp, 20, 0, Chop.node_contains_point);
//     Verifai.are_equal(chopped, left.data.rect, Chop.compare_rect);
//     Verifai.are_equal(remainder, right.data.rect, Chop.compare_rect);
//
//     {
//         using left.data;
//         Verifai.are_equal(direction, Chop.Direction.NONE);
//
//         w_str_exp :: "20";
//
//         x_str_exp :: "root.x";
//         y_str_exp :: "root.y";
//         h_str_exp :: "root.h";
//
//         Verifai.are_equal(x_str, x_str_exp);
//         Verifai.are_equal(y_str, y_str_exp);
//         Verifai.are_equal(w_str, w_str_exp);
//         Verifai.are_equal(h_str, h_str_exp);
//
//         #insert #run tprint("rect_resolved: Chop.Rect = .{%, %, %, %};", x_str_exp, y_str_exp, w_str_exp, h_str_exp);
//         Verifai.are_equal(rect, rect_resolved, Chop.compare_rect);
//     }
//     {
//         using right.data;
//         Verifai.are_equal(direction, Chop.Direction.NONE);
//
//         x_str_exp :: "root.x + 20";
//         w_str_exp :: "root.w - (20)";
//
//         y_str_exp :: "root.y";
//         h_str_exp :: "root.h";
//
//         Verifai.are_equal(x_str, x_str_exp);
//         Verifai.are_equal(y_str, y_str_exp);
//         Verifai.are_equal(w_str, w_str_exp);
//         Verifai.are_equal(h_str, h_str_exp);
//
//         #insert #run tprint("rect_resolved: Chop.Rect = .{%, %, %, %};", x_str_exp, y_str_exp, w_str_exp, h_str_exp);
//         Verifai.are_equal(rect, rect_resolved, Chop.compare_rect);
//     }
//
//     left = BSP.find_leaf_containing_point(bsp, 19, 99, Chop.node_contains_point);
//     right = BSP.find_leaf_containing_point(bsp, 99, 99, Chop.node_contains_point);
//     Verifai.are_equal(chopped, left.data.rect, Chop.compare_rect);
//     Verifai.are_equal(remainder, right.data.rect, Chop.compare_rect);
//
//     left = BSP.find_leaf_containing_point(bsp, -1, -1, Chop.node_contains_point);
//     right = BSP.find_leaf_containing_point(bsp, 100, 100, Chop.node_contains_point);
//     Verifai.is_null(left);
//     Verifai.is_null(right);
// } @Test
//
// // ------------------------------------------------------------------------------------------------------------
//
// bsp_bisect_root_right_test :: ()
// {
//     setup := context.setup_data.(*BSP_One_Chop_Test_Setup_Data);
//     using setup;
//
//     chopped, remainder := Chop.chop(root, 30, .RIGHT, bsp);
//     Verifai.are_equal(chopped, Chop.Rect.{70, 0, 30, 100}, Chop.compare_rect);
//     Verifai.are_equal(remainder, Chop.Rect.{0, 0, 70, 100}, Chop.compare_rect);
//
//     Verifai.are_equal(bsp.root.data.direction, Chop.Direction.RIGHT);
//     check_root_sym_rect(bsp.root);
//
//     {
//         using bsp.root.left.data;
//         Verifai.are_equal(direction, Chop.Direction.NONE);
//
//         x_str_exp :: "Chop.get_xmax(Chop.Rect.{root.x, root.y, root.w, root.h}) + 1 - 30";
//         w_str_exp :: "30";
//
//         y_str_exp :: "root.y";
//         h_str_exp :: "root.h";
//
//         Verifai.are_equal(x_str, x_str_exp);
//         Verifai.are_equal(y_str, y_str_exp);
//         Verifai.are_equal(w_str, w_str_exp);
//         Verifai.are_equal(h_str, h_str_exp);
//
//         #insert #run tprint("rect_resolved: Chop.Rect = .{%, %, %, %};", x_str_exp, y_str_exp, w_str_exp, h_str_exp);
//         Verifai.are_equal(rect, rect_resolved, Chop.compare_rect);
//     }
//     {
//         using bsp.root.right.data;
//         Verifai.are_equal(direction, Chop.Direction.NONE);
//
//         w_str_exp :: "root.w - (30)";
//
//         x_str_exp :: "root.x";
//         y_str_exp :: "root.y";
//         h_str_exp :: "root.h";
//
//         Verifai.are_equal(x_str, x_str_exp);
//         Verifai.are_equal(y_str, y_str_exp);
//         Verifai.are_equal(w_str, w_str_exp);
//         Verifai.are_equal(h_str, h_str_exp);
//
//         #insert #run tprint("rect_resolved: Chop.Rect = .{%, %, %, %};", x_str_exp, y_str_exp, w_str_exp, h_str_exp);
//         Verifai.are_equal(rect, rect_resolved, Chop.compare_rect);
//     }
//
// } @Test
//
// // ------------------------------------------------------------------------------------------------------------
//
// bsp_bisect_root_top_test :: ()
// {
//     setup := context.setup_data.(*BSP_One_Chop_Test_Setup_Data);
//     using setup;
//
//     chopped, remainder := Chop.chop(root, 40, .TOP, bsp);
//     Verifai.are_equal(chopped, Chop.Rect.{0, 0, 100, 40}, Chop.compare_rect);
//     Verifai.are_equal(remainder, Chop.Rect.{0, 40, 100, 60}, Chop.compare_rect);
//
//     Verifai.are_equal(bsp.root.data.direction, Chop.Direction.TOP);
//
//     {
//         using bsp.root.left.data;
//         Verifai.are_equal(direction, Chop.Direction.NONE);
//
//         h_str_exp :: "40";
//
//         x_str_exp :: "root.x";
//         y_str_exp :: "root.y";
//         w_str_exp :: "root.w";
//
//         Verifai.are_equal(x_str, x_str_exp);
//         Verifai.are_equal(y_str, y_str_exp);
//         Verifai.are_equal(w_str, w_str_exp);
//         Verifai.are_equal(h_str, h_str_exp);
//
//         #insert #run tprint("rect_resolved: Chop.Rect = .{%, %, %, %};", x_str_exp, y_str_exp, w_str_exp, h_str_exp);
//         Verifai.are_equal(rect, rect_resolved, Chop.compare_rect);
//     }
//     {
//         using bsp.root.right.data;
//         Verifai.are_equal(direction, Chop.Direction.NONE);
//
//         y_str_exp :: "root.y + 40";
//         h_str_exp :: "root.h - (40)";
//
//         x_str_exp :: "root.x";
//         w_str_exp :: "root.w";
//
//         Verifai.are_equal(x_str, x_str_exp);
//         Verifai.are_equal(y_str, y_str_exp);
//         Verifai.are_equal(w_str, w_str_exp);
//         Verifai.are_equal(h_str, h_str_exp);
//
//         #insert #run tprint("rect_resolved: Chop.Rect = .{%, %, %, %};", x_str_exp, y_str_exp, w_str_exp, h_str_exp);
//         Verifai.are_equal(rect, rect_resolved, Chop.compare_rect);
//     }
//
// } @Test
//
// // ------------------------------------------------------------------------------------------------------------
//
// bsp_bisect_root_bottom_test :: ()
// {
//     setup := context.setup_data.(*BSP_One_Chop_Test_Setup_Data);
//     using setup;
//
//     flag := true;
//     chopped, remainder := Chop.chop(root, 20, .BOTTOM, bsp);
//     Verifai.are_equal(chopped, Chop.Rect.{0, 80, 100, 20}, Chop.compare_rect);
//     Verifai.are_equal(remainder, Chop.Rect.{0, 0, 100, 80}, Chop.compare_rect);
//
//     Verifai.are_equal(bsp.root.data.direction, Chop.Direction.BOTTOM);
//
//     {
//         using bsp.root.left.data;
//         Verifai.are_equal(direction, Chop.Direction.NONE);
//
//         y_str_exp :: "Chop.get_ymax(Chop.Rect.{root.x, root.y, root.w, root.h}) + 1 - 20";
//         h_str_exp :: "20";
//
//         x_str_exp :: "root.x";
//         w_str_exp :: "root.w";
//
//         Verifai.are_equal(x_str, x_str_exp);
//         Verifai.are_equal(y_str, y_str_exp);
//         Verifai.are_equal(w_str, w_str_exp);
//         Verifai.are_equal(h_str, h_str_exp);
//
//         #insert #run tprint("rect_resolved: Chop.Rect = .{%, %, %, %};", x_str_exp, y_str_exp, w_str_exp, h_str_exp);
//         Verifai.are_equal(rect, rect_resolved, Chop.compare_rect);
//     }
//     {
//         using bsp.root.right.data;
//         Verifai.are_equal(direction, Chop.Direction.NONE);
//
//         h_str_exp :: "root.h - (20)";
//
//         x_str_exp :: "root.x";
//         y_str_exp :: "root.y";
//         w_str_exp :: "root.w";
//
//         Verifai.are_equal(x_str, x_str_exp);
//         Verifai.are_equal(y_str, y_str_exp);
//         Verifai.are_equal(w_str, w_str_exp);
//         Verifai.are_equal(h_str, h_str_exp);
//
//         #insert #run tprint("rect_resolved: Chop.Rect = .{%, %, %, %};", x_str_exp, y_str_exp, w_str_exp, h_str_exp);
//         Verifai.are_equal(rect, rect_resolved, Chop.compare_rect);
//     }
// } @Test
//
// // ------------------------------------------------------------------------------------------------------------
//
// bsp_bisect_root_check_path_test :: ()
// {
//     setup := context.setup_data.(*BSP_One_Chop_Test_Setup_Data);
//     using setup;
//
//     chopped, remainder := Chop.chop(root, 20, .LEFT, bsp);
//
//     path: [..] *Chop.Node;
//
//     left := BSP.find_leaf_containing_point(bsp, 0, 0, Chop.node_contains_point, *path);
//     Verifai.are_equal(left.data.rect, chopped, Chop.compare_rect);
//     Verifai.are_equal(path.count, 1);
//     Verifai.are_equal(path[0], bsp.root);
//
//     array_reset(*path);
//
//     right := BSP.find_leaf_containing_point(bsp, 50, 50, Chop.node_contains_point, *path);
//     Verifai.are_equal(right.data.rect, remainder, Chop.compare_rect);
//     Verifai.are_equal(path.count, 1);
//     Verifai.are_equal(path[0], bsp.root);
// } @Test
//
// // ------------------------------------------------------------------------------------------------------------
// // Later add back tests for simple variable expressions: chopped, remainder := Chop.chop(root, x + 20, .RIGHT, bsp);
// // "                      " expressions that depend on other rects: chopped, remainder := Chop.chop(root, get_amount_to_chop(.4, root.h), .TOP, bsp);
// // "                      " ifx expresssions: chopped, remainder := Chop.chop(root, ifx flag then 20 else 10, .BOTTOM, bsp);
// // Also maybe move parts that test string gen to code gen test file
//
// #scope_file
// Verifai :: #import "Verifai";
// Chop    :: #import "ChopSUI";
// BSP     :: #import "BSP";
//
// #import "Program_Print";
// #import "Basic";
