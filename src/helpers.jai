get_xmax :: inline (rect: Rect) -> int
{
    return rect.x + rect.w - 1;
}

get_ymax :: inline (rect: Rect) -> int
{
    return rect.y + rect.h - 1;
}

get_center :: inline (rect: Rect) -> x: int, y: int
{
    return rect.x + (rect.w/2), rect.y + (rect.h/2);
}

compare_rect :: (rect_a: Rect, rect_b: Rect) -> bool
{
    return (rect_a.x == rect_b.x) && (rect_a.y == rect_b.y) && (rect_a.w == rect_b.w) && (rect_a.h == rect_b.h);
}

node_contains_point :: (using data: Node_Data, x: int, y: int) -> bool
{
    return (x >= rect.x) && (x < rect.x + rect.w) && (y >= rect.y) && (y < rect.y + rect.h);
}
