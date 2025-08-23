Rect :: struct
{
    x, y: int;
    w, h: int;
}

Sym_Rect :: struct
{
    x_str := "root.x";
    y_str := "root.y";
    w_str := "root.w";
    h_str := "root.h";
}

Direction :: enum u8
{
    NONE;
    LEFT;
    RIGHT;
    TOP;
    BOTTOM;
}

Margins :: struct
{
    left, right, top, bottom: u32;
}

Node :: BSP.Node(Node_Data);
Tree :: BSP.Tree(Node);

#if IS_BAKING #add_context bsp: *Tree;

Node_Data :: struct
{
    ident:     string;
    rect:      Rect;
    direction: Direction;

    using sym_rect: Sym_Rect;
}

UI_Data :: struct
{
    root: Rect;
}

#scope_file
BSP :: #import "BSP";
