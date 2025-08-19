Rect :: struct
{
    x, y: int;
    w, h: int;
}

Sym_Rect :: struct
{
    x_str := "root_rect.x";
    y_str := "root_rect.y";
    w_str := "root_rect.w";
    h_str := "root_rect.h";
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

Node_Data :: struct
{
    ident:     string;
    rect:      Rect;
    direction: Direction;

    using sym_rect: Sym_Rect;
}

UI_Data :: struct
{
    root_rect: Rect;
    bsp:       *Tree;
}

#scope_file
BSP :: #import "BSP";
