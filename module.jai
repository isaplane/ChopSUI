Rect :: struct
{
    x, y: int;
    w, h: int;
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
    rect:       Rect;
    expression: *Code_Node;
    direction:  Direction;
}

chop :: (rect: Rect, $amount: Code, direction: Direction, bsp: *BSP.Tree(Node) = null) -> chopped: Rect, remainder: Rect #expand
{
    root, expressions := compiler_get_nodes(amount);
    value := #insert amount;

    chopped, remainder: Rect;
    if direction ==
    {
        case .LEFT;   chopped, remainder = chop_left(rect, value);
        case .RIGHT;  chopped, remainder = chop_right(rect, value);
        case .TOP;    chopped, remainder = chop_top(rect, value);
        case .BOTTOM; chopped, remainder = chop_bottom(rect, value);

        case .NONE;
            log_error("Bad chop direction, .NONE\n");
            return .{}, rect;
    }

    if bsp
    {
        x_center, y_center := get_center(rect);
        using node := BSP.find_leaf_containing_point(bsp, x_center, y_center, node_contains_point);
        data.expression = root;
        data.direction = direction;

        BSP.bisect_node(bsp, node, .{rect = chopped}, .{rect = remainder});
    }

    return chopped, remainder;
}

chop_rect :: (rect: Rect, margins: Margins) -> inner: Rect, outer: [4] Rect
{
    inner := rect;
    outer: [4] Rect;

    if margins.left > 0     outer[0], inner = chop_left(inner, margins.left);  
    if margins.right > 0    outer[1], inner = chop_right(inner, margins.right);  
    if margins.top > 0      outer[2], inner = chop_top(inner, margins.top);  
    if margins.bottom > 0   outer[3], inner = chop_bottom(inner, margins.bottom);  

    return inner, outer;
}

chop_left :: (rect: Rect, amount: int) -> left: Rect, remainder: Rect 
{
    if rect.w - amount <= 0
    {
        log_error("Bad amount for chop_left. Wanted to chop %, rect width is %.\n", amount, rect.w);
        return .{}, rect;
    }

    remainder := rect;
    remainder.w -= amount;
    remainder.x += amount;

    left := rect;
    left.w = amount;

    return left, remainder;
}

chop_right :: (rect: Rect, amount: int) -> right: Rect, remainder: Rect 
{
    if rect.w - amount <= 0
    {
        log_error("Bad amount for chop_right. Wanted to chop %, rect width is %.\n", amount, rect.w);
        return .{}, rect;
    }

    remainder := rect;
    remainder.w -= amount;

    right := rect;
    right.w = amount;
    right.x = get_xmax(rect) + 1 - amount;

    return right, remainder;
}

chop_top :: (rect: Rect, amount: int) -> top: Rect, remainder: Rect 
{
    if rect.h - amount <= 0
    {
        log_error("Bad amount for chop_top. Wanted to chop %, rect height is %.\n", amount, rect.h);
        return .{}, rect;
    }

    remainder := rect;
    remainder.h -= amount;
    remainder.y += amount;

    top := rect;
    top.h = amount;

    return top, remainder;
}

chop_bottom :: (rect: Rect, amount: int) -> bottom: Rect, remainder: Rect 
{
    if rect.h - amount <= 0
    {
        log_error("Bad amount for chop_bottom. Wanted to chop %, rect height is %.\n", amount, rect.h);
        return .{}, rect;
    }

    remainder := rect;
    remainder.h -= amount;

    bottom := rect;
    bottom.h = amount;
    bottom.y = get_ymax(rect) + 1 - amount;

    return bottom, remainder;
}

#import "Basic";
#import "Compiler";
#import "Program_Print";
BSP :: #import "BSP";

#load "src/helpers.jai";
