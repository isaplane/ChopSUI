find_rects_in_expression :: (expression: Code) -> [] *Code_Declaration
{
    rect_decls: [..] *Code_Declaration;
    root, expressions := compiler_get_nodes(expression);

    for expressions
    {
        if it.kind != .IDENT continue;

        decl := (cast(*Code_Ident) it).resolved_declaration;
        if !decl continue;

        if get_type(decl.type) == Rect array_add_if_unique(*rect_decls, decl);
    }

    return rect_decls;
}

write_node_rect_strings :: (amount: Code, node: *Node, left: *Node, right: *Node)
{
    root_expr, expressions := compiler_get_nodes(amount);

    rect_lit_str := sprint("Chop.Rect.{%, %, %, %}",
                            node.data.x_str,
                            node.data.y_str,
                            node.data.w_str,
                            node.data.h_str
    );

    builder: String_Builder;
    print_expression(*builder, root_expr); 
    expr_string := builder_to_string(*builder);

    if node.data.direction ==
    {
        case .LEFT;
            left.data.w_str = expr_string;

            left.data.x_str = node.data.x_str;
            left.data.y_str = node.data.y_str;
            left.data.h_str = node.data.h_str;

            right.data.w_str = sprint("% - (%)", node.data.w_str, expr_string);
            right.data.x_str = sprint("% + %", node.data.x_str, expr_string);

            right.data.y_str = node.data.y_str;
            right.data.h_str = node.data.h_str;

        case .RIGHT;
            left.data.w_str = expr_string;
            left.data.x_str = sprint("Chop.get_xmax(%) + 1 - %", rect_lit_str, expr_string);

            left.data.y_str = node.data.y_str;
            left.data.h_str = node.data.h_str;

            right.data.w_str = sprint("% - (%)", node.data.w_str, expr_string);

            right.data.x_str = node.data.x_str;
            right.data.y_str = node.data.y_str;
            right.data.h_str = node.data.h_str;

        case .TOP;
            left.data.h_str = expr_string;

            left.data.x_str = node.data.x_str;
            left.data.y_str = node.data.y_str;
            left.data.w_str = node.data.w_str;

            right.data.h_str = sprint("% - (%)", node.data.h_str, expr_string);
            right.data.y_str = sprint("% + %", node.data.y_str, expr_string);

            right.data.x_str = node.data.x_str;
            right.data.w_str = node.data.w_str;

        case .BOTTOM;
            left.data.h_str = expr_string;
            left.data.y_str = sprint("Chop.get_ymax(%) + 1 - %", rect_lit_str, expr_string);

            left.data.x_str = node.data.x_str;
            left.data.w_str = node.data.w_str;

            right.data.h_str = sprint("% - (%)", node.data.h_str, expr_string);

            right.data.x_str = node.data.x_str;
            right.data.y_str = node.data.y_str;
            right.data.w_str = node.data.w_str;
    }
}

bake_rect_struct_decl :: (rect: Rect, struct_name: string, bsp: *Tree) -> string
{
    // get path to node from tree (based on exact shape match, need to modify BSP)
    xc, yc := get_center(rect);
    path: [..] *Node;
    node := BSP.find_leaf_containing_point(bsp, xc, yc, node_contains_point, *path);

    if !compare_rect(rect, node.data.rect)
    {
        for path
        {
            node = it;
            if compare_rect(rect, node.data.rect) break;
        }
    }

    // insert strings to here string and sprint
    return sprint(struct_decl_template,
                      struct_name,
                      node.data.x_str,
                      node.data.y_str,
                      node.data.w_str,
                      node.data.h_str);    
}

struct_decl_template :: #string HERE
% :: ()
{
    x: int = %;
    y: int = %;
    w: int = %;
    h: int = %;
}
HERE

init_baked_rect :: (ui_data: $U/UI_Data, rect: $R) -> R #expand
{
    return #insert #run tprint("init_%(ui_data, rect);\n", R);
}

#scope_file

BSP :: #import "BSP";
