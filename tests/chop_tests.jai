Chop_Left_Test_Case :: struct
{
    start_rect: Chop.Rect;
    amount: int;

    left_rect: Chop.Rect;
    remainder_rect: Chop.Rect;
}

chop_left_test_cases: [] Chop_Left_Test_Case = .[
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 50,
        left_rect = .{0, 0, 50, 100},
        remainder_rect = .{50, 0, 50, 100}
    },
    .{
        start_rect = .{-100, -100, 200, 200},
        amount = 50,
        left_rect = .{-100, -100, 50, 200},
        remainder_rect = .{-50, -100, 150, 200}
    },
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 99,
        left_rect = .{0, 0, 99, 100},
        remainder_rect = .{99, 0, 1, 100}
    },
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 100,
        left_rect = .{0, 0, 0, 0},
        remainder_rect = .{0, 0, 100, 100}
    },
];

chop_left_test :: (c: Chop_Left_Test_Case)
{
    left, remainder := Chop.chop_left(c.start_rect, c.amount);

    Verifai.are_equal(left, c.left_rect, Chop.compare_rect);
    Verifai.are_equal(remainder, c.remainder_rect, Chop.compare_rect);
} @Test

// ------------------------------------------------------------------------------------------------------------

Chop_Right_Test_Case :: struct
{
    start_rect: Chop.Rect;
    amount: int;

    right_rect: Chop.Rect;
    remainder_rect: Chop.Rect;
}

chop_right_test_cases: [] Chop_Right_Test_Case = .[
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 50,
        right_rect = .{50, 0, 50, 100},
        remainder_rect = .{0, 0, 50, 100}
    },
    .{
        start_rect = .{-100, -100, 200, 200},
        amount = 50,
        right_rect = .{50, -100, 50, 200},
        remainder_rect = .{-100, -100, 150, 200}
    },
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 99,
        right_rect = .{1, 0, 99, 100},
        remainder_rect = .{0, 0, 1, 100}
    },
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 100,
        right_rect = .{0, 0, 0, 0},
        remainder_rect = .{0, 0, 100, 100}
    },
];

chop_right_test :: (c: Chop_Right_Test_Case)
{
    right, remainder := Chop.chop_right(c.start_rect, c.amount);

    Verifai.are_equal(right, c.right_rect, Chop.compare_rect);
    Verifai.are_equal(remainder, c.remainder_rect, Chop.compare_rect);
} @Test

// ------------------------------------------------------------------------------------------------------------

Chop_Top_Test_Case :: struct
{
    start_rect: Chop.Rect;
    amount: int;

    top_rect: Chop.Rect;
    remainder_rect: Chop.Rect;
}

chop_top_test_cases: [] Chop_Top_Test_Case = .[
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 50,
        top_rect = .{0, 0, 100, 50},
        remainder_rect = .{0, 50, 100, 50}
    },
    .{
        start_rect = .{-100, -100, 200, 200},
        amount = 50,
        top_rect = .{-100, -100, 200, 50},
        remainder_rect = .{-100, -50, 200, 150}
    },
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 99,
        top_rect = .{0, 0, 100, 99},
        remainder_rect = .{0, 99, 100, 1}
    },
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 100,
        top_rect = .{0, 0, 0, 0},
        remainder_rect = .{0, 0, 100, 100}
    },
];

chop_top_test :: (c: Chop_Top_Test_Case)
{
    top, remainder := Chop.chop_top(c.start_rect, c.amount);

    Verifai.are_equal(top, c.top_rect, Chop.compare_rect);
    Verifai.are_equal(remainder, c.remainder_rect, Chop.compare_rect);
} @Test

// ------------------------------------------------------------------------------------------------------------

Chop_Bottom_Test_Case :: struct
{
    start_rect: Chop.Rect;
    amount: int;

    bottom_rect: Chop.Rect;
    remainder_rect: Chop.Rect;
}

chop_bottom_test_cases: [] Chop_Bottom_Test_Case = .[
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 50,
        bottom_rect = .{0, 50, 100, 50},
        remainder_rect = .{0, 0, 100, 50}
    },
    .{
        start_rect = .{-100, -100, 200, 200},
        amount = 50,
        bottom_rect = .{-100, 50, 200, 50},
        remainder_rect = .{-100, -100, 200, 150}
    },
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 99,
        bottom_rect = .{0, 1, 100, 99},
        remainder_rect = .{0, 0, 100, 1}
    },
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 100,
        bottom_rect = .{0, 0, 0, 0},
        remainder_rect = .{0, 0, 100, 100}
    },
];

chop_bottom_test :: (c: Chop_Bottom_Test_Case)
{
    bottom, remainder := Chop.chop_bottom(c.start_rect, c.amount);

    Verifai.are_equal(bottom, c.bottom_rect, Chop.compare_rect);
    Verifai.are_equal(remainder, c.remainder_rect, Chop.compare_rect);
} @Test

// ------------------------------------------------------------------------------------------------------------

Chop_Rect_Test_Case :: struct
{
    start_rect: Chop.Rect;
    margins: Chop.Margins;

    inner_rect: Chop.Rect;
    outer_rects: [4] Chop.Rect;
}

