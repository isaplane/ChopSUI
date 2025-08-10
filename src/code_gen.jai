generate_rect_struct_decl :: (rect: Rect, struct_name: string, bsp: *Tree) -> string
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
