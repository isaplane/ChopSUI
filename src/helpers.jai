get_xmax :: inline (rect: Rect) -> int
{
    return rect.x + rect.w - 1;
}

get_ymax :: inline (rect: Rect) -> int
{
    return rect.y + rect.h - 1;
}

compare_rect :: (rect_a: Rect, rect_b: Rect) -> bool
{
    return (rect_a.x == rect_b.x) && (rect_a.y == rect_b.y) && (rect_a.w == rect_b.w) && (rect_a.h == rect_b.h);
}