chop_rect_test_cases: [] Chop_Rect_Test_Case = .[
    .{
        start_rect = .{0, 0, 100, 100},
        margins = .{10, 10, 10, 10},
        inner_rect = .{10, 10, 80, 80},
        outer_rects = .[
            .{0, 0, 10, 100},
            .{90, 0, 10, 100},
            .{10, 0, 80, 10},
            .{10, 90, 80, 10}
        ]
    },
    .{
        start_rect = .{-100, -100, 200, 200},
        margins = .{5, 10, 15, 20},
        inner_rect = .{-95, -85, 185, 165},
        outer_rects = .[
            .{-100, -100, 5, 200},
            .{90, -100, 10, 200},
            .{-95, -100, 185, 15},
            .{-95, 80, 185, 20}
        ]
    },
    .{
        start_rect = .{0, 0, 100, 100},
        margins = .{49, 50, 49, 50},
        inner_rect = .{49, 49, 1, 1},
        outer_rects = .[
            .{0, 0, 49, 100},
            .{50, 0, 50, 100},
            .{49, 0, 1, 49},
            .{49, 50, 1, 50}
        ]
    },
    .{
        start_rect = .{0, 0, 100, 100},
        margins = .{50, 50, 50, 50},
        inner_rect = .{50, 50, 50, 50},
        outer_rects = .[
            .{0, 0, 50, 100},
            .{0, 0, 0, 0},
            .{50, 0, 50, 50},
            .{0, 0, 0, 0}
        ]
    },
];

chop_rect_test :: (c: Chop_Rect_Test_Case)
{
    inner, outer := Chop.chop_rect(c.start_rect, c.margins);

    Verifai.are_equal(inner, c.inner_rect, Chop.compare_rect);

    for 0..3 
        Verifai.are_equal(outer[it], c.outer_rects[it], Chop.compare_rect);
} @Test

// ------------------------------------------------------------------------------------------------------------

Chop_Test_Case :: struct
{
    start_rect: Chop.Rect;
    direction:  Chop.Direction;

    amount: int;

    chopped_exp:   Chop.Rect;
    remainder_exp: Chop.Rect;
}

chop_test_cases: [] Chop_Test_Case = .[
    .{
        start_rect = .{0, 0, 100, 100},
        direction = .LEFT,

        amount = 20,

        chopped_exp = .{0, 0, 20, 100},
        remainder_exp = .{20, 0, 80, 100},
    },
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 30,
        direction = .RIGHT,

        chopped_exp = .{70, 0, 30, 100},
        remainder_exp = .{0, 0, 70, 100},
    },
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 40,
        direction = .TOP,

        chopped_exp = .{0, 0, 100, 40},
        remainder_exp = .{0, 40, 100, 60},
    },
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 55,
        direction = .BOTTOM,

        chopped_exp = .{0, 45, 100, 55},
        remainder_exp = .{0, 0, 100, 45},
    },
    .{
        start_rect = .{0, 0, 100, 100},
        amount = 50,
        direction = .NONE,

        chopped_exp = .{},
        remainder_exp = .{0, 0, 100, 100},
    },
];

chop_test :: (c: Chop_Test_Case)
{
    chopped, remainder := Chop.chop(c.start_rect, c.amount, c.direction);
    Verifai.are_equal(chopped, c.chopped_exp, Chop.compare_rect);
    Verifai.are_equal(remainder, c.remainder_exp, Chop.compare_rect);
} @Test

// ------------------------------------------------------------------------------------------------------------

x :: 10;

Chop_Expression_Add_Constant_Test :: ()
{
    chopped, remainder := Chop.chop(Chop.Rect.{0, 0, 100, 100}, x + 10, .LEFT);
    Verifai.are_equal(chopped, Chop.Rect.{0, 0, 20, 100}, Chop.compare_rect);
    Verifai.are_equal(remainder, Chop.Rect.{20, 0, 80, 100}, Chop.compare_rect);
} @Test

// ------------------------------------------------------------------------------------------------------------

Chop_Expression_Rect_Percentage_Test :: ()
{
    rect := Chop.Rect.{0, 0, 100, 100};
    chopped, remainder := Chop.chop(rect, cast(int)(0.2 * rect.w), .LEFT);
    Verifai.are_equal(chopped, Chop.Rect.{0, 0, 20, 100}, Chop.compare_rect);
    Verifai.are_equal(remainder, Chop.Rect.{20, 0, 80, 100}, Chop.compare_rect);
} @Test

// ------------------------------------------------------------------------------------------------------------

get_amount_to_chop :: (percent: float, dimension: int) -> int 
{
    return xx Math.floor(percent * dimension);
}

Chop_Expression_Proc_Return_Test :: ()
{
    rect := Chop.Rect.{0, 0, 100, 100};
    chopped, remainder := Chop.chop(rect, get_amount_to_chop(0.2, rect.w), .LEFT);
    Verifai.are_equal(chopped, Chop.Rect.{0, 0, 20, 100}, Chop.compare_rect);
    Verifai.are_equal(remainder, Chop.Rect.{20, 0, 80, 100}, Chop.compare_rect);
} @Test

// ------------------------------------------------------------------------------------------------------------


#scope_file

Verifai :: #import "Verifai";
Chop    :: #import "ChopSUI";
Math    :: #import "Math";
